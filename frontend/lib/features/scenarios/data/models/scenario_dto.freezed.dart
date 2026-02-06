// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scenario_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AllocationItemDto _$AllocationItemDtoFromJson(Map<String, dynamic> json) {
  return _AllocationItemDto.fromJson(json);
}

/// @nodoc
mixin _$AllocationItemDto {
  String get type => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  double get percent => throw _privateConstructorUsedError;

  /// Serializes this AllocationItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AllocationItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AllocationItemDtoCopyWith<AllocationItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AllocationItemDtoCopyWith<$Res> {
  factory $AllocationItemDtoCopyWith(
          AllocationItemDto value, $Res Function(AllocationItemDto) then) =
      _$AllocationItemDtoCopyWithImpl<$Res, AllocationItemDto>;
  @useResult
  $Res call({String type, double value, double percent});
}

/// @nodoc
class _$AllocationItemDtoCopyWithImpl<$Res, $Val extends AllocationItemDto>
    implements $AllocationItemDtoCopyWith<$Res> {
  _$AllocationItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AllocationItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? value = null,
    Object? percent = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AllocationItemDtoImplCopyWith<$Res>
    implements $AllocationItemDtoCopyWith<$Res> {
  factory _$$AllocationItemDtoImplCopyWith(_$AllocationItemDtoImpl value,
          $Res Function(_$AllocationItemDtoImpl) then) =
      __$$AllocationItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, double value, double percent});
}

