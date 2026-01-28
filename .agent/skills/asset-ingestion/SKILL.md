---
name: asset-ingestion
description: Guides implementation of the asset ingestion feature in WealthScope. Use when working on document OCR, AI-assisted extraction, manual asset entry forms, or asset validation logic. Covers both backend (Go) and frontend (Flutter) implementation.
---

# Asset Ingestion Skill

## Overview

Asset ingestion is the process of adding assets to a user's portfolio. WealthScope supports two methods:

1. **Manual Entry**: Form-based input with validation
2. **AI-Assisted (OCR)**: Document scanning with GPT-4 Vision extraction

## Manual Asset Entry

### Backend Implementation

#### API Endpoint

```go
// POST /api/v1/assets
type CreateAssetRequest struct {
    Type          string   `json:"type" binding:"required,oneof=stock etf bond crypto real_estate gold other"`
    Symbol        *string  `json:"symbol" binding:"omitempty,max=20"`
    Name          string   `json:"name" binding:"required,max=255"`
    Quantity      float64  `json:"quantity" binding:"required,gt=0"`
    PurchasePrice float64  `json:"purchase_price" binding:"required,gte=0"`
    PurchaseDate  *string  `json:"purchase_date" binding:"omitempty,datetime=2006-01-02"`
    Currency      string   `json:"currency" binding:"omitempty,len=3"`
    Metadata      any      `json:"metadata" binding:"omitempty"`
}
```

#### Type-Specific Validation

| Type | Required Fields | Metadata Fields |
|------|-----------------|-----------------|
| stock/etf | symbol | exchange, sector |
| crypto | symbol | network, wallet |
| bond | name | coupon_rate, maturity_date |
| real_estate | name | property_type, location, area_sqm |
| gold | name | form, purity, weight_oz |

#### Use Case

```go
func (uc *CreateAssetUseCase) Execute(ctx context.Context, input CreateAssetInput) (*Asset, error) {
    // 1. Validate type-specific requirements
    if err := uc.validateByType(input); err != nil {
        return nil, err
    }
    
    // 2. Create asset entity
    asset := &Asset{
        ID:            uuid.New(),
        UserID:        input.UserID,
        Type:          AssetType(input.Type),
        Symbol:        input.Symbol,
        Name:          input.Name,
        Quantity:      decimal.NewFromFloat(input.Quantity),
        PurchasePrice: decimal.NewFromFloat(input.PurchasePrice),
        Currency:      input.Currency,
        Metadata:      input.Metadata,
    }
    
    // 3. Fetch current price for listed assets
    if asset.IsListed() {
        price, err := uc.pricingService.GetCurrentPrice(ctx, asset.Symbol)
        if err == nil {
            asset.CurrentPrice = &price
            asset.CurrentValue = asset.Quantity.Mul(price)
        }
    }
    
    // 4. Save to database
    if err := uc.repo.Create(ctx, asset); err != nil {
        return nil, fmt.Errorf("failed to save asset: %w", err)
    }
    
    return asset, nil
}
```

### Frontend Implementation

#### Asset Form Screen

```dart
class AddAssetScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<AddAssetScreen> createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends ConsumerState<AddAssetScreen> {
  final _formKey = GlobalKey<FormState>();
  AssetType? _selectedType;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Asset')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Asset type selector
            AssetTypeSelector(
              value: _selectedType,
              onChanged: (type) => setState(() => _selectedType = type),
            ),
            
            if (_selectedType != null) ...[
              const SizedBox(height: 16),
              // Dynamic fields based on type
              ..._buildFieldsForType(_selectedType!),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _submit,
            child: const Text('Add Asset'),
          ),
        ),
      ),
    );
  }
  
  List<Widget> _buildFieldsForType(AssetType type) {
    switch (type) {
      case AssetType.stock:
      case AssetType.etf:
        return [
          SymbolSearchField(onSelected: _onSymbolSelected),
          QuantityField(controller: _quantityController),
          PriceField(controller: _priceController),
        ];
      case AssetType.realEstate:
        return [
          NameField(controller: _nameController),
          AddressField(controller: _addressController),
          AreaField(controller: _areaController),
          PriceField(controller: _priceController, label: 'Purchase Price'),
        ];
      // ... other types
    }
  }
}
```

