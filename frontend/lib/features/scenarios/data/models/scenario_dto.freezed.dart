// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scenario_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AllocationItemDto {
  String get type;
  double get value;
  double get percent;

  /// Create a copy of AllocationItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AllocationItemDtoCopyWith<AllocationItemDto> get copyWith =>
      _$AllocationItemDtoCopyWithImpl<AllocationItemDto>(
          this as AllocationItemDto, _$identity);

  /// Serializes this AllocationItemDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AllocationItemDto &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.percent, percent) || other.percent == percent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, value, percent);

  @override
  String toString() {
    return 'AllocationItemDto(type: $type, value: $value, percent: $percent)';
  }
}

/// @nodoc
abstract mixin class $AllocationItemDtoCopyWith<$Res> {
  factory $AllocationItemDtoCopyWith(
          AllocationItemDto value, $Res Function(AllocationItemDto) _then) =
      _$AllocationItemDtoCopyWithImpl;
  @useResult
  $Res call({String type, double value, double percent});
}

/// @nodoc
class _$AllocationItemDtoCopyWithImpl<$Res>
    implements $AllocationItemDtoCopyWith<$Res> {
  _$AllocationItemDtoCopyWithImpl(this._self, this._then);

  final AllocationItemDto _self;
  final $Res Function(AllocationItemDto) _then;

  /// Create a copy of AllocationItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? value = null,
    Object? percent = null,
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
    ));
  }
}

/// Adds pattern-matching-related methods to [AllocationItemDto].
extension AllocationItemDtoPatterns on AllocationItemDto {
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
    TResult Function(_AllocationItemDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AllocationItemDto() when $default != null:
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
    TResult Function(_AllocationItemDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllocationItemDto():
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
    TResult? Function(_AllocationItemDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllocationItemDto() when $default != null:
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
    TResult Function(String type, double value, double percent)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AllocationItemDto() when $default != null:
        return $default(_that.type, _that.value, _that.percent);
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
    TResult Function(String type, double value, double percent) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllocationItemDto():
        return $default(_that.type, _that.value, _that.percent);
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
    TResult? Function(String type, double value, double percent)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllocationItemDto() when $default != null:
        return $default(_that.type, _that.value, _that.percent);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AllocationItemDto implements AllocationItemDto {
  const _AllocationItemDto(
      {required this.type, required this.value, required this.percent});
  factory _AllocationItemDto.fromJson(Map<String, dynamic> json) =>
      _$AllocationItemDtoFromJson(json);

  @override
  final String type;
  @override
  final double value;
  @override
  final double percent;

  /// Create a copy of AllocationItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AllocationItemDtoCopyWith<_AllocationItemDto> get copyWith =>
      __$AllocationItemDtoCopyWithImpl<_AllocationItemDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AllocationItemDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AllocationItemDto &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.percent, percent) || other.percent == percent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, value, percent);

  @override
  String toString() {
    return 'AllocationItemDto(type: $type, value: $value, percent: $percent)';
  }
}

/// @nodoc
abstract mixin class _$AllocationItemDtoCopyWith<$Res>
    implements $AllocationItemDtoCopyWith<$Res> {
  factory _$AllocationItemDtoCopyWith(
          _AllocationItemDto value, $Res Function(_AllocationItemDto) _then) =
      __$AllocationItemDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String type, double value, double percent});
}

/// @nodoc
class __$AllocationItemDtoCopyWithImpl<$Res>
    implements _$AllocationItemDtoCopyWith<$Res> {
  __$AllocationItemDtoCopyWithImpl(this._self, this._then);

  final _AllocationItemDto _self;
  final $Res Function(_AllocationItemDto) _then;

  /// Create a copy of AllocationItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? value = null,
    Object? percent = null,
  }) {
    return _then(_AllocationItemDto(
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
    ));
  }
}

/// @nodoc
mixin _$PortfolioStateDto {
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
  List<AllocationItemDto> get allocation;

  /// Create a copy of PortfolioStateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PortfolioStateDtoCopyWith<PortfolioStateDto> get copyWith =>
      _$PortfolioStateDtoCopyWithImpl<PortfolioStateDto>(
          this as PortfolioStateDto, _$identity);

  /// Serializes this PortfolioStateDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PortfolioStateDto &&
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
                .equals(other.allocation, allocation));
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
      const DeepCollectionEquality().hash(allocation));

  @override
  String toString() {
    return 'PortfolioStateDto(totalValue: $totalValue, totalInvested: $totalInvested, gainLoss: $gainLoss, gainLossPercent: $gainLossPercent, assetCount: $assetCount, allocation: $allocation)';
  }
}

/// @nodoc
abstract mixin class $PortfolioStateDtoCopyWith<$Res> {
  factory $PortfolioStateDtoCopyWith(
          PortfolioStateDto value, $Res Function(PortfolioStateDto) _then) =
      _$PortfolioStateDtoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_value') double totalValue,
      @JsonKey(name: 'total_invested') double totalInvested,
      @JsonKey(name: 'gain_loss') double gainLoss,
      @JsonKey(name: 'gain_loss_percent') double gainLossPercent,
      @JsonKey(name: 'asset_count') int assetCount,
      List<AllocationItemDto> allocation});
}

