// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ocr_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExtractedAssetDto _$ExtractedAssetDtoFromJson(Map<String, dynamic> json) {
  return _ExtractedAssetDto.fromJson(json);
}

/// @nodoc
mixin _$ExtractedAssetDto {
  String get name => throw _privateConstructorUsedError;
  String? get symbol => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_price')
  double get purchasePrice => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_value')
  double? get totalValue => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;

  /// Serializes this ExtractedAssetDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExtractedAssetDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExtractedAssetDtoCopyWith<ExtractedAssetDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExtractedAssetDtoCopyWith<$Res> {
  factory $ExtractedAssetDtoCopyWith(
          ExtractedAssetDto value, $Res Function(ExtractedAssetDto) then) =
      _$ExtractedAssetDtoCopyWithImpl<$Res, ExtractedAssetDto>;
  @useResult
  $Res call(
      {String name,
      String? symbol,
      String type,
      double quantity,
      @JsonKey(name: 'purchase_price') double purchasePrice,
      String currency,
      @JsonKey(name: 'total_value') double? totalValue,
      double confidence});
}

/// @nodoc
class _$ExtractedAssetDtoCopyWithImpl<$Res, $Val extends ExtractedAssetDto>
    implements $ExtractedAssetDtoCopyWith<$Res> {
  _$ExtractedAssetDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExtractedAssetDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? symbol = freezed,
    Object? type = null,
    Object? quantity = null,
    Object? purchasePrice = null,
    Object? currency = null,
    Object? totalValue = freezed,
    Object? confidence = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: freezed == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      purchasePrice: null == purchasePrice
          ? _value.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      totalValue: freezed == totalValue
          ? _value.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double?,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExtractedAssetDtoImplCopyWith<$Res>
    implements $ExtractedAssetDtoCopyWith<$Res> {
  factory _$$ExtractedAssetDtoImplCopyWith(_$ExtractedAssetDtoImpl value,
          $Res Function(_$ExtractedAssetDtoImpl) then) =
      __$$ExtractedAssetDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String? symbol,
      String type,
      double quantity,
      @JsonKey(name: 'purchase_price') double purchasePrice,
      String currency,
      @JsonKey(name: 'total_value') double? totalValue,
      double confidence});
}

/// @nodoc
class __$$ExtractedAssetDtoImplCopyWithImpl<$Res>
    extends _$ExtractedAssetDtoCopyWithImpl<$Res, _$ExtractedAssetDtoImpl>
    implements _$$ExtractedAssetDtoImplCopyWith<$Res> {
  __$$ExtractedAssetDtoImplCopyWithImpl(_$ExtractedAssetDtoImpl _value,
      $Res Function(_$ExtractedAssetDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExtractedAssetDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? symbol = freezed,
    Object? type = null,
    Object? quantity = null,
    Object? purchasePrice = null,
    Object? currency = null,
    Object? totalValue = freezed,
    Object? confidence = null,
  }) {
    return _then(_$ExtractedAssetDtoImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: freezed == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      purchasePrice: null == purchasePrice
          ? _value.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      totalValue: freezed == totalValue
          ? _value.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double?,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExtractedAssetDtoImpl implements _ExtractedAssetDto {
  const _$ExtractedAssetDtoImpl(
      {required this.name,
      this.symbol,
      required this.type,
      required this.quantity,
      @JsonKey(name: 'purchase_price') required this.purchasePrice,
      required this.currency,
      @JsonKey(name: 'total_value') this.totalValue,
      required this.confidence});

  factory _$ExtractedAssetDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExtractedAssetDtoImplFromJson(json);

  @override
  final String name;
  @override
  final String? symbol;
  @override
  final String type;
  @override
  final double quantity;
  @override
  @JsonKey(name: 'purchase_price')
  final double purchasePrice;
  @override
  final String currency;
  @override
  @JsonKey(name: 'total_value')
  final double? totalValue;
  @override
  final double confidence;

  @override
  String toString() {
    return 'ExtractedAssetDto(name: $name, symbol: $symbol, type: $type, quantity: $quantity, purchasePrice: $purchasePrice, currency: $currency, totalValue: $totalValue, confidence: $confidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExtractedAssetDtoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.purchasePrice, purchasePrice) ||
                other.purchasePrice == purchasePrice) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.totalValue, totalValue) ||
                other.totalValue == totalValue) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, symbol, type, quantity,
      purchasePrice, currency, totalValue, confidence);

  /// Create a copy of ExtractedAssetDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExtractedAssetDtoImplCopyWith<_$ExtractedAssetDtoImpl> get copyWith =>
      __$$ExtractedAssetDtoImplCopyWithImpl<_$ExtractedAssetDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExtractedAssetDtoImplToJson(
      this,
    );
  }
}

