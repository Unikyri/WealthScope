import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/assets/data/datasources/symbol_search_datasource.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';

/// Reusable symbol search field with debounced autocomplete dropdown.
///
/// For types with a catalog (stock, etf, crypto) it shows matching results
/// from [SymbolSearchDatasource]. For other types it renders a plain text field.
class SymbolSearchField extends StatefulWidget {
  const SymbolSearchField({
    required this.assetType,
    required this.onSymbolSelected,
    this.controller,
    this.initialValue,
    this.label = 'Symbol',
    this.validator,
    super.key,
  });

  final AssetType assetType;
  final void Function(SymbolInfo symbol) onSymbolSelected;
  final TextEditingController? controller;
  final String? initialValue;
  final String label;
  final String? Function(String?)? validator;

  @override
  State<SymbolSearchField> createState() => _SymbolSearchFieldState();
}

class _SymbolSearchFieldState extends State<SymbolSearchField> {
  late final TextEditingController _controller;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  Timer? _debounce;
  List<SymbolInfo> _results = [];
  bool _isDropdownOpen = false;

  bool get _hasCatalog =>
      widget.assetType == AssetType.stock ||
      widget.assetType == AssetType.etf ||
      widget.assetType == AssetType.crypto;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _removeOverlay();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String query) {
    if (!_hasCatalog) return;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final results = SymbolSearchDatasource.instance.search(query, widget.assetType);
      setState(() => _results = results);

      if (results.isNotEmpty && query.isNotEmpty) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    });
  }

  void _onSymbolTapped(SymbolInfo symbol) {
    _controller.text = symbol.symbol;
    widget.onSymbolSelected(symbol);
    _removeOverlay();
  }

  void _showOverlay() {
    _removeOverlay();

    final renderBox = context.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
          child: Material(
            color: AppTheme.cardGrey,
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 220),
              decoration: BoxDecoration(
                color: AppTheme.cardGrey,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: _results.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                  itemBuilder: (context, index) {
                    final s = _results[index];
                    return InkWell(
                      onTap: () => _onSymbolTapped(s),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            // Symbol badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.electricBlue.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                s.symbol,
                                style: const TextStyle(
                                  color: AppTheme.electricBlue,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Name
                            Expanded(
                              child: Text(
                                s.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Exchange
                            if (s.exchange != null)
                              Text(
                                s.exchange!,
                                style: TextStyle(
                                  color: AppTheme.textGrey,
                                  fontSize: 11,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isDropdownOpen = true;
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isDropdownOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            // Delay to allow tap on dropdown items
            Future.delayed(const Duration(milliseconds: 200), () {
              if (mounted && _isDropdownOpen) _removeOverlay();
            });
          }
        },
        child: TextFormField(
          controller: _controller,
          onChanged: _onTextChanged,
          validator: widget.validator,
          textCapitalization: TextCapitalization.characters,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: TextStyle(color: AppTheme.textGrey),
            hintText: _hasCatalog ? 'Search by symbol or name...' : 'Enter symbol',
            hintStyle: TextStyle(
              color: AppTheme.textGrey.withValues(alpha: 0.5),
              fontSize: 13,
            ),
            prefixIcon: Icon(
              _hasCatalog ? Icons.search : Icons.tag,
              color: AppTheme.textGrey,
              size: 20,
            ),
            filled: true,
            fillColor: AppTheme.midnightBlue,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.electricBlue),
            ),
          ),
        ),
      ),
    );
  }
}