/// @nodoc
class _$PortfolioStateDtoCopyWithImpl<$Res>
    implements $PortfolioStateDtoCopyWith<$Res> {
  _$PortfolioStateDtoCopyWithImpl(this._self, this._then);

  final PortfolioStateDto _self;
  final $Res Function(PortfolioStateDto) _then;

  /// Create a copy of PortfolioStateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalValue = null,
    Object? totalInvested = null,
    Object? gainLoss = null,
    Object? gainLossPercent = null,
    Object? assetCount = null,
    Object? allocation = null,
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
      allocation: null == allocation
          ? _self.allocation
          : allocation // ignore: cast_nullable_to_non_nullable
              as List<AllocationItemDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [PortfolioStateDto].
extension PortfolioStateDtoPatterns on PortfolioStateDto {
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
    TResult Function(_PortfolioStateDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PortfolioStateDto() when $default != null:
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
    TResult Function(_PortfolioStateDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioStateDto():
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
    TResult? Function(_PortfolioStateDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioStateDto() when $default != null:
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
            List<AllocationItemDto> allocation)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PortfolioStateDto() when $default != null:
        return $default(_that.totalValue, _that.totalInvested, _that.gainLoss,
            _that.gainLossPercent, _that.assetCount, _that.allocation);
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
            List<AllocationItemDto> allocation)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioStateDto():
        return $default(_that.totalValue, _that.totalInvested, _that.gainLoss,
            _that.gainLossPercent, _that.assetCount, _that.allocation);
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
            List<AllocationItemDto> allocation)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioStateDto() when $default != null:
        return $default(_that.totalValue, _that.totalInvested, _that.gainLoss,
            _that.gainLossPercent, _that.assetCount, _that.allocation);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PortfolioStateDto implements PortfolioStateDto {
  const _PortfolioStateDto(
      {@JsonKey(name: 'total_value') required this.totalValue,
      @JsonKey(name: 'total_invested') required this.totalInvested,
      @JsonKey(name: 'gain_loss') required this.gainLoss,
      @JsonKey(name: 'gain_loss_percent') required this.gainLossPercent,
      @JsonKey(name: 'asset_count') required this.assetCount,
      required final List<AllocationItemDto> allocation})
      : _allocation = allocation;
  factory _PortfolioStateDto.fromJson(Map<String, dynamic> json) =>
      _$PortfolioStateDtoFromJson(json);

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
  final List<AllocationItemDto> _allocation;
  @override
  List<AllocationItemDto> get allocation {
    if (_allocation is EqualUnmodifiableListView) return _allocation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allocation);
  }

  /// Create a copy of PortfolioStateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PortfolioStateDtoCopyWith<_PortfolioStateDto> get copyWith =>
      __$PortfolioStateDtoCopyWithImpl<_PortfolioStateDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PortfolioStateDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PortfolioStateDto &&
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
                .equals(other._allocation, _allocation));
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
      const DeepCollectionEquality().hash(_allocation));

  @override
  String toString() {
    return 'PortfolioStateDto(totalValue: $totalValue, totalInvested: $totalInvested, gainLoss: $gainLoss, gainLossPercent: $gainLossPercent, assetCount: $assetCount, allocation: $allocation)';
  }
}

/// @nodoc
abstract mixin class _$PortfolioStateDtoCopyWith<$Res>
    implements $PortfolioStateDtoCopyWith<$Res> {
  factory _$PortfolioStateDtoCopyWith(
          _PortfolioStateDto value, $Res Function(_PortfolioStateDto) _then) =
      __$PortfolioStateDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_value') double totalValue,
      @JsonKey(name: 'total_invested') double totalInvested,
      @JsonKey(name: 'gain_loss') double gainLoss,
      @JsonKey(name: 'gain_loss_percent') double gainLossPercent,
      @JsonKey(name: 'asset_count') int assetCount,
      List<AllocationItemDto> allocation});
}

/// @nodoc
class __$PortfolioStateDtoCopyWithImpl<$Res>
    implements _$PortfolioStateDtoCopyWith<$Res> {
  __$PortfolioStateDtoCopyWithImpl(this._self, this._then);

  final _PortfolioStateDto _self;
  final $Res Function(_PortfolioStateDto) _then;

  /// Create a copy of PortfolioStateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? totalValue = null,
    Object? totalInvested = null,
    Object? gainLoss = null,
    Object? gainLossPercent = null,
    Object? assetCount = null,
    Object? allocation = null,
  }) {
    return _then(_PortfolioStateDto(
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
      allocation: null == allocation
          ? _self._allocation
          : allocation // ignore: cast_nullable_to_non_nullable
              as List<AllocationItemDto>,
    ));
  }
}

/// @nodoc
mixin _$ChangeDetailDto {
  String get type;
  String get description;
  @JsonKey(name: 'old_value')
  double get oldValue;
  @JsonKey(name: 'new_value')
  double get newValue;
  double get difference;

  /// Create a copy of ChangeDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChangeDetailDtoCopyWith<ChangeDetailDto> get copyWith =>
      _$ChangeDetailDtoCopyWithImpl<ChangeDetailDto>(
          this as ChangeDetailDto, _$identity);

  /// Serializes this ChangeDetailDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChangeDetailDto &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.oldValue, oldValue) ||
                other.oldValue == oldValue) &&
            (identical(other.newValue, newValue) ||
                other.newValue == newValue) &&
            (identical(other.difference, difference) ||
                other.difference == difference));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, description, oldValue, newValue, difference);

  @override
  String toString() {
    return 'ChangeDetailDto(type: $type, description: $description, oldValue: $oldValue, newValue: $newValue, difference: $difference)';
  }
}

/// @nodoc
abstract mixin class $ChangeDetailDtoCopyWith<$Res> {
  factory $ChangeDetailDtoCopyWith(
          ChangeDetailDto value, $Res Function(ChangeDetailDto) _then) =
      _$ChangeDetailDtoCopyWithImpl;
  @useResult
  $Res call(
      {String type,
      String description,
      @JsonKey(name: 'old_value') double oldValue,
      @JsonKey(name: 'new_value') double newValue,
      double difference});
}