abstract class _ExtractedAssetDto implements ExtractedAssetDto {
  const factory _ExtractedAssetDto(
      {required final String name,
      final String? symbol,
      required final String type,
      required final double quantity,
      @JsonKey(name: 'purchase_price') required final double purchasePrice,
      required final String currency,
      @JsonKey(name: 'total_value') final double? totalValue,
      required final double confidence}) = _$ExtractedAssetDtoImpl;

  factory _ExtractedAssetDto.fromJson(Map<String, dynamic> json) =
      _$ExtractedAssetDtoImpl.fromJson;

  @override
  String get name;
  @override
  String? get symbol;
  @override
  String get type;
  @override
  double get quantity;
  @override
  @JsonKey(name: 'purchase_price')
  double get purchasePrice;
  @override
  String get currency;
  @override
  @JsonKey(name: 'total_value')
  double? get totalValue;
  @override
  double get confidence;

  /// Create a copy of ExtractedAssetDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExtractedAssetDtoImplCopyWith<_$ExtractedAssetDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OCRResultDto _$OCRResultDtoFromJson(Map<String, dynamic> json) {
  return _OCRResultDto.fromJson(json);
}

/// @nodoc
mixin _$OCRResultDto {
  @JsonKey(name: 'document_type')
  String get documentType => throw _privateConstructorUsedError;
  List<ExtractedAssetDto> get assets => throw _privateConstructorUsedError;
  List<String> get warnings => throw _privateConstructorUsedError;

  /// Serializes this OCRResultDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OCRResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OCRResultDtoCopyWith<OCRResultDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OCRResultDtoCopyWith<$Res> {
  factory $OCRResultDtoCopyWith(
          OCRResultDto value, $Res Function(OCRResultDto) then) =
      _$OCRResultDtoCopyWithImpl<$Res, OCRResultDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'document_type') String documentType,
      List<ExtractedAssetDto> assets,
      List<String> warnings});
}

/// @nodoc
class _$OCRResultDtoCopyWithImpl<$Res, $Val extends OCRResultDto>
    implements $OCRResultDtoCopyWith<$Res> {
  _$OCRResultDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OCRResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentType = null,
    Object? assets = null,
    Object? warnings = null,
  }) {
    return _then(_value.copyWith(
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      assets: null == assets
          ? _value.assets
          : assets // ignore: cast_nullable_to_non_nullable
              as List<ExtractedAssetDto>,
      warnings: null == warnings
          ? _value.warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OCRResultDtoImplCopyWith<$Res>
    implements $OCRResultDtoCopyWith<$Res> {
  factory _$$OCRResultDtoImplCopyWith(
          _$OCRResultDtoImpl value, $Res Function(_$OCRResultDtoImpl) then) =
      __$$OCRResultDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'document_type') String documentType,
      List<ExtractedAssetDto> assets,
      List<String> warnings});
}

