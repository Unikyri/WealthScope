// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'portfolio_risk_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PortfolioRiskDto _$PortfolioRiskDtoFromJson(Map<String, dynamic> json) {
  return _PortfolioRiskDto.fromJson(json);
}

/// @nodoc
mixin _$PortfolioRiskDto {
  @JsonKey(name: 'risk_score')
  int get riskScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'diversification_level')
  String get diversificationLevel => throw _privateConstructorUsedError;
  List<RiskAlertDto> get alerts => throw _privateConstructorUsedError;

  /// Serializes this PortfolioRiskDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PortfolioRiskDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PortfolioRiskDtoCopyWith<PortfolioRiskDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PortfolioRiskDtoCopyWith<$Res> {
  factory $PortfolioRiskDtoCopyWith(
          PortfolioRiskDto value, $Res Function(PortfolioRiskDto) then) =
      _$PortfolioRiskDtoCopyWithImpl<$Res, PortfolioRiskDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'risk_score') int riskScore,
      @JsonKey(name: 'diversification_level') String diversificationLevel,
      List<RiskAlertDto> alerts});
}

/// @nodoc
class _$PortfolioRiskDtoCopyWithImpl<$Res, $Val extends PortfolioRiskDto>
    implements $PortfolioRiskDtoCopyWith<$Res> {
  _$PortfolioRiskDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PortfolioRiskDto
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
              as List<RiskAlertDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PortfolioRiskDtoImplCopyWith<$Res>
    implements $PortfolioRiskDtoCopyWith<$Res> {
  factory _$$PortfolioRiskDtoImplCopyWith(_$PortfolioRiskDtoImpl value,
          $Res Function(_$PortfolioRiskDtoImpl) then) =
      __$$PortfolioRiskDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'risk_score') int riskScore,
      @JsonKey(name: 'diversification_level') String diversificationLevel,
      List<RiskAlertDto> alerts});
}

