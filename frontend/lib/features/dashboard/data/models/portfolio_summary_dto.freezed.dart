// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'portfolio_summary_dto.dart';

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
  @JsonKey(name: 'total_gain')
  double get totalGain => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_gain_percentage')
  double get totalGainPercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'day_change')
  double get dayChange => throw _privateConstructorUsedError;
  @JsonKey(name: 'day_change_percentage')
  double get dayChangePercentage => throw _privateConstructorUsedError;
  List<AssetAllocationDto> get allocations =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'top_assets')
  List<TopAssetDto> get topAssets => throw _privateConstructorUsedError;
  List<RiskAlertDto> get alerts => throw _privateConstructorUsedError;

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
      @JsonKey(name: 'total_gain') double totalGain,
      @JsonKey(name: 'total_gain_percentage') double totalGainPercentage,
      @JsonKey(name: 'day_change') double dayChange,
      @JsonKey(name: 'day_change_percentage') double dayChangePercentage,
      List<AssetAllocationDto> allocations,
      @JsonKey(name: 'top_assets') List<TopAssetDto> topAssets,
      List<RiskAlertDto> alerts});
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
    Object? totalGain = null,
    Object? totalGainPercentage = null,
    Object? dayChange = null,
    Object? dayChangePercentage = null,
    Object? allocations = null,
    Object? topAssets = null,
    Object? alerts = null,
  }) {
    return _then(_value.copyWith(
      totalValue: null == totalValue
          ? _value.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double,
      totalGain: null == totalGain
          ? _value.totalGain
          : totalGain // ignore: cast_nullable_to_non_nullable
              as double,
      totalGainPercentage: null == totalGainPercentage
          ? _value.totalGainPercentage
          : totalGainPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      dayChange: null == dayChange
          ? _value.dayChange
          : dayChange // ignore: cast_nullable_to_non_nullable
              as double,
      dayChangePercentage: null == dayChangePercentage
          ? _value.dayChangePercentage
          : dayChangePercentage // ignore: cast_nullable_to_non_nullable
              as double,
      allocations: null == allocations
          ? _value.allocations
          : allocations // ignore: cast_nullable_to_non_nullable
              as List<AssetAllocationDto>,
      topAssets: null == topAssets
          ? _value.topAssets
          : topAssets // ignore: cast_nullable_to_non_nullable
              as List<TopAssetDto>,
      alerts: null == alerts
          ? _value.alerts
          : alerts // ignore: cast_nullable_to_non_nullable
              as List<RiskAlertDto>,
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
      @JsonKey(name: 'total_gain') double totalGain,
      @JsonKey(name: 'total_gain_percentage') double totalGainPercentage,
      @JsonKey(name: 'day_change') double dayChange,
      @JsonKey(name: 'day_change_percentage') double dayChangePercentage,
      List<AssetAllocationDto> allocations,
      @JsonKey(name: 'top_assets') List<TopAssetDto> topAssets,
      List<RiskAlertDto> alerts});
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
    Object? totalGain = null,
    Object? totalGainPercentage = null,
    Object? dayChange = null,
    Object? dayChangePercentage = null,
    Object? allocations = null,
    Object? topAssets = null,
    Object? alerts = null,
  }) {
    return _then(_$PortfolioSummaryDtoImpl(
      totalValue: null == totalValue
          ? _value.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double,
      totalGain: null == totalGain
          ? _value.totalGain
          : totalGain // ignore: cast_nullable_to_non_nullable
              as double,
      totalGainPercentage: null == totalGainPercentage
          ? _value.totalGainPercentage
          : totalGainPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      dayChange: null == dayChange
          ? _value.dayChange
          : dayChange // ignore: cast_nullable_to_non_nullable
              as double,
      dayChangePercentage: null == dayChangePercentage
          ? _value.dayChangePercentage
          : dayChangePercentage // ignore: cast_nullable_to_non_nullable
              as double,
      allocations: null == allocations
          ? _value._allocations
          : allocations // ignore: cast_nullable_to_non_nullable
              as List<AssetAllocationDto>,
      topAssets: null == topAssets
          ? _value._topAssets
          : topAssets // ignore: cast_nullable_to_non_nullable
              as List<TopAssetDto>,
      alerts: null == alerts
          ? _value._alerts
          : alerts // ignore: cast_nullable_to_non_nullable
              as List<RiskAlertDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PortfolioSummaryDtoImpl extends _PortfolioSummaryDto {
  const _$PortfolioSummaryDtoImpl(
      {@JsonKey(name: 'total_value') required this.totalValue,
      @JsonKey(name: 'total_gain') required this.totalGain,
      @JsonKey(name: 'total_gain_percentage') required this.totalGainPercentage,
      @JsonKey(name: 'day_change') required this.dayChange,
      @JsonKey(name: 'day_change_percentage') required this.dayChangePercentage,
      final List<AssetAllocationDto> allocations = const [],
      @JsonKey(name: 'top_assets') final List<TopAssetDto> topAssets = const [],
      final List<RiskAlertDto> alerts = const []})
      : _allocations = allocations,
        _topAssets = topAssets,
        _alerts = alerts,
        super._();

  factory _$PortfolioSummaryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PortfolioSummaryDtoImplFromJson(json);

  @override
  @JsonKey(name: 'total_value')
  final double totalValue;
  @override
  @JsonKey(name: 'total_gain')
  final double totalGain;
  @override
  @JsonKey(name: 'total_gain_percentage')
  final double totalGainPercentage;
  @override
  @JsonKey(name: 'day_change')
  final double dayChange;
  @override
  @JsonKey(name: 'day_change_percentage')
  final double dayChangePercentage;
  final List<AssetAllocationDto> _allocations;
  @override
  @JsonKey()
  List<AssetAllocationDto> get allocations {
    if (_allocations is EqualUnmodifiableListView) return _allocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allocations);
  }

  final List<TopAssetDto> _topAssets;
  @override
  @JsonKey(name: 'top_assets')
  List<TopAssetDto> get topAssets {
    if (_topAssets is EqualUnmodifiableListView) return _topAssets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topAssets);
  }

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
    return 'PortfolioSummaryDto(totalValue: $totalValue, totalGain: $totalGain, totalGainPercentage: $totalGainPercentage, dayChange: $dayChange, dayChangePercentage: $dayChangePercentage, allocations: $allocations, topAssets: $topAssets, alerts: $alerts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PortfolioSummaryDtoImpl &&
            (identical(other.totalValue, totalValue) ||
                other.totalValue == totalValue) &&
            (identical(other.totalGain, totalGain) ||
                other.totalGain == totalGain) &&
            (identical(other.totalGainPercentage, totalGainPercentage) ||
                other.totalGainPercentage == totalGainPercentage) &&
            (identical(other.dayChange, dayChange) ||
                other.dayChange == dayChange) &&
            (identical(other.dayChangePercentage, dayChangePercentage) ||
                other.dayChangePercentage == dayChangePercentage) &&
            const DeepCollectionEquality()
                .equals(other._allocations, _allocations) &&
            const DeepCollectionEquality()
                .equals(other._topAssets, _topAssets) &&
            const DeepCollectionEquality().equals(other._alerts, _alerts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalValue,
      totalGain,
      totalGainPercentage,
      dayChange,
      dayChangePercentage,
      const DeepCollectionEquality().hash(_allocations),
      const DeepCollectionEquality().hash(_topAssets),
      const DeepCollectionEquality().hash(_alerts));

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

abstract class _PortfolioSummaryDto extends PortfolioSummaryDto {
  const factory _PortfolioSummaryDto(
      {@JsonKey(name: 'total_value') required final double totalValue,
      @JsonKey(name: 'total_gain') required final double totalGain,
      @JsonKey(name: 'total_gain_percentage')
      required final double totalGainPercentage,
      @JsonKey(name: 'day_change') required final double dayChange,
      @JsonKey(name: 'day_change_percentage')
      required final double dayChangePercentage,
      final List<AssetAllocationDto> allocations,
      @JsonKey(name: 'top_assets') final List<TopAssetDto> topAssets,
      final List<RiskAlertDto> alerts}) = _$PortfolioSummaryDtoImpl;
  const _PortfolioSummaryDto._() : super._();

  factory _PortfolioSummaryDto.fromJson(Map<String, dynamic> json) =
      _$PortfolioSummaryDtoImpl.fromJson;

  @override
  @JsonKey(name: 'total_value')
  double get totalValue;
  @override
  @JsonKey(name: 'total_gain')
  double get totalGain;
  @override
  @JsonKey(name: 'total_gain_percentage')
  double get totalGainPercentage;
  @override
  @JsonKey(name: 'day_change')
  double get dayChange;
  @override
  @JsonKey(name: 'day_change_percentage')
  double get dayChangePercentage;
  @override
  List<AssetAllocationDto> get allocations;
  @override
  @JsonKey(name: 'top_assets')
  List<TopAssetDto> get topAssets;
  @override
  List<RiskAlertDto> get alerts;

  /// Create a copy of PortfolioSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PortfolioSummaryDtoImplCopyWith<_$PortfolioSummaryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AssetAllocationDto _$AssetAllocationDtoFromJson(Map<String, dynamic> json) {
  return _AssetAllocationDto.fromJson(json);
}

/// @nodoc
mixin _$AssetAllocationDto {
  String get type => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;

  /// Serializes this AssetAllocationDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AssetAllocationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssetAllocationDtoCopyWith<AssetAllocationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetAllocationDtoCopyWith<$Res> {
  factory $AssetAllocationDtoCopyWith(
          AssetAllocationDto value, $Res Function(AssetAllocationDto) then) =
      _$AssetAllocationDtoCopyWithImpl<$Res, AssetAllocationDto>;
  @useResult
  $Res call({String type, String label, double value, double percentage});
}

/// @nodoc
class _$AssetAllocationDtoCopyWithImpl<$Res, $Val extends AssetAllocationDto>
    implements $AssetAllocationDtoCopyWith<$Res> {
  _$AssetAllocationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AssetAllocationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? label = null,
    Object? value = null,
    Object? percentage = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssetAllocationDtoImplCopyWith<$Res>
    implements $AssetAllocationDtoCopyWith<$Res> {
  factory _$$AssetAllocationDtoImplCopyWith(_$AssetAllocationDtoImpl value,
          $Res Function(_$AssetAllocationDtoImpl) then) =
      __$$AssetAllocationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, String label, double value, double percentage});
}

/// @nodoc
class __$$AssetAllocationDtoImplCopyWithImpl<$Res>
    extends _$AssetAllocationDtoCopyWithImpl<$Res, _$AssetAllocationDtoImpl>
    implements _$$AssetAllocationDtoImplCopyWith<$Res> {
  __$$AssetAllocationDtoImplCopyWithImpl(_$AssetAllocationDtoImpl _value,
      $Res Function(_$AssetAllocationDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of AssetAllocationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? label = null,
    Object? value = null,
    Object? percentage = null,
  }) {
    return _then(_$AssetAllocationDtoImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssetAllocationDtoImpl extends _AssetAllocationDto {
  const _$AssetAllocationDtoImpl(
      {required this.type,
      required this.label,
      required this.value,
      required this.percentage})
      : super._();

  factory _$AssetAllocationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssetAllocationDtoImplFromJson(json);

  @override
  final String type;
  @override
  final String label;
  @override
  final double value;
  @override
  final double percentage;

  @override
  String toString() {
    return 'AssetAllocationDto(type: $type, label: $label, value: $value, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetAllocationDtoImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, label, value, percentage);

  /// Create a copy of AssetAllocationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetAllocationDtoImplCopyWith<_$AssetAllocationDtoImpl> get copyWith =>
      __$$AssetAllocationDtoImplCopyWithImpl<_$AssetAllocationDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssetAllocationDtoImplToJson(
      this,
    );
  }
}

abstract class _AssetAllocationDto extends AssetAllocationDto {
  const factory _AssetAllocationDto(
      {required final String type,
      required final String label,
      required final double value,
      required final double percentage}) = _$AssetAllocationDtoImpl;
  const _AssetAllocationDto._() : super._();

  factory _AssetAllocationDto.fromJson(Map<String, dynamic> json) =
      _$AssetAllocationDtoImpl.fromJson;

  @override
  String get type;
  @override
  String get label;
  @override
  double get value;
  @override
  double get percentage;

  /// Create a copy of AssetAllocationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssetAllocationDtoImplCopyWith<_$AssetAllocationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopAssetDto _$TopAssetDtoFromJson(Map<String, dynamic> json) {
  return _TopAssetDto.fromJson(json);
}

/// @nodoc
mixin _$TopAssetDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  double get gain => throw _privateConstructorUsedError;
  @JsonKey(name: 'gain_percentage')
  double get gainPercentage => throw _privateConstructorUsedError;

  /// Serializes this TopAssetDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopAssetDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopAssetDtoCopyWith<TopAssetDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopAssetDtoCopyWith<$Res> {
  factory $TopAssetDtoCopyWith(
          TopAssetDto value, $Res Function(TopAssetDto) then) =
      _$TopAssetDtoCopyWithImpl<$Res, TopAssetDto>;
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      double value,
      double gain,
      @JsonKey(name: 'gain_percentage') double gainPercentage});
}

/// @nodoc
class _$TopAssetDtoCopyWithImpl<$Res, $Val extends TopAssetDto>
    implements $TopAssetDtoCopyWith<$Res> {
  _$TopAssetDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopAssetDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? value = null,
    Object? gain = null,
    Object? gainPercentage = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      gain: null == gain
          ? _value.gain
          : gain // ignore: cast_nullable_to_non_nullable
              as double,
      gainPercentage: null == gainPercentage
          ? _value.gainPercentage
          : gainPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TopAssetDtoImplCopyWith<$Res>
    implements $TopAssetDtoCopyWith<$Res> {
  factory _$$TopAssetDtoImplCopyWith(
          _$TopAssetDtoImpl value, $Res Function(_$TopAssetDtoImpl) then) =
      __$$TopAssetDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      double value,
      double gain,
      @JsonKey(name: 'gain_percentage') double gainPercentage});
}