/// @nodoc
class _$ChangeDetailDtoCopyWithImpl<$Res>
    implements $ChangeDetailDtoCopyWith<$Res> {
  _$ChangeDetailDtoCopyWithImpl(this._self, this._then);

  final ChangeDetailDto _self;
  final $Res Function(ChangeDetailDto) _then;

  /// Create a copy of ChangeDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? description = null,
    Object? oldValue = null,
    Object? newValue = null,
    Object? difference = null,
  }) {
    return _then(_self.copyWith(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      oldValue: null == oldValue
          ? _self.oldValue
          : oldValue // ignore: cast_nullable_to_non_nullable
              as double,
      newValue: null == newValue
          ? _self.newValue
          : newValue // ignore: cast_nullable_to_non_nullable
              as double,
      difference: null == difference
          ? _self.difference
          : difference // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [ChangeDetailDto].
extension ChangeDetailDtoPatterns on ChangeDetailDto {
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
    TResult Function(_ChangeDetailDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChangeDetailDto() when $default != null:
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
    TResult Function(_ChangeDetailDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChangeDetailDto():
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
    TResult? Function(_ChangeDetailDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChangeDetailDto() when $default != null:
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
            String type,
            String description,
            @JsonKey(name: 'old_value') double oldValue,
            @JsonKey(name: 'new_value') double newValue,
            double difference)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChangeDetailDto() when $default != null:
        return $default(_that.type, _that.description, _that.oldValue,
            _that.newValue, _that.difference);
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
            String type,
            String description,
            @JsonKey(name: 'old_value') double oldValue,
            @JsonKey(name: 'new_value') double newValue,
            double difference)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChangeDetailDto():
        return $default(_that.type, _that.description, _that.oldValue,
            _that.newValue, _that.difference);
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
            String type,
            String description,
            @JsonKey(name: 'old_value') double oldValue,
            @JsonKey(name: 'new_value') double newValue,
            double difference)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChangeDetailDto() when $default != null:
        return $default(_that.type, _that.description, _that.oldValue,
            _that.newValue, _that.difference);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ChangeDetailDto implements ChangeDetailDto {
  const _ChangeDetailDto(
      {required this.type,
      required this.description,
      @JsonKey(name: 'old_value') required this.oldValue,
      @JsonKey(name: 'new_value') required this.newValue,
      required this.difference});
  factory _ChangeDetailDto.fromJson(Map<String, dynamic> json) =>
      _$ChangeDetailDtoFromJson(json);

  @override
  final String type;
  @override
  final String description;
  @override
  @JsonKey(name: 'old_value')
  final double oldValue;
  @override
  @JsonKey(name: 'new_value')
  final double newValue;
  @override
  final double difference;

  /// Create a copy of ChangeDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChangeDetailDtoCopyWith<_ChangeDetailDto> get copyWith =>
      __$ChangeDetailDtoCopyWithImpl<_ChangeDetailDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ChangeDetailDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChangeDetailDto &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.oldValue, oldValue) ||
                other.oldValue == oldValue) &&
            (identical(other.newValue, newValue) ||
                other.newValue == newValue) &&
            (identical(other.difference, difference) ||
                other.difference == difference));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, description, oldValue, newValue, difference);

  @override
  String toString() {
    return 'ChangeDetailDto(type: $type, description: $description, oldValue: $oldValue, newValue: $newValue, difference: $difference)';
  }
}

/// @nodoc
abstract mixin class _$ChangeDetailDtoCopyWith<$Res>
    implements $ChangeDetailDtoCopyWith<$Res> {
  factory _$ChangeDetailDtoCopyWith(
          _ChangeDetailDto value, $Res Function(_ChangeDetailDto) _then) =
      __$ChangeDetailDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String type,
      String description,
      @JsonKey(name: 'old_value') double oldValue,
      @JsonKey(name: 'new_value') double newValue,
      double difference});
}

/// @nodoc
class __$ChangeDetailDtoCopyWithImpl<$Res>
    implements _$ChangeDetailDtoCopyWith<$Res> {
  __$ChangeDetailDtoCopyWithImpl(this._self, this._then);

  final _ChangeDetailDto _self;
  final $Res Function(_ChangeDetailDto) _then;

  /// Create a copy of ChangeDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? description = null,
    Object? oldValue = null,
    Object? newValue = null,
    Object? difference = null,
  }) {
    return _then(_ChangeDetailDto(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      oldValue: null == oldValue
          ? _self.oldValue
          : oldValue // ignore: cast_nullable_to_non_nullable
              as double,
      newValue: null == newValue
          ? _self.newValue
          : newValue // ignore: cast_nullable_to_non_nullable
              as double,
      difference: null == difference
          ? _self.difference
          : difference // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
mixin _$SimulationResultDto {
  @JsonKey(name: 'current_state')
  PortfolioStateDto get currentState;
  @JsonKey(name: 'projected_state')
  PortfolioStateDto get projectedState;
  List<ChangeDetailDto> get changes;
  @JsonKey(name: 'ai_analysis')
  String get aiAnalysis;
  List<String> get warnings;

  /// Create a copy of SimulationResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SimulationResultDtoCopyWith<SimulationResultDto> get copyWith =>
      _$SimulationResultDtoCopyWithImpl<SimulationResultDto>(
          this as SimulationResultDto, _$identity);

  /// Serializes this SimulationResultDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SimulationResultDto &&
            (identical(other.currentState, currentState) ||
                other.currentState == currentState) &&
            (identical(other.projectedState, projectedState) ||
                other.projectedState == projectedState) &&
            const DeepCollectionEquality().equals(other.changes, changes) &&
            (identical(other.aiAnalysis, aiAnalysis) ||
                other.aiAnalysis == aiAnalysis) &&
            const DeepCollectionEquality().equals(other.warnings, warnings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentState,
      projectedState,
      const DeepCollectionEquality().hash(changes),
      aiAnalysis,
      const DeepCollectionEquality().hash(warnings));

  @override
  String toString() {
    return 'SimulationResultDto(currentState: $currentState, projectedState: $projectedState, changes: $changes, aiAnalysis: $aiAnalysis, warnings: $warnings)';
  }
}

/// @nodoc
abstract mixin class $SimulationResultDtoCopyWith<$Res> {
  factory $SimulationResultDtoCopyWith(
          SimulationResultDto value, $Res Function(SimulationResultDto) _then) =
      _$SimulationResultDtoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'current_state') PortfolioStateDto currentState,
      @JsonKey(name: 'projected_state') PortfolioStateDto projectedState,
      List<ChangeDetailDto> changes,
      @JsonKey(name: 'ai_analysis') String aiAnalysis,
      List<String> warnings});

  $PortfolioStateDtoCopyWith<$Res> get currentState;
  $PortfolioStateDtoCopyWith<$Res> get projectedState;
}

