// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'portfolio_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PortfolioSummaryDto {
  @JsonKey(name: 'total_value')
  double get totalValue;
  @JsonKey(name: 'total_invested')
  double get totalInvested;
  @JsonKey(name: 'gain_loss')
  double get gainLoss;
  @JsonKey(name: 'gain_loss_percent')
  double get gainLossPercent;
  @JsonKey(name: 'asset_count')
  int get assetCount;
  @JsonKey(name: 'breakdown_by_type')
  List<AssetTypeBreakdownDto> get breakdownByType;
  @JsonKey(name: 'last_updated')
  String get lastUpdated;

  /// Create a copy of PortfolioSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PortfolioSummaryDtoCopyWith<PortfolioSummaryDto> get copyWith =>
      _$PortfolioSummaryDtoCopyWithImpl<PortfolioSummaryDto>(
          this as PortfolioSummaryDto, _$identity);

  /// Serializes this PortfolioSummaryDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PortfolioSummaryDto &&
            (identical(other.totalValue, totalValue) ||
                other.totalValue == totalValue) &&
            (identical(other.totalInvested, totalInvested) ||
                other.totalInvested == totalInvested) &&
            (identical(other.gainLoss, gainLoss) ||
                other.gainLoss == gainLoss) &&
            (identical(other.gainLossPercent, gainLossPercent) ||
                other.gainLossPercent == gainLossPercent) &&
            (identical(other.assetCount, assetCount) ||
                other.assetCount == assetCount) &&
            const DeepCollectionEquality()
                .equals(other.breakdownByType, breakdownByType) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalValue,
      totalInvested,
      gainLoss,
      gainLossPercent,
      assetCount,
      const DeepCollectionEquality().hash(breakdownByType),
      lastUpdated);

  @override
  String toString() {
    return 'PortfolioSummaryDto(totalValue: $totalValue, totalInvested: $totalInvested, gainLoss: $gainLoss, gainLossPercent: $gainLossPercent, assetCount: $assetCount, breakdownByType: $breakdownByType, lastUpdated: $lastUpdated)';
  }
}

/// @nodoc
abstract mixin class $PortfolioSummaryDtoCopyWith<$Res> {
  factory $PortfolioSummaryDtoCopyWith(
          PortfolioSummaryDto value, $Res Function(PortfolioSummaryDto) _then) =
      _$PortfolioSummaryDtoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_value') double totalValue,
      @JsonKey(name: 'total_invested') double totalInvested,
      @JsonKey(name: 'gain_loss') double gainLoss,
      @JsonKey(name: 'gain_loss_percent') double gainLossPercent,
      @JsonKey(name: 'asset_count') int assetCount,
      @JsonKey(name: 'breakdown_by_type')
      List<AssetTypeBreakdownDto> breakdownByType,
      @JsonKey(name: 'last_updated') String lastUpdated});
}

