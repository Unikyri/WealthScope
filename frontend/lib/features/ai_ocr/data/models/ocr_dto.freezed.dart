// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ocr_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExtractedAssetDto {
  String get name;
  String? get symbol;
  String get type;
  double get quantity;
  @JsonKey(name: 'purchase_price')
  double get purchasePrice;
  String get currency;
  @JsonKey(name: 'total_value')
  double? get totalValue;
  double get confidence;

  /// Create a copy of ExtractedAssetDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExtractedAssetDtoCopyWith<ExtractedAssetDto> get copyWith =>
      _$ExtractedAssetDtoCopyWithImpl<ExtractedAssetDto>(
          this as ExtractedAssetDto, _$identity);

  /// Serializes this ExtractedAssetDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExtractedAssetDto &&
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

  @override
  String toString() {
    return 'ExtractedAssetDto(name: $name, symbol: $symbol, type: $type, quantity: $quantity, purchasePrice: $purchasePrice, currency: $currency, totalValue: $totalValue, confidence: $confidence)';
  }
}

/// @nodoc
abstract mixin class $ExtractedAssetDtoCopyWith<$Res> {
  factory $ExtractedAssetDtoCopyWith(
          ExtractedAssetDto value, $Res Function(ExtractedAssetDto) _then) =
      _$ExtractedAssetDtoCopyWithImpl;
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
class _$ExtractedAssetDtoCopyWithImpl<$Res>
    implements $ExtractedAssetDtoCopyWith<$Res> {
  _$ExtractedAssetDtoCopyWithImpl(this._self, this._then);

  final ExtractedAssetDto _self;
  final $Res Function(ExtractedAssetDto) _then;

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
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: freezed == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      purchasePrice: null == purchasePrice
          ? _self.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      totalValue: freezed == totalValue
          ? _self.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double?,
      confidence: null == confidence
          ? _self.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [ExtractedAssetDto].
extension ExtractedAssetDtoPatterns on ExtractedAssetDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ExtractedAssetDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExtractedAssetDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ExtractedAssetDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExtractedAssetDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ExtractedAssetDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExtractedAssetDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String name,
            String? symbol,
            String type,
            double quantity,
            @JsonKey(name: 'purchase_price') double purchasePrice,
            String currency,
            @JsonKey(name: 'total_value') double? totalValue,
            double confidence)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExtractedAssetDto() when $default != null:
        return $default(
            _that.name,
            _that.symbol,
            _that.type,
            _that.quantity,
            _that.purchasePrice,
            _that.currency,
            _that.totalValue,
            _that.confidence);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String name,
            String? symbol,
            String type,
            double quantity,
            @JsonKey(name: 'purchase_price') double purchasePrice,
            String currency,
            @JsonKey(name: 'total_value') double? totalValue,
            double confidence)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExtractedAssetDto():
        return $default(
            _that.name,
            _that.symbol,
            _that.type,
            _that.quantity,
            _that.purchasePrice,
            _that.currency,
            _that.totalValue,
            _that.confidence);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String name,
            String? symbol,
            String type,
            double quantity,
            @JsonKey(name: 'purchase_price') double purchasePrice,
            String currency,
            @JsonKey(name: 'total_value') double? totalValue,
            double confidence)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExtractedAssetDto() when $default != null:
        return $default(
            _that.name,
            _that.symbol,
            _that.type,
            _that.quantity,
            _that.purchasePrice,
            _that.currency,
            _that.totalValue,
            _that.confidence);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ExtractedAssetDto implements ExtractedAssetDto {
  const _ExtractedAssetDto(
      {required this.name,
      this.symbol,
      required this.type,
      required this.quantity,
      @JsonKey(name: 'purchase_price') required this.purchasePrice,
      required this.currency,
      @JsonKey(name: 'total_value') this.totalValue,
      required this.confidence});
  factory _ExtractedAssetDto.fromJson(Map<String, dynamic> json) =>
      _$ExtractedAssetDtoFromJson(json);

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

  /// Create a copy of ExtractedAssetDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExtractedAssetDtoCopyWith<_ExtractedAssetDto> get copyWith =>
      __$ExtractedAssetDtoCopyWithImpl<_ExtractedAssetDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ExtractedAssetDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExtractedAssetDto &&
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

  @override
  String toString() {
    return 'ExtractedAssetDto(name: $name, symbol: $symbol, type: $type, quantity: $quantity, purchasePrice: $purchasePrice, currency: $currency, totalValue: $totalValue, confidence: $confidence)';
  }
}

