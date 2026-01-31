// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'portfolio_risk.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PortfolioRisk {
  int get riskScore => throw _privateConstructorUsedError;
  String get diversificationLevel => throw _privateConstructorUsedError;
  List<RiskAlert> get alerts => throw _privateConstructorUsedError;

  /// Create a copy of PortfolioRisk
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PortfolioRiskCopyWith<PortfolioRisk> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PortfolioRiskCopyWith<$Res> {
  factory $PortfolioRiskCopyWith(
          PortfolioRisk value, $Res Function(PortfolioRisk) then) =
      _$PortfolioRiskCopyWithImpl<$Res, PortfolioRisk>;
  @useResult
  $Res call(
      {int riskScore, String diversificationLevel, List<RiskAlert> alerts});
}

/// @nodoc
class _$PortfolioRiskCopyWithImpl<$Res, $Val extends PortfolioRisk>
    implements $PortfolioRiskCopyWith<$Res> {
  _$PortfolioRiskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PortfolioRisk
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? riskScore = null,
    Object? diversificationLevel = null,
    Object? alerts = null,
  }) {
    return _then(_value.copyWith(
      riskScore: null == riskScore
          ? _value.riskScore
          : riskScore // ignore: cast_nullable_to_non_nullable
              as int,
      diversificationLevel: null == diversificationLevel
          ? _value.diversificationLevel
          : diversificationLevel // ignore: cast_nullable_to_non_nullable
              as String,
      alerts: null == alerts
          ? _value.alerts
          : alerts // ignore: cast_nullable_to_non_nullable
              as List<RiskAlert>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PortfolioRiskImplCopyWith<$Res>
    implements $PortfolioRiskCopyWith<$Res> {
  factory _$$PortfolioRiskImplCopyWith(
          _$PortfolioRiskImpl value, $Res Function(_$PortfolioRiskImpl) then) =
      __$$PortfolioRiskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int riskScore, String diversificationLevel, List<RiskAlert> alerts});
}

/// @nodoc
class __$$PortfolioRiskImplCopyWithImpl<$Res>
    extends _$PortfolioRiskCopyWithImpl<$Res, _$PortfolioRiskImpl>
    implements _$$PortfolioRiskImplCopyWith<$Res> {
  __$$PortfolioRiskImplCopyWithImpl(
      _$PortfolioRiskImpl _value, $Res Function(_$PortfolioRiskImpl) _then)
      : super(_value, _then);

  /// Create a copy of PortfolioRisk
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? riskScore = null,
    Object? diversificationLevel = null,
    Object? alerts = null,
  }) {
    return _then(_$PortfolioRiskImpl(
      riskScore: null == riskScore
          ? _value.riskScore
          : riskScore // ignore: cast_nullable_to_non_nullable
              as int,
      diversificationLevel: null == diversificationLevel
          ? _value.diversificationLevel
          : diversificationLevel // ignore: cast_nullable_to_non_nullable
              as String,
      alerts: null == alerts
          ? _value._alerts
          : alerts // ignore: cast_nullable_to_non_nullable
              as List<RiskAlert>,
    ));
  }
}

/// @nodoc

class _$PortfolioRiskImpl implements _PortfolioRisk {
  const _$PortfolioRiskImpl(
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

  @override
  String toString() {
    return 'PortfolioRisk(riskScore: $riskScore, diversificationLevel: $diversificationLevel, alerts: $alerts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PortfolioRiskImpl &&
            (identical(other.riskScore, riskScore) ||
                other.riskScore == riskScore) &&
            (identical(other.diversificationLevel, diversificationLevel) ||
                other.diversificationLevel == diversificationLevel) &&
            const DeepCollectionEquality().equals(other._alerts, _alerts));
  }

  @override
  int get hashCode => Object.hash(runtimeType, riskScore, diversificationLevel,
      const DeepCollectionEquality().hash(_alerts));

  /// Create a copy of PortfolioRisk
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PortfolioRiskImplCopyWith<_$PortfolioRiskImpl> get copyWith =>
      __$$PortfolioRiskImplCopyWithImpl<_$PortfolioRiskImpl>(this, _$identity);
}

abstract class _PortfolioRisk implements PortfolioRisk {
  const factory _PortfolioRisk(
      {required final int riskScore,
      required final String diversificationLevel,
      final List<RiskAlert> alerts}) = _$PortfolioRiskImpl;

  @override
  int get riskScore;
  @override
  String get diversificationLevel;
  @override
  List<RiskAlert> get alerts;

  /// Create a copy of PortfolioRisk
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PortfolioRiskImplCopyWith<_$PortfolioRiskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
