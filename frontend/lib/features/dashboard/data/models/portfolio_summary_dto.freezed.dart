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
  String? get lastUpdated => throw _privateConstructorUsedError;

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
      @JsonKey(name: 'last_updated') String? lastUpdated});
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
    Object? lastUpdated = freezed,
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
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as String?,
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
      @JsonKey(name: 'last_updated') String? lastUpdated});
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
    Object? lastUpdated = freezed,
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
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PortfolioSummaryDtoImpl extends _PortfolioSummaryDto {
  const _$PortfolioSummaryDtoImpl(
      {@JsonKey(name: 'total_value') required this.totalValue,
      @JsonKey(name: 'total_invested') required this.totalInvested,
      @JsonKey(name: 'gain_loss') required this.gainLoss,
      @JsonKey(name: 'gain_loss_percent') required this.gainLossPercent,
      @JsonKey(name: 'asset_count') this.assetCount = 0,
      @JsonKey(name: 'breakdown_by_type')
      final List<AssetTypeBreakdownDto> breakdownByType = const [],
      @JsonKey(name: 'last_updated') this.lastUpdated})
      : _breakdownByType = breakdownByType,
        super._();

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
  final String? lastUpdated;

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

abstract class _PortfolioSummaryDto extends PortfolioSummaryDto {
  const factory _PortfolioSummaryDto(
      {@JsonKey(name: 'total_value') required final double totalValue,
      @JsonKey(name: 'total_invested') required final double totalInvested,
      @JsonKey(name: 'gain_loss') required final double gainLoss,
      @JsonKey(name: 'gain_loss_percent') required final double gainLossPercent,
      @JsonKey(name: 'asset_count') final int assetCount,
      @JsonKey(name: 'breakdown_by_type')
      final List<AssetTypeBreakdownDto> breakdownByType,
      @JsonKey(name: 'last_updated')
      final String? lastUpdated}) = _$PortfolioSummaryDtoImpl;
  const _PortfolioSummaryDto._() : super._();

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
  String? get lastUpdated;

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
class _$AssetTypeBreakdownDtoImpl extends _AssetTypeBreakdownDto {
  const _$AssetTypeBreakdownDtoImpl(
      {required this.type,
      required this.value,
      required this.percent,
      required this.count})
      : super._();

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

abstract class _AssetTypeBreakdownDto extends AssetTypeBreakdownDto {
  const factory _AssetTypeBreakdownDto(
      {required final String type,
      required final double value,
      required final double percent,
      required final int count}) = _$AssetTypeBreakdownDtoImpl;
  const _AssetTypeBreakdownDto._() : super._();

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