/// @nodoc
class __$$TopAssetDtoImplCopyWithImpl<$Res>
    extends _$TopAssetDtoCopyWithImpl<$Res, _$TopAssetDtoImpl>
    implements _$$TopAssetDtoImplCopyWith<$Res> {
  __$$TopAssetDtoImplCopyWithImpl(
      _$TopAssetDtoImpl _value, $Res Function(_$TopAssetDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TopAssetDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? value = null,
    Object? gain = null,
    Object? gainPercentage = null,
  }) {
    return _then(_$TopAssetDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      gain: null == gain
          ? _value.gain
          : gain // ignore: cast_nullable_to_non_nullable
              as double,
      gainPercentage: null == gainPercentage
          ? _value.gainPercentage
          : gainPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TopAssetDtoImpl extends _TopAssetDto {
  const _$TopAssetDtoImpl(
      {required this.id,
      required this.name,
      required this.type,
      required this.value,
      required this.gain,
      @JsonKey(name: 'gain_percentage') required this.gainPercentage})
      : super._();

  factory _$TopAssetDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopAssetDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String type;
  @override
  final double value;
  @override
  final double gain;
  @override
  @JsonKey(name: 'gain_percentage')
  final double gainPercentage;

  @override
  String toString() {
    return 'TopAssetDto(id: $id, name: $name, type: $type, value: $value, gain: $gain, gainPercentage: $gainPercentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopAssetDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.gain, gain) || other.gain == gain) &&
            (identical(other.gainPercentage, gainPercentage) ||
                other.gainPercentage == gainPercentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, type, value, gain, gainPercentage);

  /// Create a copy of TopAssetDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopAssetDtoImplCopyWith<_$TopAssetDtoImpl> get copyWith =>
      __$$TopAssetDtoImplCopyWithImpl<_$TopAssetDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopAssetDtoImplToJson(
      this,
    );
  }
}

abstract class _TopAssetDto extends TopAssetDto {
  const factory _TopAssetDto(
      {required final String id,
      required final String name,
      required final String type,
      required final double value,
      required final double gain,
      @JsonKey(name: 'gain_percentage')
      required final double gainPercentage}) = _$TopAssetDtoImpl;
  const _TopAssetDto._() : super._();

  factory _TopAssetDto.fromJson(Map<String, dynamic> json) =
      _$TopAssetDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get type;
  @override
  double get value;
  @override
  double get gain;
  @override
  @JsonKey(name: 'gain_percentage')
  double get gainPercentage;

  /// Create a copy of TopAssetDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopAssetDtoImplCopyWith<_$TopAssetDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RiskAlertDto _$RiskAlertDtoFromJson(Map<String, dynamic> json) {
  return _RiskAlertDto.fromJson(json);
}

/// @nodoc
mixin _$RiskAlertDto {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get severity => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

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
      {String id,
      String title,
      String message,
      String severity,
      DateTime timestamp});
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
    Object? id = null,
    Object? title = null,
    Object? message = null,
    Object? severity = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      {String id,
      String title,
      String message,
      String severity,
      DateTime timestamp});
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
    Object? id = null,
    Object? title = null,
    Object? message = null,
    Object? severity = null,
    Object? timestamp = null,
  }) {
    return _then(_$RiskAlertDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RiskAlertDtoImpl extends _RiskAlertDto {
  const _$RiskAlertDtoImpl(
      {required this.id,
      required this.title,
      required this.message,
      required this.severity,
      required this.timestamp})
      : super._();

  factory _$RiskAlertDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RiskAlertDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String message;
  @override
  final String severity;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'RiskAlertDto(id: $id, title: $title, message: $message, severity: $severity, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RiskAlertDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, message, severity, timestamp);

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
      {required final String id,
      required final String title,
      required final String message,
      required final String severity,
      required final DateTime timestamp}) = _$RiskAlertDtoImpl;
  const _RiskAlertDto._() : super._();

  factory _RiskAlertDto.fromJson(Map<String, dynamic> json) =
      _$RiskAlertDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get message;
  @override
  String get severity;
  @override
  DateTime get timestamp;

  /// Create a copy of RiskAlertDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RiskAlertDtoImplCopyWith<_$RiskAlertDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
