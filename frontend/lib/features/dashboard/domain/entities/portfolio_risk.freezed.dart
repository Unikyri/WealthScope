// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'portfolio_risk.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PortfolioRisk {
  int get riskScore;
  String get diversificationLevel;
  List<RiskAlert> get alerts;

  /// Create a copy of PortfolioRisk
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PortfolioRiskCopyWith<PortfolioRisk> get copyWith =>
      _$PortfolioRiskCopyWithImpl<PortfolioRisk>(
          this as PortfolioRisk, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PortfolioRisk &&
            (identical(other.riskScore, riskScore) ||
                other.riskScore == riskScore) &&
            (identical(other.diversificationLevel, diversificationLevel) ||
                other.diversificationLevel == diversificationLevel) &&
            const DeepCollectionEquality().equals(other.alerts, alerts));
  }

  @override
  int get hashCode => Object.hash(runtimeType, riskScore, diversificationLevel,
      const DeepCollectionEquality().hash(alerts));

  @override
  String toString() {
    return 'PortfolioRisk(riskScore: $riskScore, diversificationLevel: $diversificationLevel, alerts: $alerts)';
  }
}

/// @nodoc
abstract mixin class $PortfolioRiskCopyWith<$Res> {
  factory $PortfolioRiskCopyWith(
          PortfolioRisk value, $Res Function(PortfolioRisk) _then) =
      _$PortfolioRiskCopyWithImpl;
  @useResult
  $Res call(
      {int riskScore, String diversificationLevel, List<RiskAlert> alerts});
}

/// @nodoc
class _$PortfolioRiskCopyWithImpl<$Res>
    implements $PortfolioRiskCopyWith<$Res> {
  _$PortfolioRiskCopyWithImpl(this._self, this._then);

  final PortfolioRisk _self;
  final $Res Function(PortfolioRisk) _then;

  /// Create a copy of PortfolioRisk
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
              as List<RiskAlert>,
    ));
  }
}

/// Adds pattern-matching-related methods to [PortfolioRisk].
extension PortfolioRiskPatterns on PortfolioRisk {
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
    TResult Function(_PortfolioRisk value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PortfolioRisk() when $default != null:
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
    TResult Function(_PortfolioRisk value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioRisk():
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
    TResult? Function(_PortfolioRisk value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioRisk() when $default != null:
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
            int riskScore, String diversificationLevel, List<RiskAlert> alerts)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PortfolioRisk() when $default != null:
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
            int riskScore, String diversificationLevel, List<RiskAlert> alerts)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioRisk():
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
            int riskScore, String diversificationLevel, List<RiskAlert> alerts)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioRisk() when $default != null:
        return $default(
            _that.riskScore, _that.diversificationLevel, _that.alerts);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PortfolioRisk implements PortfolioRisk {
  const _PortfolioRisk(
      {required this.riskScore,
      required this.diversificationLevel,
      final List<RiskAlert> alerts = const []})
      : _alerts = alerts;

  @override
  final int riskScore;
  @override
  final String diversificationLevel;
  final List<RiskAlert> _alerts;
  @override
  @JsonKey()
  List<RiskAlert> get alerts {
    if (_alerts is EqualUnmodifiableListView) return _alerts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alerts);
  }

  /// Create a copy of PortfolioRisk
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PortfolioRiskCopyWith<_PortfolioRisk> get copyWith =>
      __$PortfolioRiskCopyWithImpl<_PortfolioRisk>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PortfolioRisk &&
            (identical(other.riskScore, riskScore) ||
                other.riskScore == riskScore) &&
            (identical(other.diversificationLevel, diversificationLevel) ||
                other.diversificationLevel == diversificationLevel) &&
            const DeepCollectionEquality().equals(other._alerts, _alerts));
  }

  @override
  int get hashCode => Object.hash(runtimeType, riskScore, diversificationLevel,
      const DeepCollectionEquality().hash(_alerts));

  @override
  String toString() {
    return 'PortfolioRisk(riskScore: $riskScore, diversificationLevel: $diversificationLevel, alerts: $alerts)';
  }
}

/// @nodoc
abstract mixin class _$PortfolioRiskCopyWith<$Res>
    implements $PortfolioRiskCopyWith<$Res> {
  factory _$PortfolioRiskCopyWith(
          _PortfolioRisk value, $Res Function(_PortfolioRisk) _then) =
      __$PortfolioRiskCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int riskScore, String diversificationLevel, List<RiskAlert> alerts});
}

/// @nodoc
class __$PortfolioRiskCopyWithImpl<$Res>
    implements _$PortfolioRiskCopyWith<$Res> {
  __$PortfolioRiskCopyWithImpl(this._self, this._then);

  final _PortfolioRisk _self;
  final $Res Function(_PortfolioRisk) _then;

  /// Create a copy of PortfolioRisk
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? riskScore = null,
    Object? diversificationLevel = null,
    Object? alerts = null,
  }) {
    return _then(_PortfolioRisk(
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
              as List<RiskAlert>,
    ));
  }
}

// dart format on