/// @nodoc
class _$SimulationResultDtoCopyWithImpl<$Res>
    implements $SimulationResultDtoCopyWith<$Res> {
  _$SimulationResultDtoCopyWithImpl(this._self, this._then);

  final SimulationResultDto _self;
  final $Res Function(SimulationResultDto) _then;

  /// Create a copy of SimulationResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentState = null,
    Object? projectedState = null,
    Object? changes = null,
    Object? aiAnalysis = null,
    Object? warnings = null,
  }) {
    return _then(_self.copyWith(
      currentState: null == currentState
          ? _self.currentState
          : currentState // ignore: cast_nullable_to_non_nullable
              as PortfolioStateDto,
      projectedState: null == projectedState
          ? _self.projectedState
          : projectedState // ignore: cast_nullable_to_non_nullable
              as PortfolioStateDto,
      changes: null == changes
          ? _self.changes
          : changes // ignore: cast_nullable_to_non_nullable
              as List<ChangeDetailDto>,
      aiAnalysis: null == aiAnalysis
          ? _self.aiAnalysis
          : aiAnalysis // ignore: cast_nullable_to_non_nullable
              as String,
      warnings: null == warnings
          ? _self.warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }

  /// Create a copy of SimulationResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PortfolioStateDtoCopyWith<$Res> get currentState {
    return $PortfolioStateDtoCopyWith<$Res>(_self.currentState, (value) {
      return _then(_self.copyWith(currentState: value));
    });
  }

  /// Create a copy of SimulationResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PortfolioStateDtoCopyWith<$Res> get projectedState {
    return $PortfolioStateDtoCopyWith<$Res>(_self.projectedState, (value) {
      return _then(_self.copyWith(projectedState: value));
    });
  }
}

/// Adds pattern-matching-related methods to [SimulationResultDto].
extension SimulationResultDtoPatterns on SimulationResultDto {
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
    TResult Function(_SimulationResultDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimulationResultDto() when $default != null:
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
    TResult Function(_SimulationResultDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimulationResultDto():
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
    TResult? Function(_SimulationResultDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimulationResultDto() when $default != null:
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
            @JsonKey(name: 'current_state') PortfolioStateDto currentState,
            @JsonKey(name: 'projected_state') PortfolioStateDto projectedState,
            List<ChangeDetailDto> changes,
            @JsonKey(name: 'ai_analysis') String aiAnalysis,
            List<String> warnings)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimulationResultDto() when $default != null:
        return $default(_that.currentState, _that.projectedState, _that.changes,
            _that.aiAnalysis, _that.warnings);
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
            @JsonKey(name: 'current_state') PortfolioStateDto currentState,
            @JsonKey(name: 'projected_state') PortfolioStateDto projectedState,
            List<ChangeDetailDto> changes,
            @JsonKey(name: 'ai_analysis') String aiAnalysis,
            List<String> warnings)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimulationResultDto():
        return $default(_that.currentState, _that.projectedState, _that.changes,
            _that.aiAnalysis, _that.warnings);
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
            @JsonKey(name: 'current_state') PortfolioStateDto currentState,
            @JsonKey(name: 'projected_state') PortfolioStateDto projectedState,
            List<ChangeDetailDto> changes,
            @JsonKey(name: 'ai_analysis') String aiAnalysis,
            List<String> warnings)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimulationResultDto() when $default != null:
        return $default(_that.currentState, _that.projectedState, _that.changes,
            _that.aiAnalysis, _that.warnings);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SimulationResultDto implements SimulationResultDto {
  const _SimulationResultDto(
      {@JsonKey(name: 'current_state') required this.currentState,
      @JsonKey(name: 'projected_state') required this.projectedState,
      required final List<ChangeDetailDto> changes,
      @JsonKey(name: 'ai_analysis') required this.aiAnalysis,
      required final List<String> warnings})
      : _changes = changes,
        _warnings = warnings;
  factory _SimulationResultDto.fromJson(Map<String, dynamic> json) =>
      _$SimulationResultDtoFromJson(json);

  @override
  @JsonKey(name: 'current_state')
  final PortfolioStateDto currentState;
  @override
  @JsonKey(name: 'projected_state')
  final PortfolioStateDto projectedState;
  final List<ChangeDetailDto> _changes;
  @override
  List<ChangeDetailDto> get changes {
    if (_changes is EqualUnmodifiableListView) return _changes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_changes);
  }

  @override
  @JsonKey(name: 'ai_analysis')
  final String aiAnalysis;
  final List<String> _warnings;
  @override
  List<String> get warnings {
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warnings);
  }

  /// Create a copy of SimulationResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SimulationResultDtoCopyWith<_SimulationResultDto> get copyWith =>
      __$SimulationResultDtoCopyWithImpl<_SimulationResultDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SimulationResultDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SimulationResultDto &&
            (identical(other.currentState, currentState) ||
                other.currentState == currentState) &&
            (identical(other.projectedState, projectedState) ||
                other.projectedState == projectedState) &&
            const DeepCollectionEquality().equals(other._changes, _changes) &&
            (identical(other.aiAnalysis, aiAnalysis) ||
                other.aiAnalysis == aiAnalysis) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentState,
      projectedState,
      const DeepCollectionEquality().hash(_changes),
      aiAnalysis,
      const DeepCollectionEquality().hash(_warnings));

  @override
  String toString() {
    return 'SimulationResultDto(currentState: $currentState, projectedState: $projectedState, changes: $changes, aiAnalysis: $aiAnalysis, warnings: $warnings)';
  }
}

/// @nodoc
abstract mixin class _$SimulationResultDtoCopyWith<$Res>
    implements $SimulationResultDtoCopyWith<$Res> {
  factory _$SimulationResultDtoCopyWith(_SimulationResultDto value,
          $Res Function(_SimulationResultDto) _then) =
      __$SimulationResultDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'current_state') PortfolioStateDto currentState,
      @JsonKey(name: 'projected_state') PortfolioStateDto projectedState,
      List<ChangeDetailDto> changes,
      @JsonKey(name: 'ai_analysis') String aiAnalysis,
      List<String> warnings});

  @override
  $PortfolioStateDtoCopyWith<$Res> get currentState;
  @override
  $PortfolioStateDtoCopyWith<$Res> get projectedState;
}