/// @nodoc
class __$$OCRResultDtoImplCopyWithImpl<$Res>
    extends _$OCRResultDtoCopyWithImpl<$Res, _$OCRResultDtoImpl>
    implements _$$OCRResultDtoImplCopyWith<$Res> {
  __$$OCRResultDtoImplCopyWithImpl(
      _$OCRResultDtoImpl _value, $Res Function(_$OCRResultDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of OCRResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentType = null,
    Object? assets = null,
    Object? warnings = null,
  }) {
    return _then(_$OCRResultDtoImpl(
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      assets: null == assets
          ? _value._assets
          : assets // ignore: cast_nullable_to_non_nullable
              as List<ExtractedAssetDto>,
      warnings: null == warnings
          ? _value._warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OCRResultDtoImpl implements _OCRResultDto {
  const _$OCRResultDtoImpl(
      {@JsonKey(name: 'document_type') required this.documentType,
      required final List<ExtractedAssetDto> assets,
      required final List<String> warnings})
      : _assets = assets,
        _warnings = warnings;

  factory _$OCRResultDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OCRResultDtoImplFromJson(json);

  @override
  @JsonKey(name: 'document_type')
  final String documentType;
  final List<ExtractedAssetDto> _assets;
  @override
  List<ExtractedAssetDto> get assets {
    if (_assets is EqualUnmodifiableListView) return _assets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assets);
  }

  final List<String> _warnings;
  @override
  List<String> get warnings {
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warnings);
  }

  @override
  String toString() {
    return 'OCRResultDto(documentType: $documentType, assets: $assets, warnings: $warnings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OCRResultDtoImpl &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            const DeepCollectionEquality().equals(other._assets, _assets) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      documentType,
      const DeepCollectionEquality().hash(_assets),
      const DeepCollectionEquality().hash(_warnings));

  /// Create a copy of OCRResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OCRResultDtoImplCopyWith<_$OCRResultDtoImpl> get copyWith =>
      __$$OCRResultDtoImplCopyWithImpl<_$OCRResultDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OCRResultDtoImplToJson(
      this,
    );
  }
}

abstract class _OCRResultDto implements OCRResultDto {
  const factory _OCRResultDto(
      {@JsonKey(name: 'document_type') required final String documentType,
      required final List<ExtractedAssetDto> assets,
      required final List<String> warnings}) = _$OCRResultDtoImpl;

  factory _OCRResultDto.fromJson(Map<String, dynamic> json) =
      _$OCRResultDtoImpl.fromJson;

  @override
  @JsonKey(name: 'document_type')
  String get documentType;
  @override
  List<ExtractedAssetDto> get assets;
  @override
  List<String> get warnings;

  /// Create a copy of OCRResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OCRResultDtoImplCopyWith<_$OCRResultDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OCRConfirmationDto _$OCRConfirmationDtoFromJson(Map<String, dynamic> json) {
  return _OCRConfirmationDto.fromJson(json);
}

/// @nodoc
mixin _$OCRConfirmationDto {
  @JsonKey(name: 'asset_ids')
  List<String> get assetIds => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_count')
  int get createdCount => throw _privateConstructorUsedError;

  /// Serializes this OCRConfirmationDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OCRConfirmationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OCRConfirmationDtoCopyWith<OCRConfirmationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OCRConfirmationDtoCopyWith<$Res> {
  factory $OCRConfirmationDtoCopyWith(
          OCRConfirmationDto value, $Res Function(OCRConfirmationDto) then) =
      _$OCRConfirmationDtoCopyWithImpl<$Res, OCRConfirmationDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'asset_ids') List<String> assetIds,
      @JsonKey(name: 'created_count') int createdCount});
}

/// @nodoc
class _$OCRConfirmationDtoCopyWithImpl<$Res, $Val extends OCRConfirmationDto>
    implements $OCRConfirmationDtoCopyWith<$Res> {
  _$OCRConfirmationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OCRConfirmationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assetIds = null,
    Object? createdCount = null,
  }) {
    return _then(_value.copyWith(
      assetIds: null == assetIds
          ? _value.assetIds
          : assetIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdCount: null == createdCount
          ? _value.createdCount
          : createdCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OCRConfirmationDtoImplCopyWith<$Res>
    implements $OCRConfirmationDtoCopyWith<$Res> {
  factory _$$OCRConfirmationDtoImplCopyWith(_$OCRConfirmationDtoImpl value,
          $Res Function(_$OCRConfirmationDtoImpl) then) =
      __$$OCRConfirmationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'asset_ids') List<String> assetIds,
      @JsonKey(name: 'created_count') int createdCount});
}