/// @nodoc
class _$PortfolioSummaryDtoCopyWithImpl<$Res>
    implements $PortfolioSummaryDtoCopyWith<$Res> {
  _$PortfolioSummaryDtoCopyWithImpl(this._self, this._then);

  final PortfolioSummaryDto _self;
  final $Res Function(PortfolioSummaryDto) _then;

  /// Create a copy of PortfolioSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalValue = null,
    Object? totalInvested = null,
    Object? gainLoss = null,
    Object? gainLossPercent = null,
    Object? assetCount = null,
    Object? breakdownByType = null,
    Object? lastUpdated = null,
  }) {
    return _then(_self.copyWith(
      totalValue: null == totalValue
          ? _self.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double,
      totalInvested: null == totalInvested
          ? _self.totalInvested
          : totalInvested // ignore: cast_nullable_to_non_nullable
              as double,
      gainLoss: null == gainLoss
          ? _self.gainLoss
          : gainLoss // ignore: cast_nullable_to_non_nullable
              as double,
      gainLossPercent: null == gainLossPercent
          ? _self.gainLossPercent
          : gainLossPercent // ignore: cast_nullable_to_non_nullable
              as double,
      assetCount: null == assetCount
          ? _self.assetCount
          : assetCount // ignore: cast_nullable_to_non_nullable
              as int,
      breakdownByType: null == breakdownByType
          ? _self.breakdownByType
          : breakdownByType // ignore: cast_nullable_to_non_nullable
              as List<AssetTypeBreakdownDto>,
      lastUpdated: null == lastUpdated
          ? _self.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [PortfolioSummaryDto].
extension PortfolioSummaryDtoPatterns on PortfolioSummaryDto {
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
    TResult Function(_PortfolioSummaryDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PortfolioSummaryDto() when $default != null:
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
    TResult Function(_PortfolioSummaryDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioSummaryDto():
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
    TResult? Function(_PortfolioSummaryDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioSummaryDto() when $default != null:
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
            @JsonKey(name: 'total_value') double totalValue,
            @JsonKey(name: 'total_invested') double totalInvested,
            @JsonKey(name: 'gain_loss') double gainLoss,
            @JsonKey(name: 'gain_loss_percent') double gainLossPercent,
            @JsonKey(name: 'asset_count') int assetCount,
            @JsonKey(name: 'breakdown_by_type')
            List<AssetTypeBreakdownDto> breakdownByType,
            @JsonKey(name: 'last_updated') String lastUpdated)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PortfolioSummaryDto() when $default != null:
        return $default(
            _that.totalValue,
            _that.totalInvested,
            _that.gainLoss,
            _that.gainLossPercent,
            _that.assetCount,
            _that.breakdownByType,
            _that.lastUpdated);
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
            @JsonKey(name: 'total_value') double totalValue,
            @JsonKey(name: 'total_invested') double totalInvested,
            @JsonKey(name: 'gain_loss') double gainLoss,
            @JsonKey(name: 'gain_loss_percent') double gainLossPercent,
            @JsonKey(name: 'asset_count') int assetCount,
            @JsonKey(name: 'breakdown_by_type')
            List<AssetTypeBreakdownDto> breakdownByType,
            @JsonKey(name: 'last_updated') String lastUpdated)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioSummaryDto():
        return $default(
            _that.totalValue,
            _that.totalInvested,
            _that.gainLoss,
            _that.gainLossPercent,
            _that.assetCount,
            _that.breakdownByType,
            _that.lastUpdated);
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
            @JsonKey(name: 'total_value') double totalValue,
            @JsonKey(name: 'total_invested') double totalInvested,
            @JsonKey(name: 'gain_loss') double gainLoss,
            @JsonKey(name: 'gain_loss_percent') double gainLossPercent,
            @JsonKey(name: 'asset_count') int assetCount,
            @JsonKey(name: 'breakdown_by_type')
            List<AssetTypeBreakdownDto> breakdownByType,
            @JsonKey(name: 'last_updated') String lastUpdated)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioSummaryDto() when $default != null:
        return $default(
            _that.totalValue,
            _that.totalInvested,
            _that.gainLoss,
            _that.gainLossPercent,
            _that.assetCount,
            _that.breakdownByType,
            _that.lastUpdated);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PortfolioSummaryDto implements PortfolioSummaryDto {
  const _PortfolioSummaryDto(
      {@JsonKey(name: 'total_value') required this.totalValue,
      @JsonKey(name: 'total_invested') required this.totalInvested,
      @JsonKey(name: 'gain_loss') required this.gainLoss,
      @JsonKey(name: 'gain_loss_percent') required this.gainLossPercent,
      @JsonKey(name: 'asset_count') required this.assetCount,
      @JsonKey(name: 'breakdown_by_type')
      required final List<AssetTypeBreakdownDto> breakdownByType,
      @JsonKey(name: 'last_updated') required this.lastUpdated})
      : _breakdownByType = breakdownByType;
  factory _PortfolioSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$PortfolioSummaryDtoFromJson(json);

  @override
  @JsonKey(name: 'total_value')
  final double totalValue;
  @override
  @JsonKey(name: 'total_invested')
  final double totalInvested;
  @override
  @JsonKey(name: 'gain_loss')
  final double gainLoss;
  @override
  @JsonKey(name: 'gain_loss_percent')
  final double gainLossPercent;
  @override
  @JsonKey(name: 'asset_count')
  final int assetCount;
  final List<AssetTypeBreakdownDto> _breakdownByType;
  @override
  @JsonKey(name: 'breakdown_by_type')
  List<AssetTypeBreakdownDto> get breakdownByType {
    if (_breakdownByType is EqualUnmodifiableListView) return _breakdownByType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_breakdownByType);
  }

  @override
  @JsonKey(name: 'last_updated')
  final String lastUpdated;

  /// Create a copy of PortfolioSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PortfolioSummaryDtoCopyWith<_PortfolioSummaryDto> get copyWith =>
      __$PortfolioSummaryDtoCopyWithImpl<_PortfolioSummaryDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PortfolioSummaryDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PortfolioSummaryDto &&
            (identical(other.totalValue, totalValue) ||
                other.totalValue == totalValue) &&
            (identical(other.totalInvested, totalInvested) ||
                other.totalInvested == totalInvested) &&
            (identical(other.gainLoss, gainLoss) ||
                other.gainLoss == gainLoss) &&
            (identical(other.gainLossPercent, gainLossPercent) ||
                other.gainLossPercent == gainLossPercent) &&
            (identical(other.assetCount, assetCount) ||
                other.assetCount == assetCount) &&
            const DeepCollectionEquality()
                .equals(other._breakdownByType, _breakdownByType) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalValue,
      totalInvested,
      gainLoss,
      gainLossPercent,
      assetCount,
      const DeepCollectionEquality().hash(_breakdownByType),
      lastUpdated);

  @override
  String toString() {
    return 'PortfolioSummaryDto(totalValue: $totalValue, totalInvested: $totalInvested, gainLoss: $gainLoss, gainLossPercent: $gainLossPercent, assetCount: $assetCount, breakdownByType: $breakdownByType, lastUpdated: $lastUpdated)';
  }
}

/// @nodoc
abstract mixin class _$PortfolioSummaryDtoCopyWith<$Res>
    implements $PortfolioSummaryDtoCopyWith<$Res> {
  factory _$PortfolioSummaryDtoCopyWith(_PortfolioSummaryDto value,
          $Res Function(_PortfolioSummaryDto) _then) =
      __$PortfolioSummaryDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_value') double totalValue,
      @JsonKey(name: 'total_invested') double totalInvested,
      @JsonKey(name: 'gain_loss') double gainLoss,
      @JsonKey(name: 'gain_loss_percent') double gainLossPercent,
      @JsonKey(name: 'asset_count') int assetCount,
      @JsonKey(name: 'breakdown_by_type')
      List<AssetTypeBreakdownDto> breakdownByType,
      @JsonKey(name: 'last_updated') String lastUpdated});
}