/// @nodoc
class __$SimulationResultDtoCopyWithImpl<$Res>
    implements _$SimulationResultDtoCopyWith<$Res> {
  __$SimulationResultDtoCopyWithImpl(this._self, this._then);

  final _SimulationResultDto _self;
  final $Res Function(_SimulationResultDto) _then;

  /// Create a copy of SimulationResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? currentState = null,
    Object? projectedState = null,
    Object? changes = null,
    Object? aiAnalysis = null,
    Object? warnings = null,
  }) {
    return _then(_SimulationResultDto(
      currentState: null == currentState
          ? _self.currentState
          : currentState // ignore: cast_nullable_to_non_nullable
              as PortfolioStateDto,
      projectedState: null == projectedState
          ? _self.projectedState
          : projectedState // ignore: cast_nullable_to_non_nullable
              as PortfolioStateDto,
      changes: null == changes
          ? _self._changes
          : changes // ignore: cast_nullable_to_non_nullable
              as List<ChangeDetailDto>,
      aiAnalysis: null == aiAnalysis
          ? _self.aiAnalysis
          : aiAnalysis // ignore: cast_nullable_to_non_nullable
              as String,
      warnings: null == warnings
          ? _self._warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }

  /// Create a copy of SimulationResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PortfolioStateDtoCopyWith<$Res> get currentState {
    return $PortfolioStateDtoCopyWith<$Res>(_self.currentState, (value) {
      return _then(_self.copyWith(currentState: value));
    });
  }

  /// Create a copy of SimulationResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PortfolioStateDtoCopyWith<$Res> get projectedState {
    return $PortfolioStateDtoCopyWith<$Res>(_self.projectedState, (value) {
      return _then(_self.copyWith(projectedState: value));
    });
  }
}

/// @nodoc
mixin _$HistoricalStatsDto {
  String get symbol;
  String get period;
  double get volatility;
  @JsonKey(name: 'max_drawdown')
  double get maxDrawdown;
  @JsonKey(name: 'average_return')
  double get averageReturn;
  @JsonKey(name: 'best_day')
  double get bestDay;
  @JsonKey(name: 'worst_day')
  double get worstDay;
  @JsonKey(name: 'positive_days')
  int get positiveDays;
  @JsonKey(name: 'negative_days')
  int get negativeDays;
  @JsonKey(name: 'data_points')
  int get dataPoints;

  /// Create a copy of HistoricalStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HistoricalStatsDtoCopyWith<HistoricalStatsDto> get copyWith =>
      _$HistoricalStatsDtoCopyWithImpl<HistoricalStatsDto>(
          this as HistoricalStatsDto, _$identity);

  /// Serializes this HistoricalStatsDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HistoricalStatsDto &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.volatility, volatility) ||
                other.volatility == volatility) &&
            (identical(other.maxDrawdown, maxDrawdown) ||
                other.maxDrawdown == maxDrawdown) &&
            (identical(other.averageReturn, averageReturn) ||
                other.averageReturn == averageReturn) &&
            (identical(other.bestDay, bestDay) || other.bestDay == bestDay) &&
            (identical(other.worstDay, worstDay) ||
                other.worstDay == worstDay) &&
            (identical(other.positiveDays, positiveDays) ||
                other.positiveDays == positiveDays) &&
            (identical(other.negativeDays, negativeDays) ||
                other.negativeDays == negativeDays) &&
            (identical(other.dataPoints, dataPoints) ||
                other.dataPoints == dataPoints));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      symbol,
      period,
      volatility,
      maxDrawdown,
      averageReturn,
      bestDay,
      worstDay,
      positiveDays,
      negativeDays,
      dataPoints);

  @override
  String toString() {
    return 'HistoricalStatsDto(symbol: $symbol, period: $period, volatility: $volatility, maxDrawdown: $maxDrawdown, averageReturn: $averageReturn, bestDay: $bestDay, worstDay: $worstDay, positiveDays: $positiveDays, negativeDays: $negativeDays, dataPoints: $dataPoints)';
  }
}

/// @nodoc
abstract mixin class $HistoricalStatsDtoCopyWith<$Res> {
  factory $HistoricalStatsDtoCopyWith(
          HistoricalStatsDto value, $Res Function(HistoricalStatsDto) _then) =
      _$HistoricalStatsDtoCopyWithImpl;
  @useResult
  $Res call(
      {String symbol,
      String period,
      double volatility,
      @JsonKey(name: 'max_drawdown') double maxDrawdown,
      @JsonKey(name: 'average_return') double averageReturn,
      @JsonKey(name: 'best_day') double bestDay,
      @JsonKey(name: 'worst_day') double worstDay,
      @JsonKey(name: 'positive_days') int positiveDays,
      @JsonKey(name: 'negative_days') int negativeDays,
      @JsonKey(name: 'data_points') int dataPoints});
}