/// @nodoc
abstract mixin class _$ExtractedAssetDtoCopyWith<$Res>
    implements $ExtractedAssetDtoCopyWith<$Res> {
  factory _$ExtractedAssetDtoCopyWith(
          _ExtractedAssetDto value, $Res Function(_ExtractedAssetDto) _then) =
      __$ExtractedAssetDtoCopyWithImpl;
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
class __$ExtractedAssetDtoCopyWithImpl<$Res>
    implements _$ExtractedAssetDtoCopyWith<$Res> {
  __$ExtractedAssetDtoCopyWithImpl(this._self, this._then);

  final _ExtractedAssetDto _self;
  final $Res Function(_ExtractedAssetDto) _then;

  /// Create a copy of ExtractedAssetDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_ExtractedAssetDto(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: freezed == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      purchasePrice: null == purchasePrice
          ? _self.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      totalValue: freezed == totalValue
          ? _self.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double?,
      confidence: null == confidence
          ? _self.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
mixin _$OCRResultDto {
  @JsonKey(name: 'document_type')
  String get documentType;
  List<ExtractedAssetDto> get assets;
  List<String> get warnings;

  /// Create a copy of OCRResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OCRResultDtoCopyWith<OCRResultDto> get copyWith =>
      _$OCRResultDtoCopyWithImpl<OCRResultDto>(
          this as OCRResultDto, _$identity);

  /// Serializes this OCRResultDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OCRResultDto &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            const DeepCollectionEquality().equals(other.assets, assets) &&
            const DeepCollectionEquality().equals(other.warnings, warnings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      documentType,
      const DeepCollectionEquality().hash(assets),
      const DeepCollectionEquality().hash(warnings));

  @override
  String toString() {
    return 'OCRResultDto(documentType: $documentType, assets: $assets, warnings: $warnings)';
  }
}

/// @nodoc
abstract mixin class $OCRResultDtoCopyWith<$Res> {
  factory $OCRResultDtoCopyWith(
          OCRResultDto value, $Res Function(OCRResultDto) _then) =
      _$OCRResultDtoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'document_type') String documentType,
      List<ExtractedAssetDto> assets,
      List<String> warnings});
}

/// @nodoc
class _$OCRResultDtoCopyWithImpl<$Res> implements $OCRResultDtoCopyWith<$Res> {
  _$OCRResultDtoCopyWithImpl(this._self, this._then);

  final OCRResultDto _self;
  final $Res Function(OCRResultDto) _then;