## AI-Assisted Ingestion (OCR)

### Backend Implementation

#### Upload Endpoint

```go
// POST /api/v1/assets/ingest
func (h *IngestHandler) Upload(c *gin.Context) {
    userID := c.GetString("user_id")
    
    // 1. Get file from request
    file, err := c.FormFile("file")
    if err != nil {
        c.JSON(400, errorResponse("INVALID_FILE", "No file provided"))
        return
    }
    
    // 2. Validate file
    if err := validateUpload(file); err != nil {
        c.JSON(400, errorResponse("INVALID_FILE", err.Error()))
        return
    }
    
    // 3. Upload to storage
    storagePath, err := h.storage.Upload(c, file)
    if err != nil {
        c.JSON(500, errorResponse("UPLOAD_FAILED", "Failed to upload file"))
        return
    }
    
    // 4. Create extraction record
    extraction := &DocumentExtraction{
        ID:        uuid.New(),
        UserID:    uuid.MustParse(userID),
        StoragePath: storagePath,
        Status:    "processing",
    }
    h.repo.Create(c, extraction)
    
    // 5. Process with AI (async or sync based on needs)
    result, err := h.aiService.ExtractFromDocument(c, storagePath)
    if err != nil {
        extraction.Status = "failed"
        extraction.ErrorMessage = err.Error()
        h.repo.Update(c, extraction)
        c.JSON(500, errorResponse("EXTRACTION_FAILED", "Failed to process document"))
        return
    }
    
    // 6. Store results
    extraction.Status = "pending_review"
    extraction.ExtractedData = result
    h.repo.Update(c, extraction)
    
    c.JSON(200, SuccessResponse{
        Data: ExtractionResponse{
            ExtractionID:    extraction.ID.String(),
            Status:          extraction.Status,
            ExtractedAssets: result.Assets,
        },
    })
}
```

#### AI Extraction Service

```go
const extractionPrompt = `You are a financial document analyzer. Extract all investment assets from this document.

For each asset found, return:
{
  "assets": [
    {
      "type": "stock|etf|bond|crypto|real_estate|gold|other",
      "symbol": "AAPL",
      "name": "Apple Inc.",
      "quantity": 10,
      "price": 150.00,
      "date": "2024-06-15",
      "confidence": 0.95,
      "source_text": "original text from document"
    }
  ],
  "document_type": "brokerage_statement|tax_form|receipt|other",
  "warnings": []
}

Be conservative with confidence scores. Omit assets where key data is uncertain.`

func (s *AIService) ExtractFromDocument(ctx context.Context, imageURL string) (*ExtractionResult, error) {
    resp, err := s.openai.CreateChatCompletion(ctx, openai.ChatCompletionRequest{
        Model: "gpt-4o",
        Messages: []openai.ChatCompletionMessage{
            {Role: "system", Content: extractionPrompt},
            {
                Role: "user",
                Content: []openai.ChatMessagePart{
                    {Type: "image_url", ImageURL: &openai.ChatMessageImageURL{URL: imageURL}},
                },
            },
        },
        MaxTokens:   1500,
        Temperature: 0.1,
    })
    
    if err != nil {
        return nil, fmt.Errorf("OpenAI API error: %w", err)
    }
    
    var result ExtractionResult
    if err := json.Unmarshal([]byte(resp.Choices[0].Message.Content), &result); err != nil {
        return nil, fmt.Errorf("failed to parse AI response: %w", err)
    }
    
    return &result, nil
}
```

#### Confirmation Endpoint