/// @nodoc
class _$HistoricalStatsDtoCopyWithImpl<$Res>
    implements $HistoricalStatsDtoCopyWith<$Res> {
  _$HistoricalStatsDtoCopyWithImpl(this._self, this._then);

  final HistoricalStatsDto _self;
  final $Res Function(HistoricalStatsDto) _then;

  /// Create a copy of HistoricalStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? period = null,
    Object? volatility = null,
    Object? maxDrawdown = null,
    Object? averageReturn = null,
    Object? bestDay = null,
    Object? worstDay = null,
    Object? positiveDays = null,
    Object? negativeDays = null,
    Object? dataPoints = null,
  }) {
    return _then(_self.copyWith(
      symbol: null == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _self.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      volatility: null == volatility
          ? _self.volatility
          : volatility // ignore: cast_nullable_to_non_nullable
              as double,
      maxDrawdown: null == maxDrawdown
          ? _self.maxDrawdown
          : maxDrawdown // ignore: cast_nullable_to_non_nullable
              as double,
      averageReturn: null == averageReturn
          ? _self.averageReturn
          : averageReturn // ignore: cast_nullable_to_non_nullable
              as double,
      bestDay: null == bestDay
          ? _self.bestDay
          : bestDay // ignore: cast_nullable_to_non_nullable
              as double,
      worstDay: null == worstDay
          ? _self.worstDay
          : worstDay // ignore: cast_nullable_to_non_nullable
              as double,
      positiveDays: null == positiveDays
          ? _self.positiveDays
          : positiveDays // ignore: cast_nullable_to_non_nullable
              as int,
      negativeDays: null == negativeDays
          ? _self.negativeDays
          : negativeDays // ignore: cast_nullable_to_non_nullable
              as int,
      dataPoints: null == dataPoints
          ? _self.dataPoints
          : dataPoints // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [HistoricalStatsDto].
extension HistoricalStatsDtoPatterns on HistoricalStatsDto {
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
    TResult Function(_HistoricalStatsDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HistoricalStatsDto() when $default != null:
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
    TResult Function(_HistoricalStatsDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HistoricalStatsDto():
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
    TResult? Function(_HistoricalStatsDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HistoricalStatsDto() when $default != null:
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
            String symbol,
            String period,
            double volatility,
            @JsonKey(name: 'max_drawdown') double maxDrawdown,
            @JsonKey(name: 'average_return') double averageReturn,
            @JsonKey(name: 'best_day') double bestDay,
            @JsonKey(name: 'worst_day') double worstDay,
            @JsonKey(name: 'positive_days') int positiveDays,
            @JsonKey(name: 'negative_days') int negativeDays,
            @JsonKey(name: 'data_points') int dataPoints)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HistoricalStatsDto() when $default != null:
        return $default(
            _that.symbol,
            _that.period,
            _that.volatility,
            _that.maxDrawdown,
            _that.averageReturn,
            _that.bestDay,
            _that.worstDay,
            _that.positiveDays,
            _that.negativeDays,
            _that.dataPoints);
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
            String symbol,
            String period,
            double volatility,
            @JsonKey(name: 'max_drawdown') double maxDrawdown,
            @JsonKey(name: 'average_return') double averageReturn,
            @JsonKey(name: 'best_day') double bestDay,
            @JsonKey(name: 'worst_day') double worstDay,
            @JsonKey(name: 'positive_days') int positiveDays,
            @JsonKey(name: 'negative_days') int negativeDays,
            @JsonKey(name: 'data_points') int dataPoints)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HistoricalStatsDto():
        return $default(
            _that.symbol,
            _that.period,
            _that.volatility,
            _that.maxDrawdown,
            _that.averageReturn,
            _that.bestDay,
            _that.worstDay,
            _that.positiveDays,
            _that.negativeDays,
            _that.dataPoints);
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
            String symbol,
            String period,
            double volatility,
            @JsonKey(name: 'max_drawdown') double maxDrawdown,
            @JsonKey(name: 'average_return') double averageReturn,
            @JsonKey(name: 'best_day') double bestDay,
            @JsonKey(name: 'worst_day') double worstDay,
            @JsonKey(name: 'positive_days') int positiveDays,
            @JsonKey(name: 'negative_days') int negativeDays,
            @JsonKey(name: 'data_points') int dataPoints)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HistoricalStatsDto() when $default != null:
        return $default(
            _that.symbol,
            _that.period,
            _that.volatility,
            _that.maxDrawdown,
            _that.averageReturn,
            _that.bestDay,
            _that.worstDay,
            _that.positiveDays,
            _that.negativeDays,
            _that.dataPoints);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HistoricalStatsDto implements HistoricalStatsDto {
  const _HistoricalStatsDto(
      {required this.symbol,
      required this.period,
      required this.volatility,
      @JsonKey(name: 'max_drawdown') required this.maxDrawdown,
      @JsonKey(name: 'average_return') required this.averageReturn,
      @JsonKey(name: 'best_day') required this.bestDay,
      @JsonKey(name: 'worst_day') required this.worstDay,
      @JsonKey(name: 'positive_days') required this.positiveDays,
      @JsonKey(name: 'negative_days') required this.negativeDays,
      @JsonKey(name: 'data_points') required this.dataPoints});
  factory _HistoricalStatsDto.fromJson(Map<String, dynamic> json) =>
      _$HistoricalStatsDtoFromJson(json);

  @override
  final String symbol;
  @override
  final String period;
  @override
  final double volatility;
  @override
  @JsonKey(name: 'max_drawdown')
  final double maxDrawdown;
  @override
  @JsonKey(name: 'average_return')
  final double averageReturn;
  @override
  @JsonKey(name: 'best_day')
  final double bestDay;
  @override
  @JsonKey(name: 'worst_day')
  final double worstDay;
  @override
  @JsonKey(name: 'positive_days')
  final int positiveDays;
  @override
  @JsonKey(name: 'negative_days')
  final int negativeDays;
  @override
  @JsonKey(name: 'data_points')
  final int dataPoints;

  /// Create a copy of HistoricalStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HistoricalStatsDtoCopyWith<_HistoricalStatsDto> get copyWith =>
      __$HistoricalStatsDtoCopyWithImpl<_HistoricalStatsDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HistoricalStatsDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HistoricalStatsDto &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.volatility, volatility) ||
                other.volatility == volatility) &&
            (identical(other.maxDrawdown, maxDrawdown) ||
                other.maxDrawdown == maxDrawdown) &&
            (identical(other.averageReturn, averageReturn) ||
                other.averageReturn == averageReturn) &&
            (identical(other.bestDay, bestDay) || other.bestDay == bestDay) &&
            (identical(other.worstDay, worstDay) ||
                other.worstDay == worstDay) &&
            (identical(other.positiveDays, positiveDays) ||
                other.positiveDays == positiveDays) &&
            (identical(other.negativeDays, negativeDays) ||
                other.negativeDays == negativeDays) &&
            (identical(other.dataPoints, dataPoints) ||
                other.dataPoints == dataPoints));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      symbol,
      period,
      volatility,
      maxDrawdown,
      averageReturn,
      bestDay,
      worstDay,
      positiveDays,
      negativeDays,
      dataPoints);

  @override
  String toString() {
    return 'HistoricalStatsDto(symbol: $symbol, period: $period, volatility: $volatility, maxDrawdown: $maxDrawdown, averageReturn: $averageReturn, bestDay: $bestDay, worstDay: $worstDay, positiveDays: $positiveDays, negativeDays: $negativeDays, dataPoints: $dataPoints)';
  }
}