  /// Create a copy of OCRResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentType = null,
    Object? assets = null,
    Object? warnings = null,
  }) {
    return _then(_self.copyWith(
      documentType: null == documentType
          ? _self.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      assets: null == assets
          ? _self.assets
          : assets // ignore: cast_nullable_to_non_nullable
              as List<ExtractedAssetDto>,
      warnings: null == warnings
          ? _self.warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [OCRResultDto].
extension OCRResultDtoPatterns on OCRResultDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OCRResultDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OCRResultDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OCRResultDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OCRResultDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OCRResultDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OCRResultDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(@JsonKey(name: 'document_type') String documentType,
            List<ExtractedAssetDto> assets, List<String> warnings)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OCRResultDto() when $default != null:
        return $default(_that.documentType, _that.assets, _that.warnings);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(@JsonKey(name: 'document_type') String documentType,
            List<ExtractedAssetDto> assets, List<String> warnings)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OCRResultDto():
        return $default(_that.documentType, _that.assets, _that.warnings);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(@JsonKey(name: 'document_type') String documentType,
            List<ExtractedAssetDto> assets, List<String> warnings)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OCRResultDto() when $default != null:
        return $default(_that.documentType, _that.assets, _that.warnings);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OCRResultDto implements OCRResultDto {
  const _OCRResultDto(
      {@JsonKey(name: 'document_type') required this.documentType,
      required final List<ExtractedAssetDto> assets,
      required final List<String> warnings})
      : _assets = assets,
        _warnings = warnings;
  factory _OCRResultDto.fromJson(Map<String, dynamic> json) =>
      _$OCRResultDtoFromJson(json);

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

  /// Create a copy of OCRResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OCRResultDtoCopyWith<_OCRResultDto> get copyWith =>
      __$OCRResultDtoCopyWithImpl<_OCRResultDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OCRResultDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OCRResultDto &&
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

  @override
  String toString() {
    return 'OCRResultDto(documentType: $documentType, assets: $assets, warnings: $warnings)';
  }
}

/// @nodoc
abstract mixin class _$OCRResultDtoCopyWith<$Res>
    implements $OCRResultDtoCopyWith<$Res> {
  factory _$OCRResultDtoCopyWith(
          _OCRResultDto value, $Res Function(_OCRResultDto) _then) =
      __$OCRResultDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'document_type') String documentType,
      List<ExtractedAssetDto> assets,
      List<String> warnings});
}

/// @nodoc
class __$OCRResultDtoCopyWithImpl<$Res>
    implements _$OCRResultDtoCopyWith<$Res> {
  __$OCRResultDtoCopyWithImpl(this._self, this._then);

  final _OCRResultDto _self;
  final $Res Function(_OCRResultDto) _then;

  /// Create a copy of OCRResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? documentType = null,
    Object? assets = null,
    Object? warnings = null,
  }) {
    return _then(_OCRResultDto(
      documentType: null == documentType
          ? _self.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      assets: null == assets
          ? _self._assets
          : assets // ignore: cast_nullable_to_non_nullable
              as List<ExtractedAssetDto>,
      warnings: null == warnings
          ? _self._warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
mixin _$OCRConfirmationDto {
  @JsonKey(name: 'asset_ids')
  List<String> get assetIds;
  @JsonKey(name: 'created_count')
  int get createdCount;

  /// Create a copy of OCRConfirmationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OCRConfirmationDtoCopyWith<OCRConfirmationDto> get copyWith =>
      _$OCRConfirmationDtoCopyWithImpl<OCRConfirmationDto>(
          this as OCRConfirmationDto, _$identity);

  /// Serializes this OCRConfirmationDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OCRConfirmationDto &&
            const DeepCollectionEquality().equals(other.assetIds, assetIds) &&
            (identical(other.createdCount, createdCount) ||
                other.createdCount == createdCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(assetIds), createdCount);

  @override
  String toString() {
    return 'OCRConfirmationDto(assetIds: $assetIds, createdCount: $createdCount)';
  }
}

/// @nodoc
abstract mixin class $OCRConfirmationDtoCopyWith<$Res> {
  factory $OCRConfirmationDtoCopyWith(
          OCRConfirmationDto value, $Res Function(OCRConfirmationDto) _then) =
      _$OCRConfirmationDtoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'asset_ids') List<String> assetIds,
      @JsonKey(name: 'created_count') int createdCount});
}