```go
// POST /api/v1/assets/ingest/{extraction_id}/confirm
type ConfirmExtractionRequest struct {
    ConfirmedAssets []ConfirmedAsset `json:"confirmed_assets"`
}

type ConfirmedAsset struct {
    Index     int             `json:"index"`
    Accept    bool            `json:"accept"`
    Overrides map[string]any  `json:"overrides,omitempty"`
}

func (h *IngestHandler) Confirm(c *gin.Context) {
    extractionID := c.Param("extraction_id")
    userID := c.GetString("user_id")
    
    var req ConfirmExtractionRequest
    if err := c.ShouldBindJSON(&req); err != nil {
        c.JSON(400, errorResponse("INVALID_REQUEST", err.Error()))
        return
    }
    
    // Get extraction
    extraction, err := h.repo.FindByID(c, extractionID)
    if err != nil || extraction.UserID.String() != userID {
        c.JSON(404, errorResponse("NOT_FOUND", "Extraction not found"))
        return
    }
    
    // Process confirmed assets
    createdAssets := []Asset{}
    for _, conf := range req.ConfirmedAssets {
        if !conf.Accept {
            continue
        }
        
        extracted := extraction.ExtractedData.Assets[conf.Index]
        
        // Apply overrides
        asset := buildAssetFromExtraction(extracted, conf.Overrides, userID)
        
        if err := h.assetRepo.Create(c, asset); err != nil {
            continue
        }
        
        createdAssets = append(createdAssets, *asset)
    }
    
    // Mark extraction as completed
    extraction.Status = "completed"
    h.repo.Update(c, extraction)
    
    c.JSON(201, SuccessResponse{Data: createdAssets})
}
```

### Frontend Implementation

#### Document Upload Screen

```dart
class DocumentUploadScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends ConsumerState<DocumentUploadScreen> {
  File? _selectedFile;
  bool _isProcessing = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Document')),
      body: Column(
        children: [
          // Image preview or placeholder
          Expanded(
            child: _selectedFile != null
                ? Image.file(_selectedFile!)
                : const _DocumentPlaceholder(),
          ),
          
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _takePhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                ),
              ],
            ),
          ),
          
          if (_selectedFile != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processDocument,
                child: _isProcessing
                    ? const CircularProgressIndicator()
                    : const Text('Extract Assets'),
              ),
            ),
        ],
      ),
    );
  }
  
  Future<void> _processDocument() async {
    setState(() => _isProcessing = true);
    
    try {
      final result = await ref.read(assetIngestionProvider).uploadDocument(_selectedFile!);
      
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExtractionReviewScreen(extraction: result),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to process: ${e.toString()}')),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }
}
```

#### Extraction Review Screen

```dart
class ExtractionReviewScreen extends ConsumerStatefulWidget {
  final ExtractionResult extraction;
  
  const ExtractionReviewScreen({required this.extraction, super.key});
  
  @override
  ConsumerState<ExtractionReviewScreen> createState() => _ExtractionReviewScreenState();
}

class _ExtractionReviewScreenState extends ConsumerState<ExtractionReviewScreen> {
  late List<bool> _accepted;
  late List<Map<String, dynamic>> _overrides;
  
  @override
  void initState() {
    super.initState();
    _accepted = List.filled(widget.extraction.assets.length, true);
    _overrides = List.generate(widget.extraction.assets.length, (_) => {});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review Extracted Assets')),
      body: ListView.builder(
        itemCount: widget.extraction.assets.length,
        itemBuilder: (context, index) {
          final asset = widget.extraction.assets[index];
          return _ExtractedAssetCard(
            asset: asset,
            accepted: _accepted[index],
            onAcceptChanged: (v) => setState(() => _accepted[index] = v),
            onEdit: () => _editAsset(index),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _confirm,
            child: Text('Add ${_accepted.where((a) => a).length} Assets'),
          ),
        ),
      ),
    );
  }
}
```

## Key Implementation Notes

1. **Always show confidence scores** - Users should know how certain the AI is
2. **Allow editing before confirmation** - Never auto-add without user approval
3. **Handle partial extraction** - Some assets may fail; don't fail the whole batch
4. **Cache symbol lookups** - Stock symbols are frequently repeated
5. **Validate against market data** - If extracted symbol doesn't exist, flag it