/// @nodoc
abstract mixin class _$HistoricalStatsDtoCopyWith<$Res>
    implements $HistoricalStatsDtoCopyWith<$Res> {
  factory _$HistoricalStatsDtoCopyWith(
          _HistoricalStatsDto value, $Res Function(_HistoricalStatsDto) _then) =
      __$HistoricalStatsDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String symbol,
      String period,
      double volatility,
      @JsonKey(name: 'max_drawdown') double maxDrawdown,
      @JsonKey(name: 'average_return') double averageReturn,
      @JsonKey(name: 'best_day') double bestDay,
      @JsonKey(name: 'worst_day') double worstDay,
      @JsonKey(name: 'positive_days') int positiveDays,
      @JsonKey(name: 'negative_days') int negativeDays,
      @JsonKey(name: 'data_points') int dataPoints});
}

/// @nodoc
class __$HistoricalStatsDtoCopyWithImpl<$Res>
    implements _$HistoricalStatsDtoCopyWith<$Res> {
  __$HistoricalStatsDtoCopyWithImpl(this._self, this._then);

  final _HistoricalStatsDto _self;
  final $Res Function(_HistoricalStatsDto) _then;

  /// Create a copy of HistoricalStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? symbol = null,
    Object? period = null,
    Object? volatility = null,
    Object? maxDrawdown = null,
    Object? averageReturn = null,
    Object? bestDay = null,
    Object? worstDay = null,
    Object? positiveDays = null,
    Object? negativeDays = null,
    Object? dataPoints = null,
  }) {
    return _then(_HistoricalStatsDto(
      symbol: null == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _self.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      volatility: null == volatility
          ? _self.volatility
          : volatility // ignore: cast_nullable_to_non_nullable
              as double,
      maxDrawdown: null == maxDrawdown
          ? _self.maxDrawdown
          : maxDrawdown // ignore: cast_nullable_to_non_nullable
              as double,
      averageReturn: null == averageReturn
          ? _self.averageReturn
          : averageReturn // ignore: cast_nullable_to_non_nullable
              as double,
      bestDay: null == bestDay
          ? _self.bestDay
          : bestDay // ignore: cast_nullable_to_non_nullable
              as double,
      worstDay: null == worstDay
          ? _self.worstDay
          : worstDay // ignore: cast_nullable_to_non_nullable
              as double,
      positiveDays: null == positiveDays
          ? _self.positiveDays
          : positiveDays // ignore: cast_nullable_to_non_nullable
              as int,
      negativeDays: null == negativeDays
          ? _self.negativeDays
          : negativeDays // ignore: cast_nullable_to_non_nullable
              as int,
      dataPoints: null == dataPoints
          ? _self.dataPoints
          : dataPoints // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$ScenarioTemplateDto {
  String get id;
  String get name;
  String get description;
  String get type;
  Map<String, dynamic> get parameters;

  /// Create a copy of ScenarioTemplateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScenarioTemplateDtoCopyWith<ScenarioTemplateDto> get copyWith =>
      _$ScenarioTemplateDtoCopyWithImpl<ScenarioTemplateDto>(
          this as ScenarioTemplateDto, _$identity);

  /// Serializes this ScenarioTemplateDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScenarioTemplateDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other.parameters, parameters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, type,
      const DeepCollectionEquality().hash(parameters));

  @override
  String toString() {
    return 'ScenarioTemplateDto(id: $id, name: $name, description: $description, type: $type, parameters: $parameters)';
  }
}

/// @nodoc
abstract mixin class $ScenarioTemplateDtoCopyWith<$Res> {
  factory $ScenarioTemplateDtoCopyWith(
          ScenarioTemplateDto value, $Res Function(ScenarioTemplateDto) _then) =
      _$ScenarioTemplateDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String type,
      Map<String, dynamic> parameters});
}

