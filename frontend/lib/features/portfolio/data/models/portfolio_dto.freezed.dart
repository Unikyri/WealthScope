// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'portfolio_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PortfolioSummaryDto _$PortfolioSummaryDtoFromJson(Map<String, dynamic> json) {
  return _PortfolioSummaryDto.fromJson(json);
}

/// @nodoc
mixin _$PortfolioSummaryDto {
  @JsonKey(name: 'total_value')
  double get totalValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_invested')
  double get totalInvested => throw _privateConstructorUsedError;
  @JsonKey(name: 'gain_loss')
  double get gainLoss => throw _privateConstructorUsedError;
  @JsonKey(name: 'gain_loss_percent')
  double get gainLossPercent => throw _privateConstructorUsedError;
  @JsonKey(name: 'asset_count')
  int get assetCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'breakdown_by_type')
  List<AssetTypeBreakdownDto> get breakdownByType =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'last_updated')
  String get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this PortfolioSummaryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PortfolioSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PortfolioSummaryDtoCopyWith<PortfolioSummaryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PortfolioSummaryDtoCopyWith<$Res> {
  factory $PortfolioSummaryDtoCopyWith(
          PortfolioSummaryDto value, $Res Function(PortfolioSummaryDto) then) =
      _$PortfolioSummaryDtoCopyWithImpl<$Res, PortfolioSummaryDto>;
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
class _$PortfolioSummaryDtoCopyWithImpl<$Res, $Val extends PortfolioSummaryDto>
    implements $PortfolioSummaryDtoCopyWith<$Res> {
  _$PortfolioSummaryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      totalValue: null == totalValue
          ? _value.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double,
      totalInvested: null == totalInvested
          ? _value.totalInvested
          : totalInvested // ignore: cast_nullable_to_non_nullable
              as double,
      gainLoss: null == gainLoss
          ? _value.gainLoss
          : gainLoss // ignore: cast_nullable_to_non_nullable
              as double,
      gainLossPercent: null == gainLossPercent
          ? _value.gainLossPercent
          : gainLossPercent // ignore: cast_nullable_to_non_nullable
              as double,
      assetCount: null == assetCount
          ? _value.assetCount
          : assetCount // ignore: cast_nullable_to_non_nullable
              as int,
      breakdownByType: null == breakdownByType
          ? _value.breakdownByType
          : breakdownByType // ignore: cast_nullable_to_non_nullable
              as List<AssetTypeBreakdownDto>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PortfolioSummaryDtoImplCopyWith<$Res>
    implements $PortfolioSummaryDtoCopyWith<$Res> {
  factory _$$PortfolioSummaryDtoImplCopyWith(_$PortfolioSummaryDtoImpl value,
          $Res Function(_$PortfolioSummaryDtoImpl) then) =
      __$$PortfolioSummaryDtoImplCopyWithImpl<$Res>;
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
class __$$PortfolioSummaryDtoImplCopyWithImpl<$Res>
    extends _$PortfolioSummaryDtoCopyWithImpl<$Res, _$PortfolioSummaryDtoImpl>
    implements _$$PortfolioSummaryDtoImplCopyWith<$Res> {
  __$$PortfolioSummaryDtoImplCopyWithImpl(_$PortfolioSummaryDtoImpl _value,
      $Res Function(_$PortfolioSummaryDtoImpl) _then)
      : super(_value, _then);

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
    return _then(_$PortfolioSummaryDtoImpl(
      totalValue: null == totalValue
          ? _value.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double,
      totalInvested: null == totalInvested
          ? _value.totalInvested
          : totalInvested // ignore: cast_nullable_to_non_nullable
              as double,
      gainLoss: null == gainLoss
          ? _value.gainLoss
          : gainLoss // ignore: cast_nullable_to_non_nullable
              as double,
      gainLossPercent: null == gainLossPercent
          ? _value.gainLossPercent
          : gainLossPercent // ignore: cast_nullable_to_non_nullable
              as double,
      assetCount: null == assetCount
          ? _value.assetCount
          : assetCount // ignore: cast_nullable_to_non_nullable
              as int,
      breakdownByType: null == breakdownByType
          ? _value._breakdownByType
          : breakdownByType // ignore: cast_nullable_to_non_nullable
              as List<AssetTypeBreakdownDto>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PortfolioSummaryDtoImpl implements _PortfolioSummaryDto {
  const _$PortfolioSummaryDtoImpl(
      {@JsonKey(name: 'total_value') required this.totalValue,
      @JsonKey(name: 'total_invested') required this.totalInvested,
      @JsonKey(name: 'gain_loss') required this.gainLoss,
      @JsonKey(name: 'gain_loss_percent') required this.gainLossPercent,
      @JsonKey(name: 'asset_count') required this.assetCount,
      @JsonKey(name: 'breakdown_by_type')
      required final List<AssetTypeBreakdownDto> breakdownByType,
      @JsonKey(name: 'last_updated') required this.lastUpdated})
      : _breakdownByType = breakdownByType;

  factory _$PortfolioSummaryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PortfolioSummaryDtoImplFromJson(json);

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

  @override
  String toString() {
    return 'PortfolioSummaryDto(totalValue: $totalValue, totalInvested: $totalInvested, gainLoss: $gainLoss, gainLossPercent: $gainLossPercent, assetCount: $assetCount, breakdownByType: $breakdownByType, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PortfolioSummaryDtoImpl &&
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

  /// Create a copy of PortfolioSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PortfolioSummaryDtoImplCopyWith<_$PortfolioSummaryDtoImpl> get copyWith =>
      __$$PortfolioSummaryDtoImplCopyWithImpl<_$PortfolioSummaryDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PortfolioSummaryDtoImplToJson(
      this,
    );
  }
}

abstract class _PortfolioSummaryDto implements PortfolioSummaryDto {
  const factory _PortfolioSummaryDto(
      {@JsonKey(name: 'total_value') required final double totalValue,
      @JsonKey(name: 'total_invested') required final double totalInvested,
      @JsonKey(name: 'gain_loss') required final double gainLoss,
      @JsonKey(name: 'gain_loss_percent') required final double gainLossPercent,
      @JsonKey(name: 'asset_count') required final int assetCount,
      @JsonKey(name: 'breakdown_by_type')
      required final List<AssetTypeBreakdownDto> breakdownByType,
      @JsonKey(name: 'last_updated')
      required final String lastUpdated}) = _$PortfolioSummaryDtoImpl;

  factory _PortfolioSummaryDto.fromJson(Map<String, dynamic> json) =
      _$PortfolioSummaryDtoImpl.fromJson;

  @override
  @JsonKey(name: 'total_value')
  double get totalValue;
  @override
  @JsonKey(name: 'total_invested')
  double get totalInvested;
  @override
  @JsonKey(name: 'gain_loss')
  double get gainLoss;
  @override
  @JsonKey(name: 'gain_loss_percent')
  double get gainLossPercent;
  @override
  @JsonKey(name: 'asset_count')
  int get assetCount;
  @override
  @JsonKey(name: 'breakdown_by_type')
  List<AssetTypeBreakdownDto> get breakdownByType;
  @override
  @JsonKey(name: 'last_updated')
  String get lastUpdated;

  /// Create a copy of PortfolioSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PortfolioSummaryDtoImplCopyWith<_$PortfolioSummaryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AssetTypeBreakdownDto _$AssetTypeBreakdownDtoFromJson(
    Map<String, dynamic> json) {
  return _AssetTypeBreakdownDto.fromJson(json);
}

/// @nodoc
mixin _$AssetTypeBreakdownDto {
  String get type => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  double get percent => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this AssetTypeBreakdownDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AssetTypeBreakdownDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssetTypeBreakdownDtoCopyWith<AssetTypeBreakdownDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetTypeBreakdownDtoCopyWith<$Res> {
  factory $AssetTypeBreakdownDtoCopyWith(AssetTypeBreakdownDto value,
          $Res Function(AssetTypeBreakdownDto) then) =
      _$AssetTypeBreakdownDtoCopyWithImpl<$Res, AssetTypeBreakdownDto>;
  @useResult
  $Res call({String type, double value, double percent, int count});
}

/// @nodoc
class _$AssetTypeBreakdownDtoCopyWithImpl<$Res,
        $Val extends AssetTypeBreakdownDto>
    implements $AssetTypeBreakdownDtoCopyWith<$Res> {
  _$AssetTypeBreakdownDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      percent: null == percent
          ? _value.percent
          : percent // ignore: cast_nullable_to_non_nullable
              as double,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssetTypeBreakdownDtoImplCopyWith<$Res>
    implements $AssetTypeBreakdownDtoCopyWith<$Res> {
  factory _$$AssetTypeBreakdownDtoImplCopyWith(
          _$AssetTypeBreakdownDtoImpl value,
          $Res Function(_$AssetTypeBreakdownDtoImpl) then) =
      __$$AssetTypeBreakdownDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, double value, double percent, int count});
}

/// @nodoc
class __$$AssetTypeBreakdownDtoImplCopyWithImpl<$Res>
    extends _$AssetTypeBreakdownDtoCopyWithImpl<$Res,
        _$AssetTypeBreakdownDtoImpl>
    implements _$$AssetTypeBreakdownDtoImplCopyWith<$Res> {
  __$$AssetTypeBreakdownDtoImplCopyWithImpl(_$AssetTypeBreakdownDtoImpl _value,
      $Res Function(_$AssetTypeBreakdownDtoImpl) _then)
      : super(_value, _then);

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
    return _then(_$AssetTypeBreakdownDtoImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      percent: null == percent
          ? _value.percent
          : percent // ignore: cast_nullable_to_non_nullable
              as double,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssetTypeBreakdownDtoImpl implements _AssetTypeBreakdownDto {
  const _$AssetTypeBreakdownDtoImpl(
      {required this.type,
      required this.value,
      required this.percent,
      required this.count});

  factory _$AssetTypeBreakdownDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssetTypeBreakdownDtoImplFromJson(json);

  @override
  final String type;
  @override
  final double value;
  @override
  final double percent;
  @override
  final int count;

  @override
  String toString() {
    return 'AssetTypeBreakdownDto(type: $type, value: $value, percent: $percent, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetTypeBreakdownDtoImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.percent, percent) || other.percent == percent) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, value, percent, count);

  /// Create a copy of AssetTypeBreakdownDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetTypeBreakdownDtoImplCopyWith<_$AssetTypeBreakdownDtoImpl>
      get copyWith => __$$AssetTypeBreakdownDtoImplCopyWithImpl<
          _$AssetTypeBreakdownDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssetTypeBreakdownDtoImplToJson(
      this,
    );
  }
}

abstract class _AssetTypeBreakdownDto implements AssetTypeBreakdownDto {
  const factory _AssetTypeBreakdownDto(
      {required final String type,
      required final double value,
      required final double percent,
      required final int count}) = _$AssetTypeBreakdownDtoImpl;

  factory _AssetTypeBreakdownDto.fromJson(Map<String, dynamic> json) =
      _$AssetTypeBreakdownDtoImpl.fromJson;

  @override
  String get type;
  @override
  double get value;
  @override
  double get percent;
  @override
  int get count;

  /// Create a copy of AssetTypeBreakdownDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssetTypeBreakdownDtoImplCopyWith<_$AssetTypeBreakdownDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PortfolioRiskAnalysisDto _$PortfolioRiskAnalysisDtoFromJson(
    Map<String, dynamic> json) {
  return _PortfolioRiskAnalysisDto.fromJson(json);
}

/// @nodoc
mixin _$PortfolioRiskAnalysisDto {
  @JsonKey(name: 'risk_score')
  int get riskScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'diversification_level')
  String get diversificationLevel => throw _privateConstructorUsedError;
  List<RiskAlertDto> get alerts => throw _privateConstructorUsedError;

  /// Serializes this PortfolioRiskAnalysisDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PortfolioRiskAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PortfolioRiskAnalysisDtoCopyWith<PortfolioRiskAnalysisDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PortfolioRiskAnalysisDtoCopyWith<$Res> {
  factory $PortfolioRiskAnalysisDtoCopyWith(PortfolioRiskAnalysisDto value,
          $Res Function(PortfolioRiskAnalysisDto) then) =
      _$PortfolioRiskAnalysisDtoCopyWithImpl<$Res, PortfolioRiskAnalysisDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'risk_score') int riskScore,
      @JsonKey(name: 'diversification_level') String diversificationLevel,
      List<RiskAlertDto> alerts});
}

/// @nodoc
class _$PortfolioRiskAnalysisDtoCopyWithImpl<$Res,
        $Val extends PortfolioRiskAnalysisDto>
    implements $PortfolioRiskAnalysisDtoCopyWith<$Res> {
  _$PortfolioRiskAnalysisDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PortfolioRiskAnalysisDto
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
abstract class _$$PortfolioRiskAnalysisDtoImplCopyWith<$Res>
    implements $PortfolioRiskAnalysisDtoCopyWith<$Res> {
  factory _$$PortfolioRiskAnalysisDtoImplCopyWith(
          _$PortfolioRiskAnalysisDtoImpl value,
          $Res Function(_$PortfolioRiskAnalysisDtoImpl) then) =
      __$$PortfolioRiskAnalysisDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'risk_score') int riskScore,
      @JsonKey(name: 'diversification_level') String diversificationLevel,
      List<RiskAlertDto> alerts});
}

/// @nodoc
class __$$PortfolioRiskAnalysisDtoImplCopyWithImpl<$Res>
    extends _$PortfolioRiskAnalysisDtoCopyWithImpl<$Res,
        _$PortfolioRiskAnalysisDtoImpl>
    implements _$$PortfolioRiskAnalysisDtoImplCopyWith<$Res> {
  __$$PortfolioRiskAnalysisDtoImplCopyWithImpl(
      _$PortfolioRiskAnalysisDtoImpl _value,
      $Res Function(_$PortfolioRiskAnalysisDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PortfolioRiskAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? riskScore = null,
    Object? diversificationLevel = null,
    Object? alerts = null,
  }) {
    return _then(_$PortfolioRiskAnalysisDtoImpl(
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
class _$PortfolioRiskAnalysisDtoImpl implements _PortfolioRiskAnalysisDto {
  const _$PortfolioRiskAnalysisDtoImpl(
      {@JsonKey(name: 'risk_score') required this.riskScore,
      @JsonKey(name: 'diversification_level')
      required this.diversificationLevel,
      required final List<RiskAlertDto> alerts})
      : _alerts = alerts;

  factory _$PortfolioRiskAnalysisDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PortfolioRiskAnalysisDtoImplFromJson(json);

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

  @override
  String toString() {
    return 'PortfolioRiskAnalysisDto(riskScore: $riskScore, diversificationLevel: $diversificationLevel, alerts: $alerts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PortfolioRiskAnalysisDtoImpl &&
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

  /// Create a copy of PortfolioRiskAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PortfolioRiskAnalysisDtoImplCopyWith<_$PortfolioRiskAnalysisDtoImpl>
      get copyWith => __$$PortfolioRiskAnalysisDtoImplCopyWithImpl<
          _$PortfolioRiskAnalysisDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PortfolioRiskAnalysisDtoImplToJson(
      this,
    );
  }
}

abstract class _PortfolioRiskAnalysisDto implements PortfolioRiskAnalysisDto {
  const factory _PortfolioRiskAnalysisDto(
          {@JsonKey(name: 'risk_score') required final int riskScore,
          @JsonKey(name: 'diversification_level')
          required final String diversificationLevel,
          required final List<RiskAlertDto> alerts}) =
      _$PortfolioRiskAnalysisDtoImpl;

  factory _PortfolioRiskAnalysisDto.fromJson(Map<String, dynamic> json) =
      _$PortfolioRiskAnalysisDtoImpl.fromJson;

  @override
  @JsonKey(name: 'risk_score')
  int get riskScore;
  @override
  @JsonKey(name: 'diversification_level')
  String get diversificationLevel;
  @override
  List<RiskAlertDto> get alerts;

  /// Create a copy of PortfolioRiskAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PortfolioRiskAnalysisDtoImplCopyWith<_$PortfolioRiskAnalysisDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
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
class _$RiskAlertDtoImpl implements _RiskAlertDto {
  const _$RiskAlertDtoImpl(
      {required this.type,
      required this.title,
      required this.message,
      required this.severity,
      required this.value,
      required this.threshold});

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

abstract class _RiskAlertDto implements RiskAlertDto {
  const factory _RiskAlertDto(
      {required final String type,
      required final String title,
      required final String message,
      required final String severity,
      required final double value,
      required final double threshold}) = _$RiskAlertDtoImpl;

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