/// @nodoc
class __$PortfolioSummaryDtoCopyWithImpl<$Res>
    implements _$PortfolioSummaryDtoCopyWith<$Res> {
  __$PortfolioSummaryDtoCopyWithImpl(this._self, this._then);

  final _PortfolioSummaryDto _self;
  final $Res Function(_PortfolioSummaryDto) _then;

  /// Create a copy of PortfolioSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? totalValue = null,
    Object? totalInvested = null,
    Object? gainLoss = null,
    Object? gainLossPercent = null,
    Object? assetCount = null,
    Object? breakdownByType = null,
    Object? lastUpdated = null,
  }) {
    return _then(_PortfolioSummaryDto(
      totalValue: null == totalValue
          ? _self.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double,
      totalInvested: null == totalInvested
          ? _self.totalInvested
          : totalInvested // ignore: cast_nullable_to_non_nullable
              as double,
      gainLoss: null == gainLoss
          ? _self.gainLoss
          : gainLoss // ignore: cast_nullable_to_non_nullable
              as double,
      gainLossPercent: null == gainLossPercent
          ? _self.gainLossPercent
          : gainLossPercent // ignore: cast_nullable_to_non_nullable
              as double,
      assetCount: null == assetCount
          ? _self.assetCount
          : assetCount // ignore: cast_nullable_to_non_nullable
              as int,
      breakdownByType: null == breakdownByType
          ? _self._breakdownByType
          : breakdownByType // ignore: cast_nullable_to_non_nullable
              as List<AssetTypeBreakdownDto>,
      lastUpdated: null == lastUpdated
          ? _self.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$AssetTypeBreakdownDto {
  String get type;
  double get value;
  double get percent;
  int get count;

  /// Create a copy of AssetTypeBreakdownDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AssetTypeBreakdownDtoCopyWith<AssetTypeBreakdownDto> get copyWith =>
      _$AssetTypeBreakdownDtoCopyWithImpl<AssetTypeBreakdownDto>(
          this as AssetTypeBreakdownDto, _$identity);

  /// Serializes this AssetTypeBreakdownDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AssetTypeBreakdownDto &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.percent, percent) || other.percent == percent) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, value, percent, count);

  @override
  String toString() {
    return 'AssetTypeBreakdownDto(type: $type, value: $value, percent: $percent, count: $count)';
  }
}

/// @nodoc
abstract mixin class $AssetTypeBreakdownDtoCopyWith<$Res> {
  factory $AssetTypeBreakdownDtoCopyWith(AssetTypeBreakdownDto value,
          $Res Function(AssetTypeBreakdownDto) _then) =
      _$AssetTypeBreakdownDtoCopyWithImpl;
  @useResult
  $Res call({String type, double value, double percent, int count});
}

/// @nodoc
class _$AssetTypeBreakdownDtoCopyWithImpl<$Res>
    implements $AssetTypeBreakdownDtoCopyWith<$Res> {
  _$AssetTypeBreakdownDtoCopyWithImpl(this._self, this._then);

  final AssetTypeBreakdownDto _self;
  final $Res Function(AssetTypeBreakdownDto) _then;

  /// Create a copy of AssetTypeBreakdownDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? value = null,
    Object? percent = null,
    Object? count = null,
  }) {
    return _then(_self.copyWith(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      percent: null == percent
          ? _self.percent
          : percent // ignore: cast_nullable_to_non_nullable
              as double,
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [AssetTypeBreakdownDto].
extension AssetTypeBreakdownDtoPatterns on AssetTypeBreakdownDto {
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
    TResult Function(_AssetTypeBreakdownDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetTypeBreakdownDto() when $default != null:
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
    TResult Function(_AssetTypeBreakdownDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetTypeBreakdownDto():
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
    TResult? Function(_AssetTypeBreakdownDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetTypeBreakdownDto() when $default != null:
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
    TResult Function(String type, double value, double percent, int count)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetTypeBreakdownDto() when $default != null:
        return $default(_that.type, _that.value, _that.percent, _that.count);
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
    TResult Function(String type, double value, double percent, int count)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetTypeBreakdownDto():
        return $default(_that.type, _that.value, _that.percent, _that.count);
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
    TResult? Function(String type, double value, double percent, int count)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetTypeBreakdownDto() when $default != null:
        return $default(_that.type, _that.value, _that.percent, _that.count);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AssetTypeBreakdownDto implements AssetTypeBreakdownDto {
  const _AssetTypeBreakdownDto(
      {required this.type,
      required this.value,
      required this.percent,
      required this.count});
  factory _AssetTypeBreakdownDto.fromJson(Map<String, dynamic> json) =>
      _$AssetTypeBreakdownDtoFromJson(json);

  @override
  final String type;
  @override
  final double value;
  @override
  final double percent;
  @override
  final int count;

  /// Create a copy of AssetTypeBreakdownDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AssetTypeBreakdownDtoCopyWith<_AssetTypeBreakdownDto> get copyWith =>
      __$AssetTypeBreakdownDtoCopyWithImpl<_AssetTypeBreakdownDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AssetTypeBreakdownDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AssetTypeBreakdownDto &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.percent, percent) || other.percent == percent) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, value, percent, count);

  @override
  String toString() {
    return 'AssetTypeBreakdownDto(type: $type, value: $value, percent: $percent, count: $count)';
  }
}

/// @nodoc
abstract mixin class _$AssetTypeBreakdownDtoCopyWith<$Res>
    implements $AssetTypeBreakdownDtoCopyWith<$Res> {
  factory _$AssetTypeBreakdownDtoCopyWith(_AssetTypeBreakdownDto value,
          $Res Function(_AssetTypeBreakdownDto) _then) =
      __$AssetTypeBreakdownDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String type, double value, double percent, int count});
}

/// @nodoc
class __$AssetTypeBreakdownDtoCopyWithImpl<$Res>
    implements _$AssetTypeBreakdownDtoCopyWith<$Res> {
  __$AssetTypeBreakdownDtoCopyWithImpl(this._self, this._then);

  final _AssetTypeBreakdownDto _self;
  final $Res Function(_AssetTypeBreakdownDto) _then;

  /// Create a copy of AssetTypeBreakdownDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? value = null,
    Object? percent = null,
    Object? count = null,
  }) {
    return _then(_AssetTypeBreakdownDto(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      percent: null == percent
          ? _self.percent
          : percent // ignore: cast_nullable_to_non_nullable
              as double,
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$PortfolioRiskAnalysisDto {
  @JsonKey(name: 'risk_score')
  int get riskScore;
  @JsonKey(name: 'diversification_level')
  String get diversificationLevel;
  List<RiskAlertDto> get alerts;

  /// Create a copy of PortfolioRiskAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PortfolioRiskAnalysisDtoCopyWith<PortfolioRiskAnalysisDto> get copyWith =>
      _$PortfolioRiskAnalysisDtoCopyWithImpl<PortfolioRiskAnalysisDto>(
          this as PortfolioRiskAnalysisDto, _$identity);

  /// Serializes this PortfolioRiskAnalysisDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PortfolioRiskAnalysisDto &&
            (identical(other.riskScore, riskScore) ||
                other.riskScore == riskScore) &&
            (identical(other.diversificationLevel, diversificationLevel) ||
                other.diversificationLevel == diversificationLevel) &&
            const DeepCollectionEquality().equals(other.alerts, alerts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, riskScore, diversificationLevel,
      const DeepCollectionEquality().hash(alerts));

  @override
  String toString() {
    return 'PortfolioRiskAnalysisDto(riskScore: $riskScore, diversificationLevel: $diversificationLevel, alerts: $alerts)';
  }
}

/// @nodoc
abstract mixin class $PortfolioRiskAnalysisDtoCopyWith<$Res> {
  factory $PortfolioRiskAnalysisDtoCopyWith(PortfolioRiskAnalysisDto value,
          $Res Function(PortfolioRiskAnalysisDto) _then) =
      _$PortfolioRiskAnalysisDtoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'risk_score') int riskScore,
      @JsonKey(name: 'diversification_level') String diversificationLevel,
      List<RiskAlertDto> alerts});
}

/// @nodoc
class _$PortfolioRiskAnalysisDtoCopyWithImpl<$Res>
    implements $PortfolioRiskAnalysisDtoCopyWith<$Res> {
  _$PortfolioRiskAnalysisDtoCopyWithImpl(this._self, this._then);

  final PortfolioRiskAnalysisDto _self;
  final $Res Function(PortfolioRiskAnalysisDto) _then;

  /// Create a copy of PortfolioRiskAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? riskScore = null,
    Object? diversificationLevel = null,
    Object? alerts = null,
  }) {
    return _then(_self.copyWith(
      riskScore: null == riskScore
          ? _self.riskScore
          : riskScore // ignore: cast_nullable_to_non_nullable
              as int,
      diversificationLevel: null == diversificationLevel
          ? _self.diversificationLevel
          : diversificationLevel // ignore: cast_nullable_to_non_nullable
              as String,
      alerts: null == alerts
          ? _self.alerts
          : alerts // ignore: cast_nullable_to_non_nullable
              as List<RiskAlertDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [PortfolioRiskAnalysisDto].
extension PortfolioRiskAnalysisDtoPatterns on PortfolioRiskAnalysisDto {
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
    TResult Function(_PortfolioRiskAnalysisDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PortfolioRiskAnalysisDto() when $default != null:
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
    TResult Function(_PortfolioRiskAnalysisDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioRiskAnalysisDto():
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
    TResult? Function(_PortfolioRiskAnalysisDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioRiskAnalysisDto() when $default != null:
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
            @JsonKey(name: 'risk_score') int riskScore,
            @JsonKey(name: 'diversification_level') String diversificationLevel,
            List<RiskAlertDto> alerts)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PortfolioRiskAnalysisDto() when $default != null:
        return $default(
            _that.riskScore, _that.diversificationLevel, _that.alerts);
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
            @JsonKey(name: 'risk_score') int riskScore,
            @JsonKey(name: 'diversification_level') String diversificationLevel,
            List<RiskAlertDto> alerts)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioRiskAnalysisDto():
        return $default(
            _that.riskScore, _that.diversificationLevel, _that.alerts);
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
            @JsonKey(name: 'risk_score') int riskScore,
            @JsonKey(name: 'diversification_level') String diversificationLevel,
            List<RiskAlertDto> alerts)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioRiskAnalysisDto() when $default != null:
        return $default(
            _that.riskScore, _that.diversificationLevel, _that.alerts);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PortfolioRiskAnalysisDto implements PortfolioRiskAnalysisDto {
  const _PortfolioRiskAnalysisDto(
      {@JsonKey(name: 'risk_score') required this.riskScore,
      @JsonKey(name: 'diversification_level')
      required this.diversificationLevel,
      required final List<RiskAlertDto> alerts})
      : _alerts = alerts;
  factory _PortfolioRiskAnalysisDto.fromJson(Map<String, dynamic> json) =>
      _$PortfolioRiskAnalysisDtoFromJson(json);

  @override
  @JsonKey(name: 'risk_score')
  final int riskScore;
  @override
  @JsonKey(name: 'diversification_level')
  final String diversificationLevel;
  final List<RiskAlertDto> _alerts;
  @override
  List<RiskAlertDto> get alerts {
    if (_alerts is EqualUnmodifiableListView) return _alerts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alerts);
  }

  /// Create a copy of PortfolioRiskAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PortfolioRiskAnalysisDtoCopyWith<_PortfolioRiskAnalysisDto> get copyWith =>
      __$PortfolioRiskAnalysisDtoCopyWithImpl<_PortfolioRiskAnalysisDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PortfolioRiskAnalysisDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PortfolioRiskAnalysisDto &&
            (identical(other.riskScore, riskScore) ||
                other.riskScore == riskScore) &&
            (identical(other.diversificationLevel, diversificationLevel) ||
                other.diversificationLevel == diversificationLevel) &&
            const DeepCollectionEquality().equals(other._alerts, _alerts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, riskScore, diversificationLevel,
      const DeepCollectionEquality().hash(_alerts));

  @override
  String toString() {
    return 'PortfolioRiskAnalysisDto(riskScore: $riskScore, diversificationLevel: $diversificationLevel, alerts: $alerts)';
  }
}

/// @nodoc
abstract mixin class _$PortfolioRiskAnalysisDtoCopyWith<$Res>
    implements $PortfolioRiskAnalysisDtoCopyWith<$Res> {
  factory _$PortfolioRiskAnalysisDtoCopyWith(_PortfolioRiskAnalysisDto value,
          $Res Function(_PortfolioRiskAnalysisDto) _then) =
      __$PortfolioRiskAnalysisDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'risk_score') int riskScore,
      @JsonKey(name: 'diversification_level') String diversificationLevel,
      List<RiskAlertDto> alerts});
}

/// @nodoc
class __$PortfolioRiskAnalysisDtoCopyWithImpl<$Res>
    implements _$PortfolioRiskAnalysisDtoCopyWith<$Res> {
  __$PortfolioRiskAnalysisDtoCopyWithImpl(this._self, this._then);

  final _PortfolioRiskAnalysisDto _self;
  final $Res Function(_PortfolioRiskAnalysisDto) _then;

  /// Create a copy of PortfolioRiskAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? riskScore = null,
    Object? diversificationLevel = null,
    Object? alerts = null,
  }) {
    return _then(_PortfolioRiskAnalysisDto(
      riskScore: null == riskScore
          ? _self.riskScore
          : riskScore // ignore: cast_nullable_to_non_nullable
              as int,
      diversificationLevel: null == diversificationLevel
          ? _self.diversificationLevel
          : diversificationLevel // ignore: cast_nullable_to_non_nullable
              as String,
      alerts: null == alerts
          ? _self._alerts
          : alerts // ignore: cast_nullable_to_non_nullable
              as List<RiskAlertDto>,
    ));
  }
}