/// @nodoc
class __$$PortfolioRiskDtoImplCopyWithImpl<$Res>
    extends _$PortfolioRiskDtoCopyWithImpl<$Res, _$PortfolioRiskDtoImpl>
    implements _$$PortfolioRiskDtoImplCopyWith<$Res> {
  __$$PortfolioRiskDtoImplCopyWithImpl(_$PortfolioRiskDtoImpl _value,
      $Res Function(_$PortfolioRiskDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PortfolioRiskDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? riskScore = null,
    Object? diversificationLevel = null,
    Object? alerts = null,
  }) {
    return _then(_$PortfolioRiskDtoImpl(
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
              as List<RiskAlertDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PortfolioRiskDtoImpl extends _PortfolioRiskDto {
  const _$PortfolioRiskDtoImpl(
      {@JsonKey(name: 'risk_score') required this.riskScore,
      @JsonKey(name: 'diversification_level')
      required this.diversificationLevel,
      final List<RiskAlertDto> alerts = const []})
      : _alerts = alerts,
        super._();

  factory _$PortfolioRiskDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PortfolioRiskDtoImplFromJson(json);

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

  @override
  String toString() {
    return 'PortfolioRiskDto(riskScore: $riskScore, diversificationLevel: $diversificationLevel, alerts: $alerts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PortfolioRiskDtoImpl &&
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

  /// Create a copy of PortfolioRiskDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PortfolioRiskDtoImplCopyWith<_$PortfolioRiskDtoImpl> get copyWith =>
      __$$PortfolioRiskDtoImplCopyWithImpl<_$PortfolioRiskDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PortfolioRiskDtoImplToJson(
      this,
    );
  }
}

abstract class _PortfolioRiskDto extends PortfolioRiskDto {
  const factory _PortfolioRiskDto(
      {@JsonKey(name: 'risk_score') required final int riskScore,
      @JsonKey(name: 'diversification_level')
      required final String diversificationLevel,
      final List<RiskAlertDto> alerts}) = _$PortfolioRiskDtoImpl;
  const _PortfolioRiskDto._() : super._();

  factory _PortfolioRiskDto.fromJson(Map<String, dynamic> json) =
      _$PortfolioRiskDtoImpl.fromJson;

  @override
  @JsonKey(name: 'risk_score')
  int get riskScore;
  @override
  @JsonKey(name: 'diversification_level')
  String get diversificationLevel;
  @override
  List<RiskAlertDto> get alerts;

  /// Create a copy of PortfolioRiskDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PortfolioRiskDtoImplCopyWith<_$PortfolioRiskDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RiskAlertDto _$RiskAlertDtoFromJson(Map<String, dynamic> json) {
  return _RiskAlertDto.fromJson(json);
}

/// @nodoc
mixin _$RiskAlertDto {
  String get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get severity => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  double get threshold => throw _privateConstructorUsedError;

  /// Serializes this RiskAlertDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RiskAlertDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RiskAlertDtoCopyWith<RiskAlertDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RiskAlertDtoCopyWith<$Res> {
  factory $RiskAlertDtoCopyWith(
          RiskAlertDto value, $Res Function(RiskAlertDto) then) =
      _$RiskAlertDtoCopyWithImpl<$Res, RiskAlertDto>;
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
class _$RiskAlertDtoCopyWithImpl<$Res, $Val extends RiskAlertDto>
    implements $RiskAlertDtoCopyWith<$Res> {
  _$RiskAlertDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      threshold: null == threshold
          ? _value.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RiskAlertDtoImplCopyWith<$Res>
    implements $RiskAlertDtoCopyWith<$Res> {
  factory _$$RiskAlertDtoImplCopyWith(
          _$RiskAlertDtoImpl value, $Res Function(_$RiskAlertDtoImpl) then) =
      __$$RiskAlertDtoImplCopyWithImpl<$Res>;
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
class __$$RiskAlertDtoImplCopyWithImpl<$Res>
    extends _$RiskAlertDtoCopyWithImpl<$Res, _$RiskAlertDtoImpl>
    implements _$$RiskAlertDtoImplCopyWith<$Res> {
  __$$RiskAlertDtoImplCopyWithImpl(
      _$RiskAlertDtoImpl _value, $Res Function(_$RiskAlertDtoImpl) _then)
      : super(_value, _then);

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
    return _then(_$RiskAlertDtoImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      threshold: null == threshold
          ? _value.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RiskAlertDtoImpl extends _RiskAlertDto {
  const _$RiskAlertDtoImpl(
      {required this.type,
      required this.title,
      required this.message,
      required this.severity,
      required this.value,
      required this.threshold})
      : super._();

  factory _$RiskAlertDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RiskAlertDtoImplFromJson(json);

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

  @override
  String toString() {
    return 'RiskAlertDto(type: $type, title: $title, message: $message, severity: $severity, value: $value, threshold: $threshold)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RiskAlertDtoImpl &&
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

  /// Create a copy of RiskAlertDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RiskAlertDtoImplCopyWith<_$RiskAlertDtoImpl> get copyWith =>
      __$$RiskAlertDtoImplCopyWithImpl<_$RiskAlertDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RiskAlertDtoImplToJson(
      this,
    );
  }
}

abstract class _RiskAlertDto extends RiskAlertDto {
  const factory _RiskAlertDto(
      {required final String type,
      required final String title,
      required final String message,
      required final String severity,
      required final double value,
      required final double threshold}) = _$RiskAlertDtoImpl;
  const _RiskAlertDto._() : super._();

  factory _RiskAlertDto.fromJson(Map<String, dynamic> json) =
      _$RiskAlertDtoImpl.fromJson;

  @override
  String get type;
  @override
  String get title;
  @override
  String get message;
  @override
  String get severity;
  @override
  double get value;
  @override
  double get threshold;

  /// Create a copy of RiskAlertDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RiskAlertDtoImplCopyWith<_$RiskAlertDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