/// @nodoc
class _$OCRConfirmationDtoCopyWithImpl<$Res>
    implements $OCRConfirmationDtoCopyWith<$Res> {
  _$OCRConfirmationDtoCopyWithImpl(this._self, this._then);

  final OCRConfirmationDto _self;
  final $Res Function(OCRConfirmationDto) _then;

  /// Create a copy of OCRConfirmationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assetIds = null,
    Object? createdCount = null,
  }) {
    return _then(_self.copyWith(
      assetIds: null == assetIds
          ? _self.assetIds
          : assetIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdCount: null == createdCount
          ? _self.createdCount
          : createdCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [OCRConfirmationDto].
extension OCRConfirmationDtoPatterns on OCRConfirmationDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OCRConfirmationDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OCRConfirmationDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OCRConfirmationDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OCRConfirmationDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OCRConfirmationDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OCRConfirmationDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(@JsonKey(name: 'asset_ids') List<String> assetIds,
            @JsonKey(name: 'created_count') int createdCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OCRConfirmationDto() when $default != null:
        return $default(_that.assetIds, _that.createdCount);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(@JsonKey(name: 'asset_ids') List<String> assetIds,
            @JsonKey(name: 'created_count') int createdCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OCRConfirmationDto():
        return $default(_that.assetIds, _that.createdCount);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(@JsonKey(name: 'asset_ids') List<String> assetIds,
            @JsonKey(name: 'created_count') int createdCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OCRConfirmationDto() when $default != null:
        return $default(_that.assetIds, _that.createdCount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OCRConfirmationDto implements OCRConfirmationDto {
  const _OCRConfirmationDto(
      {@JsonKey(name: 'asset_ids') required final List<String> assetIds,
      @JsonKey(name: 'created_count') required this.createdCount})
      : _assetIds = assetIds;
  factory _OCRConfirmationDto.fromJson(Map<String, dynamic> json) =>
      _$OCRConfirmationDtoFromJson(json);

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

  /// Create a copy of OCRConfirmationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OCRConfirmationDtoCopyWith<_OCRConfirmationDto> get copyWith =>
      __$OCRConfirmationDtoCopyWithImpl<_OCRConfirmationDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OCRConfirmationDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OCRConfirmationDto &&
            const DeepCollectionEquality().equals(other._assetIds, _assetIds) &&
            (identical(other.createdCount, createdCount) ||
                other.createdCount == createdCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_assetIds), createdCount);

  @override
  String toString() {
    return 'OCRConfirmationDto(assetIds: $assetIds, createdCount: $createdCount)';
  }
}

/// @nodoc
abstract mixin class _$OCRConfirmationDtoCopyWith<$Res>
    implements $OCRConfirmationDtoCopyWith<$Res> {
  factory _$OCRConfirmationDtoCopyWith(
          _OCRConfirmationDto value, $Res Function(_OCRConfirmationDto) _then) =
      __$OCRConfirmationDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'asset_ids') List<String> assetIds,
      @JsonKey(name: 'created_count') int createdCount});
}

/// @nodoc
class __$OCRConfirmationDtoCopyWithImpl<$Res>
    implements _$OCRConfirmationDtoCopyWith<$Res> {
  __$OCRConfirmationDtoCopyWithImpl(this._self, this._then);

  final _OCRConfirmationDto _self;
  final $Res Function(_OCRConfirmationDto) _then;

  /// Create a copy of OCRConfirmationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? assetIds = null,
    Object? createdCount = null,
  }) {
    return _then(_OCRConfirmationDto(
      assetIds: null == assetIds
          ? _self._assetIds
          : assetIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdCount: null == createdCount
          ? _self.createdCount
          : createdCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$ConfirmAssetsRequestDto {
  List<ConfirmAssetDto> get assets;

  /// Create a copy of ConfirmAssetsRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConfirmAssetsRequestDtoCopyWith<ConfirmAssetsRequestDto> get copyWith =>
      _$ConfirmAssetsRequestDtoCopyWithImpl<ConfirmAssetsRequestDto>(
          this as ConfirmAssetsRequestDto, _$identity);

  /// Serializes this ConfirmAssetsRequestDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConfirmAssetsRequestDto &&
            const DeepCollectionEquality().equals(other.assets, assets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(assets));

  @override
  String toString() {
    return 'ConfirmAssetsRequestDto(assets: $assets)';
  }
}

/// @nodoc
abstract mixin class $ConfirmAssetsRequestDtoCopyWith<$Res> {
  factory $ConfirmAssetsRequestDtoCopyWith(ConfirmAssetsRequestDto value,
          $Res Function(ConfirmAssetsRequestDto) _then) =
      _$ConfirmAssetsRequestDtoCopyWithImpl;
  @useResult
  $Res call({List<ConfirmAssetDto> assets});
}

/// @nodoc
class _$ConfirmAssetsRequestDtoCopyWithImpl<$Res>
    implements $ConfirmAssetsRequestDtoCopyWith<$Res> {
  _$ConfirmAssetsRequestDtoCopyWithImpl(this._self, this._then);

  final ConfirmAssetsRequestDto _self;
  final $Res Function(ConfirmAssetsRequestDto) _then;

  /// Create a copy of ConfirmAssetsRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assets = null,
  }) {
    return _then(_self.copyWith(
      assets: null == assets
          ? _self.assets
          : assets // ignore: cast_nullable_to_non_nullable
              as List<ConfirmAssetDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [ConfirmAssetsRequestDto].
extension ConfirmAssetsRequestDtoPatterns on ConfirmAssetsRequestDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ConfirmAssetsRequestDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConfirmAssetsRequestDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ConfirmAssetsRequestDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfirmAssetsRequestDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ConfirmAssetsRequestDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfirmAssetsRequestDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(List<ConfirmAssetDto> assets)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConfirmAssetsRequestDto() when $default != null:
        return $default(_that.assets);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(List<ConfirmAssetDto> assets) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfirmAssetsRequestDto():
        return $default(_that.assets);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(List<ConfirmAssetDto> assets)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfirmAssetsRequestDto() when $default != null:
        return $default(_that.assets);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ConfirmAssetsRequestDto implements ConfirmAssetsRequestDto {
  const _ConfirmAssetsRequestDto({required final List<ConfirmAssetDto> assets})
      : _assets = assets;
  factory _ConfirmAssetsRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ConfirmAssetsRequestDtoFromJson(json);

  final List<ConfirmAssetDto> _assets;
  @override
  List<ConfirmAssetDto> get assets {
    if (_assets is EqualUnmodifiableListView) return _assets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assets);
  }

  /// Create a copy of ConfirmAssetsRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConfirmAssetsRequestDtoCopyWith<_ConfirmAssetsRequestDto> get copyWith =>
      __$ConfirmAssetsRequestDtoCopyWithImpl<_ConfirmAssetsRequestDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ConfirmAssetsRequestDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConfirmAssetsRequestDto &&
            const DeepCollectionEquality().equals(other._assets, _assets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_assets));

  @override
  String toString() {
    return 'ConfirmAssetsRequestDto(assets: $assets)';
  }
}

/// @nodoc
abstract mixin class _$ConfirmAssetsRequestDtoCopyWith<$Res>
    implements $ConfirmAssetsRequestDtoCopyWith<$Res> {
  factory _$ConfirmAssetsRequestDtoCopyWith(_ConfirmAssetsRequestDto value,
          $Res Function(_ConfirmAssetsRequestDto) _then) =
      __$ConfirmAssetsRequestDtoCopyWithImpl;
  @override
  @useResult
  $Res call({List<ConfirmAssetDto> assets});
}

/// @nodoc
class __$ConfirmAssetsRequestDtoCopyWithImpl<$Res>
    implements _$ConfirmAssetsRequestDtoCopyWith<$Res> {
  __$ConfirmAssetsRequestDtoCopyWithImpl(this._self, this._then);

  final _ConfirmAssetsRequestDto _self;
  final $Res Function(_ConfirmAssetsRequestDto) _then;

  /// Create a copy of ConfirmAssetsRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? assets = null,
  }) {
    return _then(_ConfirmAssetsRequestDto(
      assets: null == assets
          ? _self._assets
          : assets // ignore: cast_nullable_to_non_nullable
              as List<ConfirmAssetDto>,
    ));
  }
}

/// @nodoc
mixin _$ConfirmAssetDto {
  String get name;
  String? get symbol;
  String get type;
  double get quantity;
  @JsonKey(name: 'purchase_price')
  double get purchasePrice;
  String get currency;

  /// Create a copy of ConfirmAssetDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConfirmAssetDtoCopyWith<ConfirmAssetDto> get copyWith =>
      _$ConfirmAssetDtoCopyWithImpl<ConfirmAssetDto>(
          this as ConfirmAssetDto, _$identity);

  /// Serializes this ConfirmAssetDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConfirmAssetDto &&
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

  @override
  String toString() {
    return 'ConfirmAssetDto(name: $name, symbol: $symbol, type: $type, quantity: $quantity, purchasePrice: $purchasePrice, currency: $currency)';
  }
}

/// @nodoc
abstract mixin class $ConfirmAssetDtoCopyWith<$Res> {
  factory $ConfirmAssetDtoCopyWith(
          ConfirmAssetDto value, $Res Function(ConfirmAssetDto) _then) =
      _$ConfirmAssetDtoCopyWithImpl;
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
class _$ConfirmAssetDtoCopyWithImpl<$Res>
    implements $ConfirmAssetDtoCopyWith<$Res> {
  _$ConfirmAssetDtoCopyWithImpl(this._self, this._then);

  final ConfirmAssetDto _self;
  final $Res Function(ConfirmAssetDto) _then;

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
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: freezed == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      purchasePrice: null == purchasePrice
          ? _self.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [ConfirmAssetDto].
extension ConfirmAssetDtoPatterns on ConfirmAssetDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ConfirmAssetDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConfirmAssetDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ConfirmAssetDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfirmAssetDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ConfirmAssetDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfirmAssetDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String name,
            String? symbol,
            String type,
            double quantity,
            @JsonKey(name: 'purchase_price') double purchasePrice,
            String currency)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConfirmAssetDto() when $default != null:
        return $default(_that.name, _that.symbol, _that.type, _that.quantity,
            _that.purchasePrice, _that.currency);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String name,
            String? symbol,
            String type,
            double quantity,
            @JsonKey(name: 'purchase_price') double purchasePrice,
            String currency)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfirmAssetDto():
        return $default(_that.name, _that.symbol, _that.type, _that.quantity,
            _that.purchasePrice, _that.currency);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String name,
            String? symbol,
            String type,
            double quantity,
            @JsonKey(name: 'purchase_price') double purchasePrice,
            String currency)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfirmAssetDto() when $default != null:
        return $default(_that.name, _that.symbol, _that.type, _that.quantity,
            _that.purchasePrice, _that.currency);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ConfirmAssetDto implements ConfirmAssetDto {
  const _ConfirmAssetDto(
      {required this.name,
      this.symbol,
      required this.type,
      required this.quantity,
      @JsonKey(name: 'purchase_price') required this.purchasePrice,
      required this.currency});
  factory _ConfirmAssetDto.fromJson(Map<String, dynamic> json) =>
      _$ConfirmAssetDtoFromJson(json);

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

  /// Create a copy of ConfirmAssetDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConfirmAssetDtoCopyWith<_ConfirmAssetDto> get copyWith =>
      __$ConfirmAssetDtoCopyWithImpl<_ConfirmAssetDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ConfirmAssetDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConfirmAssetDto &&
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

  @override
  String toString() {
    return 'ConfirmAssetDto(name: $name, symbol: $symbol, type: $type, quantity: $quantity, purchasePrice: $purchasePrice, currency: $currency)';
  }
}

/// @nodoc
abstract mixin class _$ConfirmAssetDtoCopyWith<$Res>
    implements $ConfirmAssetDtoCopyWith<$Res> {
  factory _$ConfirmAssetDtoCopyWith(
          _ConfirmAssetDto value, $Res Function(_ConfirmAssetDto) _then) =
      __$ConfirmAssetDtoCopyWithImpl;
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
class __$ConfirmAssetDtoCopyWithImpl<$Res>
    implements _$ConfirmAssetDtoCopyWith<$Res> {
  __$ConfirmAssetDtoCopyWithImpl(this._self, this._then);

  final _ConfirmAssetDto _self;
  final $Res Function(_ConfirmAssetDto) _then;

  /// Create a copy of ConfirmAssetDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? symbol = freezed,
    Object? type = null,
    Object? quantity = null,
    Object? purchasePrice = null,
    Object? currency = null,
  }) {
    return _then(_ConfirmAssetDto(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: freezed == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      purchasePrice: null == purchasePrice
          ? _self.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