/// @nodoc
class __$$OCRConfirmationDtoImplCopyWithImpl<$Res>
    extends _$OCRConfirmationDtoCopyWithImpl<$Res, _$OCRConfirmationDtoImpl>
    implements _$$OCRConfirmationDtoImplCopyWith<$Res> {
  __$$OCRConfirmationDtoImplCopyWithImpl(_$OCRConfirmationDtoImpl _value,
      $Res Function(_$OCRConfirmationDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of OCRConfirmationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assetIds = null,
    Object? createdCount = null,
  }) {
    return _then(_$OCRConfirmationDtoImpl(
      assetIds: null == assetIds
          ? _value._assetIds
          : assetIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdCount: null == createdCount
          ? _value.createdCount
          : createdCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OCRConfirmationDtoImpl implements _OCRConfirmationDto {
  const _$OCRConfirmationDtoImpl(
      {@JsonKey(name: 'asset_ids') required final List<String> assetIds,
      @JsonKey(name: 'created_count') required this.createdCount})
      : _assetIds = assetIds;

  factory _$OCRConfirmationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OCRConfirmationDtoImplFromJson(json);

  final List<String> _assetIds;
  @override
  @JsonKey(name: 'asset_ids')
  List<String> get assetIds {
    if (_assetIds is EqualUnmodifiableListView) return _assetIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assetIds);
  }

  @override
  @JsonKey(name: 'created_count')
  final int createdCount;

  @override
  String toString() {
    return 'OCRConfirmationDto(assetIds: $assetIds, createdCount: $createdCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OCRConfirmationDtoImpl &&
            const DeepCollectionEquality().equals(other._assetIds, _assetIds) &&
            (identical(other.createdCount, createdCount) ||
                other.createdCount == createdCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_assetIds), createdCount);

  /// Create a copy of OCRConfirmationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OCRConfirmationDtoImplCopyWith<_$OCRConfirmationDtoImpl> get copyWith =>
      __$$OCRConfirmationDtoImplCopyWithImpl<_$OCRConfirmationDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OCRConfirmationDtoImplToJson(
      this,
    );
  }
}

abstract class _OCRConfirmationDto implements OCRConfirmationDto {
  const factory _OCRConfirmationDto(
          {@JsonKey(name: 'asset_ids') required final List<String> assetIds,
          @JsonKey(name: 'created_count') required final int createdCount}) =
      _$OCRConfirmationDtoImpl;

  factory _OCRConfirmationDto.fromJson(Map<String, dynamic> json) =
      _$OCRConfirmationDtoImpl.fromJson;

  @override
  @JsonKey(name: 'asset_ids')
  List<String> get assetIds;
  @override
  @JsonKey(name: 'created_count')
  int get createdCount;

  /// Create a copy of OCRConfirmationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OCRConfirmationDtoImplCopyWith<_$OCRConfirmationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConfirmAssetsRequestDto _$ConfirmAssetsRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _ConfirmAssetsRequestDto.fromJson(json);
}

/// @nodoc
mixin _$ConfirmAssetsRequestDto {
  List<ConfirmAssetDto> get assets => throw _privateConstructorUsedError;

  /// Serializes this ConfirmAssetsRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConfirmAssetsRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConfirmAssetsRequestDtoCopyWith<ConfirmAssetsRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfirmAssetsRequestDtoCopyWith<$Res> {
  factory $ConfirmAssetsRequestDtoCopyWith(ConfirmAssetsRequestDto value,
          $Res Function(ConfirmAssetsRequestDto) then) =
      _$ConfirmAssetsRequestDtoCopyWithImpl<$Res, ConfirmAssetsRequestDto>;
  @useResult
  $Res call({List<ConfirmAssetDto> assets});
}

/// @nodoc
class _$ConfirmAssetsRequestDtoCopyWithImpl<$Res,
        $Val extends ConfirmAssetsRequestDto>
    implements $ConfirmAssetsRequestDtoCopyWith<$Res> {
  _$ConfirmAssetsRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConfirmAssetsRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assets = null,
  }) {
    return _then(_value.copyWith(
      assets: null == assets
          ? _value.assets
          : assets // ignore: cast_nullable_to_non_nullable
              as List<ConfirmAssetDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConfirmAssetsRequestDtoImplCopyWith<$Res>
    implements $ConfirmAssetsRequestDtoCopyWith<$Res> {
  factory _$$ConfirmAssetsRequestDtoImplCopyWith(
          _$ConfirmAssetsRequestDtoImpl value,
          $Res Function(_$ConfirmAssetsRequestDtoImpl) then) =
      __$$ConfirmAssetsRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ConfirmAssetDto> assets});
}

/// @nodoc
class __$$ConfirmAssetsRequestDtoImplCopyWithImpl<$Res>
    extends _$ConfirmAssetsRequestDtoCopyWithImpl<$Res,
        _$ConfirmAssetsRequestDtoImpl>
    implements _$$ConfirmAssetsRequestDtoImplCopyWith<$Res> {
  __$$ConfirmAssetsRequestDtoImplCopyWithImpl(
      _$ConfirmAssetsRequestDtoImpl _value,
      $Res Function(_$ConfirmAssetsRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConfirmAssetsRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assets = null,
  }) {
    return _then(_$ConfirmAssetsRequestDtoImpl(
      assets: null == assets
          ? _value._assets
          : assets // ignore: cast_nullable_to_non_nullable
              as List<ConfirmAssetDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConfirmAssetsRequestDtoImpl implements _ConfirmAssetsRequestDto {
  const _$ConfirmAssetsRequestDtoImpl(
      {required final List<ConfirmAssetDto> assets})
      : _assets = assets;

  factory _$ConfirmAssetsRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConfirmAssetsRequestDtoImplFromJson(json);

  final List<ConfirmAssetDto> _assets;
  @override
  List<ConfirmAssetDto> get assets {
    if (_assets is EqualUnmodifiableListView) return _assets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assets);
  }

  @override
  String toString() {
    return 'ConfirmAssetsRequestDto(assets: $assets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfirmAssetsRequestDtoImpl &&
            const DeepCollectionEquality().equals(other._assets, _assets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_assets));

  /// Create a copy of ConfirmAssetsRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfirmAssetsRequestDtoImplCopyWith<_$ConfirmAssetsRequestDtoImpl>
      get copyWith => __$$ConfirmAssetsRequestDtoImplCopyWithImpl<
          _$ConfirmAssetsRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConfirmAssetsRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _ConfirmAssetsRequestDto implements ConfirmAssetsRequestDto {
  const factory _ConfirmAssetsRequestDto(
          {required final List<ConfirmAssetDto> assets}) =
      _$ConfirmAssetsRequestDtoImpl;

  factory _ConfirmAssetsRequestDto.fromJson(Map<String, dynamic> json) =
      _$ConfirmAssetsRequestDtoImpl.fromJson;

  @override
  List<ConfirmAssetDto> get assets;

  /// Create a copy of ConfirmAssetsRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfirmAssetsRequestDtoImplCopyWith<_$ConfirmAssetsRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ConfirmAssetDto _$ConfirmAssetDtoFromJson(Map<String, dynamic> json) {
  return _ConfirmAssetDto.fromJson(json);
}

/// @nodoc
mixin _$ConfirmAssetDto {
  String get name => throw _privateConstructorUsedError;
  String? get symbol => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_price')
  double get purchasePrice => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;

  /// Serializes this ConfirmAssetDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConfirmAssetDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConfirmAssetDtoCopyWith<ConfirmAssetDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfirmAssetDtoCopyWith<$Res> {
  factory $ConfirmAssetDtoCopyWith(
          ConfirmAssetDto value, $Res Function(ConfirmAssetDto) then) =
      _$ConfirmAssetDtoCopyWithImpl<$Res, ConfirmAssetDto>;
  @useResult
  $Res call(
      {String name,
      String? symbol,
      String type,
      double quantity,
      @JsonKey(name: 'purchase_price') double purchasePrice,
      String currency});
}

/// @nodoc
class _$ConfirmAssetDtoCopyWithImpl<$Res, $Val extends ConfirmAssetDto>
    implements $ConfirmAssetDtoCopyWith<$Res> {
  _$ConfirmAssetDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConfirmAssetDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? symbol = freezed,
    Object? type = null,
    Object? quantity = null,
    Object? purchasePrice = null,
    Object? currency = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: freezed == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      purchasePrice: null == purchasePrice
          ? _value.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConfirmAssetDtoImplCopyWith<$Res>
    implements $ConfirmAssetDtoCopyWith<$Res> {
  factory _$$ConfirmAssetDtoImplCopyWith(_$ConfirmAssetDtoImpl value,
          $Res Function(_$ConfirmAssetDtoImpl) then) =
      __$$ConfirmAssetDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String? symbol,
      String type,
      double quantity,
      @JsonKey(name: 'purchase_price') double purchasePrice,
      String currency});
}

/// @nodoc
class __$$ConfirmAssetDtoImplCopyWithImpl<$Res>
    extends _$ConfirmAssetDtoCopyWithImpl<$Res, _$ConfirmAssetDtoImpl>
    implements _$$ConfirmAssetDtoImplCopyWith<$Res> {
  __$$ConfirmAssetDtoImplCopyWithImpl(
      _$ConfirmAssetDtoImpl _value, $Res Function(_$ConfirmAssetDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConfirmAssetDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? symbol = freezed,
    Object? type = null,
    Object? quantity = null,
    Object? purchasePrice = null,
    Object? currency = null,
  }) {
    return _then(_$ConfirmAssetDtoImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: freezed == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      purchasePrice: null == purchasePrice
          ? _value.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConfirmAssetDtoImpl implements _ConfirmAssetDto {
  const _$ConfirmAssetDtoImpl(
      {required this.name,
      this.symbol,
      required this.type,
      required this.quantity,
      @JsonKey(name: 'purchase_price') required this.purchasePrice,
      required this.currency});

  factory _$ConfirmAssetDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConfirmAssetDtoImplFromJson(json);

  @override
  final String name;
  @override
  final String? symbol;
  @override
  final String type;
  @override
  final double quantity;
  @override
  @JsonKey(name: 'purchase_price')
  final double purchasePrice;
  @override
  final String currency;

  @override
  String toString() {
    return 'ConfirmAssetDto(name: $name, symbol: $symbol, type: $type, quantity: $quantity, purchasePrice: $purchasePrice, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfirmAssetDtoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.purchasePrice, purchasePrice) ||
                other.purchasePrice == purchasePrice) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, symbol, type, quantity, purchasePrice, currency);

  /// Create a copy of ConfirmAssetDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfirmAssetDtoImplCopyWith<_$ConfirmAssetDtoImpl> get copyWith =>
      __$$ConfirmAssetDtoImplCopyWithImpl<_$ConfirmAssetDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConfirmAssetDtoImplToJson(
      this,
    );
  }
}

abstract class _ConfirmAssetDto implements ConfirmAssetDto {
  const factory _ConfirmAssetDto(
      {required final String name,
      final String? symbol,
      required final String type,
      required final double quantity,
      @JsonKey(name: 'purchase_price') required final double purchasePrice,
      required final String currency}) = _$ConfirmAssetDtoImpl;

  factory _ConfirmAssetDto.fromJson(Map<String, dynamic> json) =
      _$ConfirmAssetDtoImpl.fromJson;

  @override
  String get name;
  @override
  String? get symbol;
  @override
  String get type;
  @override
  double get quantity;
  @override
  @JsonKey(name: 'purchase_price')
  double get purchasePrice;
  @override
  String get currency;

  /// Create a copy of ConfirmAssetDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfirmAssetDtoImplCopyWith<_$ConfirmAssetDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