/// @nodoc
class __$$AllocationItemDtoImplCopyWithImpl<$Res>
    extends _$AllocationItemDtoCopyWithImpl<$Res, _$AllocationItemDtoImpl>
    implements _$$AllocationItemDtoImplCopyWith<$Res> {
  __$$AllocationItemDtoImplCopyWithImpl(_$AllocationItemDtoImpl _value,
      $Res Function(_$AllocationItemDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of AllocationItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? value = null,
    Object? percent = null,
  }) {
    return _then(_$AllocationItemDtoImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AllocationItemDtoImpl implements _AllocationItemDto {
  const _$AllocationItemDtoImpl(
      {required this.type, required this.value, required this.percent});

  factory _$AllocationItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AllocationItemDtoImplFromJson(json);

  @override
  final String type;
  @override
  final double value;
  @override
  final double percent;

  @override
  String toString() {
    return 'AllocationItemDto(type: $type, value: $value, percent: $percent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AllocationItemDtoImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.percent, percent) || other.percent == percent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, value, percent);

  /// Create a copy of AllocationItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AllocationItemDtoImplCopyWith<_$AllocationItemDtoImpl> get copyWith =>
      __$$AllocationItemDtoImplCopyWithImpl<_$AllocationItemDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AllocationItemDtoImplToJson(
      this,
    );
  }
}

abstract class _AllocationItemDto implements AllocationItemDto {
  const factory _AllocationItemDto(
      {required final String type,
      required final double value,
      required final double percent}) = _$AllocationItemDtoImpl;

  factory _AllocationItemDto.fromJson(Map<String, dynamic> json) =
      _$AllocationItemDtoImpl.fromJson;

  @override
  String get type;
  @override
  double get value;
  @override
  double get percent;

  /// Create a copy of AllocationItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AllocationItemDtoImplCopyWith<_$AllocationItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PortfolioStateDto _$PortfolioStateDtoFromJson(Map<String, dynamic> json) {
  return _PortfolioStateDto.fromJson(json);
}

/// @nodoc
mixin _$PortfolioStateDto {
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
  List<AllocationItemDto> get allocation => throw _privateConstructorUsedError;

  /// Serializes this PortfolioStateDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PortfolioStateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PortfolioStateDtoCopyWith<PortfolioStateDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PortfolioStateDtoCopyWith<$Res> {
  factory $PortfolioStateDtoCopyWith(
          PortfolioStateDto value, $Res Function(PortfolioStateDto) then) =
      _$PortfolioStateDtoCopyWithImpl<$Res, PortfolioStateDto>;
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
class _$PortfolioStateDtoCopyWithImpl<$Res, $Val extends PortfolioStateDto>
    implements $PortfolioStateDtoCopyWith<$Res> {
  _$PortfolioStateDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
      allocation: null == allocation
          ? _value.allocation
          : allocation // ignore: cast_nullable_to_non_nullable
              as List<AllocationItemDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PortfolioStateDtoImplCopyWith<$Res>
    implements $PortfolioStateDtoCopyWith<$Res> {
  factory _$$PortfolioStateDtoImplCopyWith(_$PortfolioStateDtoImpl value,
          $Res Function(_$PortfolioStateDtoImpl) then) =
      __$$PortfolioStateDtoImplCopyWithImpl<$Res>;
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
class __$$PortfolioStateDtoImplCopyWithImpl<$Res>
    extends _$PortfolioStateDtoCopyWithImpl<$Res, _$PortfolioStateDtoImpl>
    implements _$$PortfolioStateDtoImplCopyWith<$Res> {
  __$$PortfolioStateDtoImplCopyWithImpl(_$PortfolioStateDtoImpl _value,
      $Res Function(_$PortfolioStateDtoImpl) _then)
      : super(_value, _then);

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
    return _then(_$PortfolioStateDtoImpl(
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
      allocation: null == allocation
          ? _value._allocation
          : allocation // ignore: cast_nullable_to_non_nullable
              as List<AllocationItemDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PortfolioStateDtoImpl implements _PortfolioStateDto {
  const _$PortfolioStateDtoImpl(
      {@JsonKey(name: 'total_value') required this.totalValue,
      @JsonKey(name: 'total_invested') required this.totalInvested,
      @JsonKey(name: 'gain_loss') required this.gainLoss,
      @JsonKey(name: 'gain_loss_percent') required this.gainLossPercent,
      @JsonKey(name: 'asset_count') required this.assetCount,
      required final List<AllocationItemDto> allocation})
      : _allocation = allocation;

  factory _$PortfolioStateDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PortfolioStateDtoImplFromJson(json);

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

  @override
  String toString() {
    return 'PortfolioStateDto(totalValue: $totalValue, totalInvested: $totalInvested, gainLoss: $gainLoss, gainLossPercent: $gainLossPercent, assetCount: $assetCount, allocation: $allocation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PortfolioStateDtoImpl &&
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

  /// Create a copy of PortfolioStateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PortfolioStateDtoImplCopyWith<_$PortfolioStateDtoImpl> get copyWith =>
      __$$PortfolioStateDtoImplCopyWithImpl<_$PortfolioStateDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PortfolioStateDtoImplToJson(
      this,
    );
  }
}

abstract class _PortfolioStateDto implements PortfolioStateDto {
  const factory _PortfolioStateDto(
      {@JsonKey(name: 'total_value') required final double totalValue,
      @JsonKey(name: 'total_invested') required final double totalInvested,
      @JsonKey(name: 'gain_loss') required final double gainLoss,
      @JsonKey(name: 'gain_loss_percent') required final double gainLossPercent,
      @JsonKey(name: 'asset_count') required final int assetCount,
      required final List<AllocationItemDto>
          allocation}) = _$PortfolioStateDtoImpl;

  factory _PortfolioStateDto.fromJson(Map<String, dynamic> json) =
      _$PortfolioStateDtoImpl.fromJson;

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
  List<AllocationItemDto> get allocation;

  /// Create a copy of PortfolioStateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PortfolioStateDtoImplCopyWith<_$PortfolioStateDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChangeDetailDto _$ChangeDetailDtoFromJson(Map<String, dynamic> json) {
  return _ChangeDetailDto.fromJson(json);
}

/// @nodoc
mixin _$ChangeDetailDto {
  String get type => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'old_value')
  double get oldValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_value')
  double get newValue => throw _privateConstructorUsedError;
  double get difference => throw _privateConstructorUsedError;

  /// Serializes this ChangeDetailDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChangeDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChangeDetailDtoCopyWith<ChangeDetailDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangeDetailDtoCopyWith<$Res> {
  factory $ChangeDetailDtoCopyWith(
          ChangeDetailDto value, $Res Function(ChangeDetailDto) then) =
      _$ChangeDetailDtoCopyWithImpl<$Res, ChangeDetailDto>;
  @useResult
  $Res call(
      {String type,
      String description,
      @JsonKey(name: 'old_value') double oldValue,
      @JsonKey(name: 'new_value') double newValue,
      double difference});
}

/// @nodoc
class _$ChangeDetailDtoCopyWithImpl<$Res, $Val extends ChangeDetailDto>
    implements $ChangeDetailDtoCopyWith<$Res> {
  _$ChangeDetailDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      oldValue: null == oldValue
          ? _value.oldValue
          : oldValue // ignore: cast_nullable_to_non_nullable
              as double,
      newValue: null == newValue
          ? _value.newValue
          : newValue // ignore: cast_nullable_to_non_nullable
              as double,
      difference: null == difference
          ? _value.difference
          : difference // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChangeDetailDtoImplCopyWith<$Res>
    implements $ChangeDetailDtoCopyWith<$Res> {
  factory _$$ChangeDetailDtoImplCopyWith(_$ChangeDetailDtoImpl value,
          $Res Function(_$ChangeDetailDtoImpl) then) =
      __$$ChangeDetailDtoImplCopyWithImpl<$Res>;
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
class __$$ChangeDetailDtoImplCopyWithImpl<$Res>
    extends _$ChangeDetailDtoCopyWithImpl<$Res, _$ChangeDetailDtoImpl>
    implements _$$ChangeDetailDtoImplCopyWith<$Res> {
  __$$ChangeDetailDtoImplCopyWithImpl(
      _$ChangeDetailDtoImpl _value, $Res Function(_$ChangeDetailDtoImpl) _then)
      : super(_value, _then);

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
    return _then(_$ChangeDetailDtoImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      oldValue: null == oldValue
          ? _value.oldValue
          : oldValue // ignore: cast_nullable_to_non_nullable
              as double,
      newValue: null == newValue
          ? _value.newValue
          : newValue // ignore: cast_nullable_to_non_nullable
              as double,
      difference: null == difference
          ? _value.difference
          : difference // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChangeDetailDtoImpl implements _ChangeDetailDto {
  const _$ChangeDetailDtoImpl(
      {required this.type,
      required this.description,
      @JsonKey(name: 'old_value') required this.oldValue,
      @JsonKey(name: 'new_value') required this.newValue,
      required this.difference});

  factory _$ChangeDetailDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChangeDetailDtoImplFromJson(json);

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

  @override
  String toString() {
    return 'ChangeDetailDto(type: $type, description: $description, oldValue: $oldValue, newValue: $newValue, difference: $difference)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangeDetailDtoImpl &&
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

  /// Create a copy of ChangeDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangeDetailDtoImplCopyWith<_$ChangeDetailDtoImpl> get copyWith =>
      __$$ChangeDetailDtoImplCopyWithImpl<_$ChangeDetailDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChangeDetailDtoImplToJson(
      this,
    );
  }
}

abstract class _ChangeDetailDto implements ChangeDetailDto {
  const factory _ChangeDetailDto(
      {required final String type,
      required final String description,
      @JsonKey(name: 'old_value') required final double oldValue,
      @JsonKey(name: 'new_value') required final double newValue,
      required final double difference}) = _$ChangeDetailDtoImpl;

  factory _ChangeDetailDto.fromJson(Map<String, dynamic> json) =
      _$ChangeDetailDtoImpl.fromJson;

  @override
  String get type;
  @override
  String get description;
  @override
  @JsonKey(name: 'old_value')
  double get oldValue;
  @override
  @JsonKey(name: 'new_value')
  double get newValue;
  @override
  double get difference;

  /// Create a copy of ChangeDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChangeDetailDtoImplCopyWith<_$ChangeDetailDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SimulationResultDto _$SimulationResultDtoFromJson(Map<String, dynamic> json) {
  return _SimulationResultDto.fromJson(json);
}

/// @nodoc
mixin _$SimulationResultDto {
  @JsonKey(name: 'current_state')
  PortfolioStateDto get currentState => throw _privateConstructorUsedError;
  @JsonKey(name: 'projected_state')
  PortfolioStateDto get projectedState => throw _privateConstructorUsedError;
  List<ChangeDetailDto> get changes => throw _privateConstructorUsedError;
  @JsonKey(name: 'ai_analysis')
  String get aiAnalysis => throw _privateConstructorUsedError;
  List<String> get warnings => throw _privateConstructorUsedError;

  /// Serializes this SimulationResultDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SimulationResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SimulationResultDtoCopyWith<SimulationResultDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SimulationResultDtoCopyWith<$Res> {
  factory $SimulationResultDtoCopyWith(
          SimulationResultDto value, $Res Function(SimulationResultDto) then) =
      _$SimulationResultDtoCopyWithImpl<$Res, SimulationResultDto>;
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
class _$SimulationResultDtoCopyWithImpl<$Res, $Val extends SimulationResultDto>
    implements $SimulationResultDtoCopyWith<$Res> {
  _$SimulationResultDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      currentState: null == currentState
          ? _value.currentState
          : currentState // ignore: cast_nullable_to_non_nullable
              as PortfolioStateDto,
      projectedState: null == projectedState
          ? _value.projectedState
          : projectedState // ignore: cast_nullable_to_non_nullable
              as PortfolioStateDto,
      changes: null == changes
          ? _value.changes
          : changes // ignore: cast_nullable_to_non_nullable
              as List<ChangeDetailDto>,
      aiAnalysis: null == aiAnalysis
          ? _value.aiAnalysis
          : aiAnalysis // ignore: cast_nullable_to_non_nullable
              as String,
      warnings: null == warnings
          ? _value.warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  /// Create a copy of SimulationResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PortfolioStateDtoCopyWith<$Res> get currentState {
    return $PortfolioStateDtoCopyWith<$Res>(_value.currentState, (value) {
      return _then(_value.copyWith(currentState: value) as $Val);
    });
  }

  /// Create a copy of SimulationResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PortfolioStateDtoCopyWith<$Res> get projectedState {
    return $PortfolioStateDtoCopyWith<$Res>(_value.projectedState, (value) {
      return _then(_value.copyWith(projectedState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SimulationResultDtoImplCopyWith<$Res>
    implements $SimulationResultDtoCopyWith<$Res> {
  factory _$$SimulationResultDtoImplCopyWith(_$SimulationResultDtoImpl value,
          $Res Function(_$SimulationResultDtoImpl) then) =
      __$$SimulationResultDtoImplCopyWithImpl<$Res>;
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
class __$$SimulationResultDtoImplCopyWithImpl<$Res>
    extends _$SimulationResultDtoCopyWithImpl<$Res, _$SimulationResultDtoImpl>
    implements _$$SimulationResultDtoImplCopyWith<$Res> {
  __$$SimulationResultDtoImplCopyWithImpl(_$SimulationResultDtoImpl _value,
      $Res Function(_$SimulationResultDtoImpl) _then)
      : super(_value, _then);

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
    return _then(_$SimulationResultDtoImpl(
      currentState: null == currentState
          ? _value.currentState
          : currentState // ignore: cast_nullable_to_non_nullable
              as PortfolioStateDto,
      projectedState: null == projectedState
          ? _value.projectedState
          : projectedState // ignore: cast_nullable_to_non_nullable
              as PortfolioStateDto,
      changes: null == changes
          ? _value._changes
          : changes // ignore: cast_nullable_to_non_nullable
              as List<ChangeDetailDto>,
      aiAnalysis: null == aiAnalysis
          ? _value.aiAnalysis
          : aiAnalysis // ignore: cast_nullable_to_non_nullable
              as String,
      warnings: null == warnings
          ? _value._warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SimulationResultDtoImpl implements _SimulationResultDto {
  const _$SimulationResultDtoImpl(
      {@JsonKey(name: 'current_state') required this.currentState,
      @JsonKey(name: 'projected_state') required this.projectedState,
      required final List<ChangeDetailDto> changes,
      @JsonKey(name: 'ai_analysis') required this.aiAnalysis,
      required final List<String> warnings})
      : _changes = changes,
        _warnings = warnings;

  factory _$SimulationResultDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SimulationResultDtoImplFromJson(json);

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

  @override
  String toString() {
    return 'SimulationResultDto(currentState: $currentState, projectedState: $projectedState, changes: $changes, aiAnalysis: $aiAnalysis, warnings: $warnings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SimulationResultDtoImpl &&
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

  /// Create a copy of SimulationResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SimulationResultDtoImplCopyWith<_$SimulationResultDtoImpl> get copyWith =>
      __$$SimulationResultDtoImplCopyWithImpl<_$SimulationResultDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SimulationResultDtoImplToJson(
      this,
    );
  }
}

abstract class _SimulationResultDto implements SimulationResultDto {
  const factory _SimulationResultDto(
      {@JsonKey(name: 'current_state')
      required final PortfolioStateDto currentState,
      @JsonKey(name: 'projected_state')
      required final PortfolioStateDto projectedState,
      required final List<ChangeDetailDto> changes,
      @JsonKey(name: 'ai_analysis') required final String aiAnalysis,
      required final List<String> warnings}) = _$SimulationResultDtoImpl;

  factory _SimulationResultDto.fromJson(Map<String, dynamic> json) =
      _$SimulationResultDtoImpl.fromJson;

  @override
  @JsonKey(name: 'current_state')
  PortfolioStateDto get currentState;
  @override
  @JsonKey(name: 'projected_state')
  PortfolioStateDto get projectedState;
  @override
  List<ChangeDetailDto> get changes;
  @override
  @JsonKey(name: 'ai_analysis')
  String get aiAnalysis;
  @override
  List<String> get warnings;

  /// Create a copy of SimulationResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SimulationResultDtoImplCopyWith<_$SimulationResultDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HistoricalStatsDto _$HistoricalStatsDtoFromJson(Map<String, dynamic> json) {
  return _HistoricalStatsDto.fromJson(json);
}

/// @nodoc
mixin _$HistoricalStatsDto {
  String get symbol => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;
  double get volatility => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_drawdown')
  double get maxDrawdown => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_return')
  double get averageReturn => throw _privateConstructorUsedError;
  @JsonKey(name: 'best_day')
  double get bestDay => throw _privateConstructorUsedError;
  @JsonKey(name: 'worst_day')
  double get worstDay => throw _privateConstructorUsedError;
  @JsonKey(name: 'positive_days')
  int get positiveDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'negative_days')
  int get negativeDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_points')
  int get dataPoints => throw _privateConstructorUsedError;

  /// Serializes this HistoricalStatsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HistoricalStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HistoricalStatsDtoCopyWith<HistoricalStatsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoricalStatsDtoCopyWith<$Res> {
  factory $HistoricalStatsDtoCopyWith(
          HistoricalStatsDto value, $Res Function(HistoricalStatsDto) then) =
      _$HistoricalStatsDtoCopyWithImpl<$Res, HistoricalStatsDto>;
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
class _$HistoricalStatsDtoCopyWithImpl<$Res, $Val extends HistoricalStatsDto>
    implements $HistoricalStatsDtoCopyWith<$Res> {
  _$HistoricalStatsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      volatility: null == volatility
          ? _value.volatility
          : volatility // ignore: cast_nullable_to_non_nullable
              as double,
      maxDrawdown: null == maxDrawdown
          ? _value.maxDrawdown
          : maxDrawdown // ignore: cast_nullable_to_non_nullable
              as double,
      averageReturn: null == averageReturn
          ? _value.averageReturn
          : averageReturn // ignore: cast_nullable_to_non_nullable
              as double,
      bestDay: null == bestDay
          ? _value.bestDay
          : bestDay // ignore: cast_nullable_to_non_nullable
              as double,
      worstDay: null == worstDay
          ? _value.worstDay
          : worstDay // ignore: cast_nullable_to_non_nullable
              as double,
      positiveDays: null == positiveDays
          ? _value.positiveDays
          : positiveDays // ignore: cast_nullable_to_non_nullable
              as int,
      negativeDays: null == negativeDays
          ? _value.negativeDays
          : negativeDays // ignore: cast_nullable_to_non_nullable
              as int,
      dataPoints: null == dataPoints
          ? _value.dataPoints
          : dataPoints // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HistoricalStatsDtoImplCopyWith<$Res>
    implements $HistoricalStatsDtoCopyWith<$Res> {
  factory _$$HistoricalStatsDtoImplCopyWith(_$HistoricalStatsDtoImpl value,
          $Res Function(_$HistoricalStatsDtoImpl) then) =
      __$$HistoricalStatsDtoImplCopyWithImpl<$Res>;
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
class __$$HistoricalStatsDtoImplCopyWithImpl<$Res>
    extends _$HistoricalStatsDtoCopyWithImpl<$Res, _$HistoricalStatsDtoImpl>
    implements _$$HistoricalStatsDtoImplCopyWith<$Res> {
  __$$HistoricalStatsDtoImplCopyWithImpl(_$HistoricalStatsDtoImpl _value,
      $Res Function(_$HistoricalStatsDtoImpl) _then)
      : super(_value, _then);

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
    return _then(_$HistoricalStatsDtoImpl(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      volatility: null == volatility
          ? _value.volatility
          : volatility // ignore: cast_nullable_to_non_nullable
              as double,
      maxDrawdown: null == maxDrawdown
          ? _value.maxDrawdown
          : maxDrawdown // ignore: cast_nullable_to_non_nullable
              as double,
      averageReturn: null == averageReturn
          ? _value.averageReturn
          : averageReturn // ignore: cast_nullable_to_non_nullable
              as double,
      bestDay: null == bestDay
          ? _value.bestDay
          : bestDay // ignore: cast_nullable_to_non_nullable
              as double,
      worstDay: null == worstDay
          ? _value.worstDay
          : worstDay // ignore: cast_nullable_to_non_nullable
              as double,
      positiveDays: null == positiveDays
          ? _value.positiveDays
          : positiveDays // ignore: cast_nullable_to_non_nullable
              as int,
      negativeDays: null == negativeDays
          ? _value.negativeDays
          : negativeDays // ignore: cast_nullable_to_non_nullable
              as int,
      dataPoints: null == dataPoints
          ? _value.dataPoints
          : dataPoints // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HistoricalStatsDtoImpl implements _HistoricalStatsDto {
  const _$HistoricalStatsDtoImpl(
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

  factory _$HistoricalStatsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$HistoricalStatsDtoImplFromJson(json);

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

  @override
  String toString() {
    return 'HistoricalStatsDto(symbol: $symbol, period: $period, volatility: $volatility, maxDrawdown: $maxDrawdown, averageReturn: $averageReturn, bestDay: $bestDay, worstDay: $worstDay, positiveDays: $positiveDays, negativeDays: $negativeDays, dataPoints: $dataPoints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoricalStatsDtoImpl &&
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

  /// Create a copy of HistoricalStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoricalStatsDtoImplCopyWith<_$HistoricalStatsDtoImpl> get copyWith =>
      __$$HistoricalStatsDtoImplCopyWithImpl<_$HistoricalStatsDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HistoricalStatsDtoImplToJson(
      this,
    );
  }
}

abstract class _HistoricalStatsDto implements HistoricalStatsDto {
  const factory _HistoricalStatsDto(
          {required final String symbol,
          required final String period,
          required final double volatility,
          @JsonKey(name: 'max_drawdown') required final double maxDrawdown,
          @JsonKey(name: 'average_return') required final double averageReturn,
          @JsonKey(name: 'best_day') required final double bestDay,
          @JsonKey(name: 'worst_day') required final double worstDay,
          @JsonKey(name: 'positive_days') required final int positiveDays,
          @JsonKey(name: 'negative_days') required final int negativeDays,
          @JsonKey(name: 'data_points') required final int dataPoints}) =
      _$HistoricalStatsDtoImpl;

  factory _HistoricalStatsDto.fromJson(Map<String, dynamic> json) =
      _$HistoricalStatsDtoImpl.fromJson;

  @override
  String get symbol;
  @override
  String get period;
  @override
  double get volatility;
  @override
  @JsonKey(name: 'max_drawdown')
  double get maxDrawdown;
  @override
  @JsonKey(name: 'average_return')
  double get averageReturn;
  @override
  @JsonKey(name: 'best_day')
  double get bestDay;
  @override
  @JsonKey(name: 'worst_day')
  double get worstDay;
  @override
  @JsonKey(name: 'positive_days')
  int get positiveDays;
  @override
  @JsonKey(name: 'negative_days')
  int get negativeDays;
  @override
  @JsonKey(name: 'data_points')
  int get dataPoints;

  /// Create a copy of HistoricalStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HistoricalStatsDtoImplCopyWith<_$HistoricalStatsDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScenarioTemplateDto _$ScenarioTemplateDtoFromJson(Map<String, dynamic> json) {
  return _ScenarioTemplateDto.fromJson(json);
}

/// @nodoc
mixin _$ScenarioTemplateDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  Map<String, dynamic> get parameters => throw _privateConstructorUsedError;

  /// Serializes this ScenarioTemplateDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScenarioTemplateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScenarioTemplateDtoCopyWith<ScenarioTemplateDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScenarioTemplateDtoCopyWith<$Res> {
  factory $ScenarioTemplateDtoCopyWith(
          ScenarioTemplateDto value, $Res Function(ScenarioTemplateDto) then) =
      _$ScenarioTemplateDtoCopyWithImpl<$Res, ScenarioTemplateDto>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String type,
      Map<String, dynamic> parameters});
}

/// @nodoc
class _$ScenarioTemplateDtoCopyWithImpl<$Res, $Val extends ScenarioTemplateDto>
    implements $ScenarioTemplateDtoCopyWith<$Res> {
  _$ScenarioTemplateDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      parameters: null == parameters
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScenarioTemplateDtoImplCopyWith<$Res>
    implements $ScenarioTemplateDtoCopyWith<$Res> {
  factory _$$ScenarioTemplateDtoImplCopyWith(_$ScenarioTemplateDtoImpl value,
          $Res Function(_$ScenarioTemplateDtoImpl) then) =
      __$$ScenarioTemplateDtoImplCopyWithImpl<$Res>;
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
class __$$ScenarioTemplateDtoImplCopyWithImpl<$Res>
    extends _$ScenarioTemplateDtoCopyWithImpl<$Res, _$ScenarioTemplateDtoImpl>
    implements _$$ScenarioTemplateDtoImplCopyWith<$Res> {
  __$$ScenarioTemplateDtoImplCopyWithImpl(_$ScenarioTemplateDtoImpl _value,
      $Res Function(_$ScenarioTemplateDtoImpl) _then)
      : super(_value, _then);

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
    return _then(_$ScenarioTemplateDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      parameters: null == parameters
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScenarioTemplateDtoImpl implements _ScenarioTemplateDto {
  const _$ScenarioTemplateDtoImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.type,
      required final Map<String, dynamic> parameters})
      : _parameters = parameters;

  factory _$ScenarioTemplateDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScenarioTemplateDtoImplFromJson(json);

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

  @override
  String toString() {
    return 'ScenarioTemplateDto(id: $id, name: $name, description: $description, type: $type, parameters: $parameters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScenarioTemplateDtoImpl &&
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

  /// Create a copy of ScenarioTemplateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScenarioTemplateDtoImplCopyWith<_$ScenarioTemplateDtoImpl> get copyWith =>
      __$$ScenarioTemplateDtoImplCopyWithImpl<_$ScenarioTemplateDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScenarioTemplateDtoImplToJson(
      this,
    );
  }
}

abstract class _ScenarioTemplateDto implements ScenarioTemplateDto {
  const factory _ScenarioTemplateDto(
          {required final String id,
          required final String name,
          required final String description,
          required final String type,
          required final Map<String, dynamic> parameters}) =
      _$ScenarioTemplateDtoImpl;

  factory _ScenarioTemplateDto.fromJson(Map<String, dynamic> json) =
      _$ScenarioTemplateDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get type;
  @override
  Map<String, dynamic> get parameters;

  /// Create a copy of ScenarioTemplateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScenarioTemplateDtoImplCopyWith<_$ScenarioTemplateDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SimulateRequestDto _$SimulateRequestDtoFromJson(Map<String, dynamic> json) {
  return _SimulateRequestDto.fromJson(json);
}

/// @nodoc
mixin _$SimulateRequestDto {
  String get type => throw _privateConstructorUsedError;
  Map<String, dynamic> get parameters => throw _privateConstructorUsedError;

  /// Serializes this SimulateRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SimulateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SimulateRequestDtoCopyWith<SimulateRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SimulateRequestDtoCopyWith<$Res> {
  factory $SimulateRequestDtoCopyWith(
          SimulateRequestDto value, $Res Function(SimulateRequestDto) then) =
      _$SimulateRequestDtoCopyWithImpl<$Res, SimulateRequestDto>;
  @useResult
  $Res call({String type, Map<String, dynamic> parameters});
}

/// @nodoc
class _$SimulateRequestDtoCopyWithImpl<$Res, $Val extends SimulateRequestDto>
    implements $SimulateRequestDtoCopyWith<$Res> {
  _$SimulateRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SimulateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? parameters = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      parameters: null == parameters
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SimulateRequestDtoImplCopyWith<$Res>
    implements $SimulateRequestDtoCopyWith<$Res> {
  factory _$$SimulateRequestDtoImplCopyWith(_$SimulateRequestDtoImpl value,
          $Res Function(_$SimulateRequestDtoImpl) then) =
      __$$SimulateRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, Map<String, dynamic> parameters});
}

/// @nodoc
class __$$SimulateRequestDtoImplCopyWithImpl<$Res>
    extends _$SimulateRequestDtoCopyWithImpl<$Res, _$SimulateRequestDtoImpl>
    implements _$$SimulateRequestDtoImplCopyWith<$Res> {
  __$$SimulateRequestDtoImplCopyWithImpl(_$SimulateRequestDtoImpl _value,
      $Res Function(_$SimulateRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SimulateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? parameters = null,
  }) {
    return _then(_$SimulateRequestDtoImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      parameters: null == parameters
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SimulateRequestDtoImpl implements _SimulateRequestDto {
  const _$SimulateRequestDtoImpl(
      {required this.type, required final Map<String, dynamic> parameters})
      : _parameters = parameters;

  factory _$SimulateRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SimulateRequestDtoImplFromJson(json);

  @override
  final String type;
  final Map<String, dynamic> _parameters;
  @override
  Map<String, dynamic> get parameters {
    if (_parameters is EqualUnmodifiableMapView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_parameters);
  }

  @override
  String toString() {
    return 'SimulateRequestDto(type: $type, parameters: $parameters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SimulateRequestDtoImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, const DeepCollectionEquality().hash(_parameters));

  /// Create a copy of SimulateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SimulateRequestDtoImplCopyWith<_$SimulateRequestDtoImpl> get copyWith =>
      __$$SimulateRequestDtoImplCopyWithImpl<_$SimulateRequestDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SimulateRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _SimulateRequestDto implements SimulateRequestDto {
  const factory _SimulateRequestDto(
          {required final String type,
          required final Map<String, dynamic> parameters}) =
      _$SimulateRequestDtoImpl;

  factory _SimulateRequestDto.fromJson(Map<String, dynamic> json) =
      _$SimulateRequestDtoImpl.fromJson;

  @override
  String get type;
  @override
  Map<String, dynamic> get parameters;

  /// Create a copy of SimulateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SimulateRequestDtoImplCopyWith<_$SimulateRequestDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
