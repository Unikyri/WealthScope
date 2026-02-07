// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'portfolio_risk_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PortfolioRiskDto {
  @JsonKey(name: 'risk_score')
  int get riskScore;
  @JsonKey(name: 'diversification_level')
  String get diversificationLevel;
  List<RiskAlertDto> get alerts;

  /// Create a copy of PortfolioRiskDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PortfolioRiskDtoCopyWith<PortfolioRiskDto> get copyWith =>
      _$PortfolioRiskDtoCopyWithImpl<PortfolioRiskDto>(
          this as PortfolioRiskDto, _$identity);

  /// Serializes this PortfolioRiskDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PortfolioRiskDto &&
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
    return 'PortfolioRiskDto(riskScore: $riskScore, diversificationLevel: $diversificationLevel, alerts: $alerts)';
  }
}

/// @nodoc
abstract mixin class $PortfolioRiskDtoCopyWith<$Res> {
  factory $PortfolioRiskDtoCopyWith(
          PortfolioRiskDto value, $Res Function(PortfolioRiskDto) _then) =
      _$PortfolioRiskDtoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'risk_score') int riskScore,
      @JsonKey(name: 'diversification_level') String diversificationLevel,
      List<RiskAlertDto> alerts});
}

/// @nodoc
class _$PortfolioRiskDtoCopyWithImpl<$Res>
    implements $PortfolioRiskDtoCopyWith<$Res> {
  _$PortfolioRiskDtoCopyWithImpl(this._self, this._then);

  final PortfolioRiskDto _self;
  final $Res Function(PortfolioRiskDto) _then;

  /// Create a copy of PortfolioRiskDto
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

/// Adds pattern-matching-related methods to [PortfolioRiskDto].
extension PortfolioRiskDtoPatterns on PortfolioRiskDto {
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
    TResult Function(_PortfolioRiskDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PortfolioRiskDto() when $default != null:
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
    TResult Function(_PortfolioRiskDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioRiskDto():
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
    TResult? Function(_PortfolioRiskDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioRiskDto() when $default != null:
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
      case _PortfolioRiskDto() when $default != null:
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
      case _PortfolioRiskDto():
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
      case _PortfolioRiskDto() when $default != null:
        return $default(
            _that.riskScore, _that.diversificationLevel, _that.alerts);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PortfolioRiskDto extends PortfolioRiskDto {
  const _PortfolioRiskDto(
      {@JsonKey(name: 'risk_score') required this.riskScore,
      @JsonKey(name: 'diversification_level')
      required this.diversificationLevel,
      final List<RiskAlertDto> alerts = const []})
      : _alerts = alerts,
        super._();
  factory _PortfolioRiskDto.fromJson(Map<String, dynamic> json) =>
      _$PortfolioRiskDtoFromJson(json);

  @override
  @JsonKey(name: 'risk_score')
  final int riskScore;
  @override
  @JsonKey(name: 'diversification_level')
  final String diversificationLevel;
  final List<RiskAlertDto> _alerts;
  @override
  @JsonKey()
  List<RiskAlertDto> get alerts {
    if (_alerts is EqualUnmodifiableListView) return _alerts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alerts);
  }

  /// Create a copy of PortfolioRiskDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PortfolioRiskDtoCopyWith<_PortfolioRiskDto> get copyWith =>
      __$PortfolioRiskDtoCopyWithImpl<_PortfolioRiskDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PortfolioRiskDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PortfolioRiskDto &&
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
    return 'PortfolioRiskDto(riskScore: $riskScore, diversificationLevel: $diversificationLevel, alerts: $alerts)';
  }
}

/// @nodoc
abstract mixin class _$PortfolioRiskDtoCopyWith<$Res>
    implements $PortfolioRiskDtoCopyWith<$Res> {
  factory _$PortfolioRiskDtoCopyWith(
          _PortfolioRiskDto value, $Res Function(_PortfolioRiskDto) _then) =
      __$PortfolioRiskDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'risk_score') int riskScore,
      @JsonKey(name: 'diversification_level') String diversificationLevel,
      List<RiskAlertDto> alerts});
}

/// @nodoc
class __$PortfolioRiskDtoCopyWithImpl<$Res>
    implements _$PortfolioRiskDtoCopyWith<$Res> {
  __$PortfolioRiskDtoCopyWithImpl(this._self, this._then);

  final _PortfolioRiskDto _self;
  final $Res Function(_PortfolioRiskDto) _then;

  /// Create a copy of PortfolioRiskDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? riskScore = null,
    Object? diversificationLevel = null,
    Object? alerts = null,
  }) {
    return _then(_PortfolioRiskDto(
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
class _RiskAlertDto extends RiskAlertDto {
  const _RiskAlertDto(
      {required this.type,
      required this.title,
      required this.message,
      required this.severity,
      required this.value,
      required this.threshold})
      : super._();
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