/// @nodoc
class _$ScenarioTemplateDtoCopyWithImpl<$Res>
    implements $ScenarioTemplateDtoCopyWith<$Res> {
  _$ScenarioTemplateDtoCopyWithImpl(this._self, this._then);

  final ScenarioTemplateDto _self;
  final $Res Function(ScenarioTemplateDto) _then;

  /// Create a copy of ScenarioTemplateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? type = null,
    Object? parameters = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      parameters: null == parameters
          ? _self.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// Adds pattern-matching-related methods to [ScenarioTemplateDto].
extension ScenarioTemplateDtoPatterns on ScenarioTemplateDto {
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
    TResult Function(_ScenarioTemplateDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScenarioTemplateDto() when $default != null:
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
    TResult Function(_ScenarioTemplateDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScenarioTemplateDto():
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
    TResult? Function(_ScenarioTemplateDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScenarioTemplateDto() when $default != null:
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
    TResult Function(String id, String name, String description, String type,
            Map<String, dynamic> parameters)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScenarioTemplateDto() when $default != null:
        return $default(_that.id, _that.name, _that.description, _that.type,
            _that.parameters);
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
    TResult Function(String id, String name, String description, String type,
            Map<String, dynamic> parameters)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScenarioTemplateDto():
        return $default(_that.id, _that.name, _that.description, _that.type,
            _that.parameters);
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
    TResult? Function(String id, String name, String description, String type,
            Map<String, dynamic> parameters)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScenarioTemplateDto() when $default != null:
        return $default(_that.id, _that.name, _that.description, _that.type,
            _that.parameters);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ScenarioTemplateDto implements ScenarioTemplateDto {
  const _ScenarioTemplateDto(
      {required this.id,
      required this.name,
      required this.description,
      required this.type,
      required final Map<String, dynamic> parameters})
      : _parameters = parameters;
  factory _ScenarioTemplateDto.fromJson(Map<String, dynamic> json) =>
      _$ScenarioTemplateDtoFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String type;
  final Map<String, dynamic> _parameters;
  @override
  Map<String, dynamic> get parameters {
    if (_parameters is EqualUnmodifiableMapView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_parameters);
  }

  /// Create a copy of ScenarioTemplateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ScenarioTemplateDtoCopyWith<_ScenarioTemplateDto> get copyWith =>
      __$ScenarioTemplateDtoCopyWithImpl<_ScenarioTemplateDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ScenarioTemplateDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ScenarioTemplateDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, type,
      const DeepCollectionEquality().hash(_parameters));

  @override
  String toString() {
    return 'ScenarioTemplateDto(id: $id, name: $name, description: $description, type: $type, parameters: $parameters)';
  }
}

/// @nodoc
abstract mixin class _$ScenarioTemplateDtoCopyWith<$Res>
    implements $ScenarioTemplateDtoCopyWith<$Res> {
  factory _$ScenarioTemplateDtoCopyWith(_ScenarioTemplateDto value,
          $Res Function(_ScenarioTemplateDto) _then) =
      __$ScenarioTemplateDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String type,
      Map<String, dynamic> parameters});
}

/// @nodoc
class __$ScenarioTemplateDtoCopyWithImpl<$Res>
    implements _$ScenarioTemplateDtoCopyWith<$Res> {
  __$ScenarioTemplateDtoCopyWithImpl(this._self, this._then);

  final _ScenarioTemplateDto _self;
  final $Res Function(_ScenarioTemplateDto) _then;

  /// Create a copy of ScenarioTemplateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? type = null,
    Object? parameters = null,
  }) {
    return _then(_ScenarioTemplateDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      parameters: null == parameters
          ? _self._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
mixin _$SimulateRequestDto {
  String get type;
  Map<String, dynamic> get parameters;

  /// Create a copy of SimulateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SimulateRequestDtoCopyWith<SimulateRequestDto> get copyWith =>
      _$SimulateRequestDtoCopyWithImpl<SimulateRequestDto>(
          this as SimulateRequestDto, _$identity);

  /// Serializes this SimulateRequestDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SimulateRequestDto &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other.parameters, parameters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, const DeepCollectionEquality().hash(parameters));

  @override
  String toString() {
    return 'SimulateRequestDto(type: $type, parameters: $parameters)';
  }
}

/// @nodoc
abstract mixin class $SimulateRequestDtoCopyWith<$Res> {
  factory $SimulateRequestDtoCopyWith(
          SimulateRequestDto value, $Res Function(SimulateRequestDto) _then) =
      _$SimulateRequestDtoCopyWithImpl;
  @useResult
  $Res call({String type, Map<String, dynamic> parameters});
}

/// @nodoc
class _$SimulateRequestDtoCopyWithImpl<$Res>
    implements $SimulateRequestDtoCopyWith<$Res> {
  _$SimulateRequestDtoCopyWithImpl(this._self, this._then);

  final SimulateRequestDto _self;
  final $Res Function(SimulateRequestDto) _then;

  /// Create a copy of SimulateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? parameters = null,
  }) {
    return _then(_self.copyWith(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      parameters: null == parameters
          ? _self.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// Adds pattern-matching-related methods to [SimulateRequestDto].
extension SimulateRequestDtoPatterns on SimulateRequestDto {
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
    TResult Function(_SimulateRequestDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimulateRequestDto() when $default != null:
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
    TResult Function(_SimulateRequestDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimulateRequestDto():
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
    TResult? Function(_SimulateRequestDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimulateRequestDto() when $default != null:
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
    TResult Function(String type, Map<String, dynamic> parameters)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimulateRequestDto() when $default != null:
        return $default(_that.type, _that.parameters);
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
    TResult Function(String type, Map<String, dynamic> parameters) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimulateRequestDto():
        return $default(_that.type, _that.parameters);
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
    TResult? Function(String type, Map<String, dynamic> parameters)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimulateRequestDto() when $default != null:
        return $default(_that.type, _that.parameters);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SimulateRequestDto implements SimulateRequestDto {
  const _SimulateRequestDto(
      {required this.type, required final Map<String, dynamic> parameters})
      : _parameters = parameters;
  factory _SimulateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SimulateRequestDtoFromJson(json);

  @override
  final String type;
  final Map<String, dynamic> _parameters;
  @override
  Map<String, dynamic> get parameters {
    if (_parameters is EqualUnmodifiableMapView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_parameters);
  }

  /// Create a copy of SimulateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SimulateRequestDtoCopyWith<_SimulateRequestDto> get copyWith =>
      __$SimulateRequestDtoCopyWithImpl<_SimulateRequestDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SimulateRequestDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SimulateRequestDto &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, const DeepCollectionEquality().hash(_parameters));

  @override
  String toString() {
    return 'SimulateRequestDto(type: $type, parameters: $parameters)';
  }
}

/// @nodoc
abstract mixin class _$SimulateRequestDtoCopyWith<$Res>
    implements $SimulateRequestDtoCopyWith<$Res> {
  factory _$SimulateRequestDtoCopyWith(
          _SimulateRequestDto value, $Res Function(_SimulateRequestDto) _then) =
      __$SimulateRequestDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String type, Map<String, dynamic> parameters});
}

/// @nodoc
class __$SimulateRequestDtoCopyWithImpl<$Res>
    implements _$SimulateRequestDtoCopyWith<$Res> {
  __$SimulateRequestDtoCopyWithImpl(this._self, this._then);

  final _SimulateRequestDto _self;
  final $Res Function(_SimulateRequestDto) _then;

  /// Create a copy of SimulateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? parameters = null,
  }) {
    return _then(_SimulateRequestDto(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      parameters: null == parameters
          ? _self._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

// dart format on