/// @nodoc
mixin _$RiskAlertDto {
  String get type;
  String get title;
  String get message;
  String get severity;
  double get value;
  double get threshold;

  /// Create a copy of RiskAlertDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RiskAlertDtoCopyWith<RiskAlertDto> get copyWith =>
      _$RiskAlertDtoCopyWithImpl<RiskAlertDto>(
          this as RiskAlertDto, _$identity);

  /// Serializes this RiskAlertDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RiskAlertDto &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, title, message, severity, value, threshold);

  @override
  String toString() {
    return 'RiskAlertDto(type: $type, title: $title, message: $message, severity: $severity, value: $value, threshold: $threshold)';
  }
}

/// @nodoc
abstract mixin class $RiskAlertDtoCopyWith<$Res> {
  factory $RiskAlertDtoCopyWith(
          RiskAlertDto value, $Res Function(RiskAlertDto) _then) =
      _$RiskAlertDtoCopyWithImpl;
  @useResult
  $Res call(
      {String type,
      String title,
      String message,
      String severity,
      double value,
      double threshold});
}

/// @nodoc
class _$RiskAlertDtoCopyWithImpl<$Res> implements $RiskAlertDtoCopyWith<$Res> {
  _$RiskAlertDtoCopyWithImpl(this._self, this._then);

  final RiskAlertDto _self;
  final $Res Function(RiskAlertDto) _then;

  /// Create a copy of RiskAlertDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? message = null,
    Object? severity = null,
    Object? value = null,
    Object? threshold = null,
  }) {
    return _then(_self.copyWith(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _self.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      threshold: null == threshold
          ? _self.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [RiskAlertDto].
extension RiskAlertDtoPatterns on RiskAlertDto {
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
    TResult Function(_RiskAlertDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RiskAlertDto() when $default != null:
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
    TResult Function(_RiskAlertDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RiskAlertDto():
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
    TResult? Function(_RiskAlertDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RiskAlertDto() when $default != null:
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
    TResult Function(String type, String title, String message, String severity,
            double value, double threshold)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RiskAlertDto() when $default != null:
        return $default(_that.type, _that.title, _that.message, _that.severity,
            _that.value, _that.threshold);
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
    TResult Function(String type, String title, String message, String severity,
            double value, double threshold)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RiskAlertDto():
        return $default(_that.type, _that.title, _that.message, _that.severity,
            _that.value, _that.threshold);
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
    TResult? Function(String type, String title, String message,
            String severity, double value, double threshold)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RiskAlertDto() when $default != null:
        return $default(_that.type, _that.title, _that.message, _that.severity,
            _that.value, _that.threshold);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RiskAlertDto implements RiskAlertDto {
  const _RiskAlertDto(
      {required this.type,
      required this.title,
      required this.message,
      required this.severity,
      required this.value,
      required this.threshold});
  factory _RiskAlertDto.fromJson(Map<String, dynamic> json) =>
      _$RiskAlertDtoFromJson(json);

  @override
  final String type;
  @override
  final String title;
  @override
  final String message;
  @override
  final String severity;
  @override
  final double value;
  @override
  final double threshold;

  /// Create a copy of RiskAlertDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RiskAlertDtoCopyWith<_RiskAlertDto> get copyWith =>
      __$RiskAlertDtoCopyWithImpl<_RiskAlertDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RiskAlertDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RiskAlertDto &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, title, message, severity, value, threshold);

  @override
  String toString() {
    return 'RiskAlertDto(type: $type, title: $title, message: $message, severity: $severity, value: $value, threshold: $threshold)';
  }
}

/// @nodoc
abstract mixin class _$RiskAlertDtoCopyWith<$Res>
    implements $RiskAlertDtoCopyWith<$Res> {
  factory _$RiskAlertDtoCopyWith(
          _RiskAlertDto value, $Res Function(_RiskAlertDto) _then) =
      __$RiskAlertDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String type,
      String title,
      String message,
      String severity,
      double value,
      double threshold});
}

/// @nodoc
class __$RiskAlertDtoCopyWithImpl<$Res>
    implements _$RiskAlertDtoCopyWith<$Res> {
  __$RiskAlertDtoCopyWithImpl(this._self, this._then);

  final _RiskAlertDto _self;
  final $Res Function(_RiskAlertDto) _then;

  /// Create a copy of RiskAlertDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? message = null,
    Object? severity = null,
    Object? value = null,
    Object? threshold = null,
  }) {
    return _then(_RiskAlertDto(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _self.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      threshold: null == threshold
          ? _self.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
