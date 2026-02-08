// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'portfolio_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PortfolioSummary {
  double get totalValue;
  double get totalInvested;
  double get gainLoss;
  double get gainLossPercent;
  int get assetCount;
  List<AssetTypeBreakdown> get breakdownByType;
  DateTime get lastUpdated;

  /// Create a copy of PortfolioSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PortfolioSummaryCopyWith<PortfolioSummary> get copyWith =>
      _$PortfolioSummaryCopyWithImpl<PortfolioSummary>(
          this as PortfolioSummary, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PortfolioSummary &&
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
    return 'PortfolioSummary(totalValue: $totalValue, totalInvested: $totalInvested, gainLoss: $gainLoss, gainLossPercent: $gainLossPercent, assetCount: $assetCount, breakdownByType: $breakdownByType, lastUpdated: $lastUpdated)';
  }
}

/// @nodoc
abstract mixin class $PortfolioSummaryCopyWith<$Res> {
  factory $PortfolioSummaryCopyWith(
          PortfolioSummary value, $Res Function(PortfolioSummary) _then) =
      _$PortfolioSummaryCopyWithImpl;
  @useResult
  $Res call(
      {double totalValue,
      double totalInvested,
      double gainLoss,
      double gainLossPercent,
      int assetCount,
      List<AssetTypeBreakdown> breakdownByType,
      DateTime lastUpdated});
}

/// @nodoc
class _$PortfolioSummaryCopyWithImpl<$Res>
    implements $PortfolioSummaryCopyWith<$Res> {
  _$PortfolioSummaryCopyWithImpl(this._self, this._then);

  final PortfolioSummary _self;
  final $Res Function(PortfolioSummary) _then;

  /// Create a copy of PortfolioSummary
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
              as List<AssetTypeBreakdown>,
      lastUpdated: null == lastUpdated
          ? _self.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [PortfolioSummary].
extension PortfolioSummaryPatterns on PortfolioSummary {
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
    TResult Function(_PortfolioSummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PortfolioSummary() when $default != null:
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
    TResult Function(_PortfolioSummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioSummary():
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
    TResult? Function(_PortfolioSummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioSummary() when $default != null:
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
            double totalValue,
            double totalInvested,
            double gainLoss,
            double gainLossPercent,
            int assetCount,
            List<AssetTypeBreakdown> breakdownByType,
            DateTime lastUpdated)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PortfolioSummary() when $default != null:
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
            double totalValue,
            double totalInvested,
            double gainLoss,
            double gainLossPercent,
            int assetCount,
            List<AssetTypeBreakdown> breakdownByType,
            DateTime lastUpdated)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioSummary():
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
            double totalValue,
            double totalInvested,
            double gainLoss,
            double gainLossPercent,
            int assetCount,
            List<AssetTypeBreakdown> breakdownByType,
            DateTime lastUpdated)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioSummary() when $default != null:
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

class _PortfolioSummary implements PortfolioSummary {
  const _PortfolioSummary(
      {required this.totalValue,
      required this.totalInvested,
      required this.gainLoss,
      required this.gainLossPercent,
      this.assetCount = 0,
      final List<AssetTypeBreakdown> breakdownByType = const [],
      required this.lastUpdated})
      : _breakdownByType = breakdownByType;

  @override
  final double totalValue;
  @override
  final double totalInvested;
  @override
  final double gainLoss;
  @override
  final double gainLossPercent;
  @override
  @JsonKey()
  final int assetCount;
  final List<AssetTypeBreakdown> _breakdownByType;
  @override
  @JsonKey()
  List<AssetTypeBreakdown> get breakdownByType {
    if (_breakdownByType is EqualUnmodifiableListView) return _breakdownByType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_breakdownByType);
  }

  @override
  final DateTime lastUpdated;

  /// Create a copy of PortfolioSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PortfolioSummaryCopyWith<_PortfolioSummary> get copyWith =>
      __$PortfolioSummaryCopyWithImpl<_PortfolioSummary>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PortfolioSummary &&
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
    return 'PortfolioSummary(totalValue: $totalValue, totalInvested: $totalInvested, gainLoss: $gainLoss, gainLossPercent: $gainLossPercent, assetCount: $assetCount, breakdownByType: $breakdownByType, lastUpdated: $lastUpdated)';
  }
}

/// @nodoc
abstract mixin class _$PortfolioSummaryCopyWith<$Res>
    implements $PortfolioSummaryCopyWith<$Res> {
  factory _$PortfolioSummaryCopyWith(
          _PortfolioSummary value, $Res Function(_PortfolioSummary) _then) =
      __$PortfolioSummaryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {double totalValue,
      double totalInvested,
      double gainLoss,
      double gainLossPercent,
      int assetCount,
      List<AssetTypeBreakdown> breakdownByType,
      DateTime lastUpdated});
}

/// @nodoc
class __$PortfolioSummaryCopyWithImpl<$Res>
    implements _$PortfolioSummaryCopyWith<$Res> {
  __$PortfolioSummaryCopyWithImpl(this._self, this._then);

  final _PortfolioSummary _self;
  final $Res Function(_PortfolioSummary) _then;

  /// Create a copy of PortfolioSummary
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
    return _then(_PortfolioSummary(
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
              as List<AssetTypeBreakdown>,
      lastUpdated: null == lastUpdated
          ? _self.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$AssetTypeBreakdown {
  String get type;
  double get value;
  double get percent;
  int get count;

  /// Create a copy of AssetTypeBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AssetTypeBreakdownCopyWith<AssetTypeBreakdown> get copyWith =>
      _$AssetTypeBreakdownCopyWithImpl<AssetTypeBreakdown>(
          this as AssetTypeBreakdown, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AssetTypeBreakdown &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.percent, percent) || other.percent == percent) &&
            (identical(other.count, count) || other.count == count));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, value, percent, count);

  @override
  String toString() {
    return 'AssetTypeBreakdown(type: $type, value: $value, percent: $percent, count: $count)';
  }
}

/// @nodoc
abstract mixin class $AssetTypeBreakdownCopyWith<$Res> {
  factory $AssetTypeBreakdownCopyWith(
          AssetTypeBreakdown value, $Res Function(AssetTypeBreakdown) _then) =
      _$AssetTypeBreakdownCopyWithImpl;
  @useResult
  $Res call({String type, double value, double percent, int count});
}

/// @nodoc
class _$AssetTypeBreakdownCopyWithImpl<$Res>
    implements $AssetTypeBreakdownCopyWith<$Res> {
  _$AssetTypeBreakdownCopyWithImpl(this._self, this._then);

  final AssetTypeBreakdown _self;
  final $Res Function(AssetTypeBreakdown) _then;

  /// Create a copy of AssetTypeBreakdown
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

/// Adds pattern-matching-related methods to [AssetTypeBreakdown].
extension AssetTypeBreakdownPatterns on AssetTypeBreakdown {
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
    TResult Function(_AssetTypeBreakdown value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetTypeBreakdown() when $default != null:
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
    TResult Function(_AssetTypeBreakdown value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetTypeBreakdown():
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
    TResult? Function(_AssetTypeBreakdown value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetTypeBreakdown() when $default != null:
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
      case _AssetTypeBreakdown() when $default != null:
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
      case _AssetTypeBreakdown():
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
      case _AssetTypeBreakdown() when $default != null:
        return $default(_that.type, _that.value, _that.percent, _that.count);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AssetTypeBreakdown implements AssetTypeBreakdown {
  const _AssetTypeBreakdown(
      {required this.type,
      required this.value,
      required this.percent,
      required this.count});

  @override
  final String type;
  @override
  final double value;
  @override
  final double percent;
  @override
  final int count;

  /// Create a copy of AssetTypeBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AssetTypeBreakdownCopyWith<_AssetTypeBreakdown> get copyWith =>
      __$AssetTypeBreakdownCopyWithImpl<_AssetTypeBreakdown>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AssetTypeBreakdown &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.percent, percent) || other.percent == percent) &&
            (identical(other.count, count) || other.count == count));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, value, percent, count);

  @override
  String toString() {
    return 'AssetTypeBreakdown(type: $type, value: $value, percent: $percent, count: $count)';
  }
}

/// @nodoc
abstract mixin class _$AssetTypeBreakdownCopyWith<$Res>
    implements $AssetTypeBreakdownCopyWith<$Res> {
  factory _$AssetTypeBreakdownCopyWith(
          _AssetTypeBreakdown value, $Res Function(_AssetTypeBreakdown) _then) =
      __$AssetTypeBreakdownCopyWithImpl;
  @override
  @useResult
  $Res call({String type, double value, double percent, int count});
}

/// @nodoc
class __$AssetTypeBreakdownCopyWithImpl<$Res>
    implements _$AssetTypeBreakdownCopyWith<$Res> {
  __$AssetTypeBreakdownCopyWithImpl(this._self, this._then);

  final _AssetTypeBreakdown _self;
  final $Res Function(_AssetTypeBreakdown) _then;

  /// Create a copy of AssetTypeBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? value = null,
    Object? percent = null,
    Object? count = null,
  }) {
    return _then(_AssetTypeBreakdown(
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
mixin _$RiskAlert {
  String get type;
  String get title;
  String get message;
  AlertSeverity get severity;
  double get value;
  double get threshold;

  /// Create a copy of RiskAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RiskAlertCopyWith<RiskAlert> get copyWith =>
      _$RiskAlertCopyWithImpl<RiskAlert>(this as RiskAlert, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RiskAlert &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, type, title, message, severity, value, threshold);

  @override
  String toString() {
    return 'RiskAlert(type: $type, title: $title, message: $message, severity: $severity, value: $value, threshold: $threshold)';
  }
}

/// @nodoc
abstract mixin class $RiskAlertCopyWith<$Res> {
  factory $RiskAlertCopyWith(RiskAlert value, $Res Function(RiskAlert) _then) =
      _$RiskAlertCopyWithImpl;
  @useResult
  $Res call(
      {String type,
      String title,
      String message,
      AlertSeverity severity,
      double value,
      double threshold});
}

/// @nodoc
class _$RiskAlertCopyWithImpl<$Res> implements $RiskAlertCopyWith<$Res> {
  _$RiskAlertCopyWithImpl(this._self, this._then);

  final RiskAlert _self;
  final $Res Function(RiskAlert) _then;

  /// Create a copy of RiskAlert
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
              as AlertSeverity,
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

/// Adds pattern-matching-related methods to [RiskAlert].
extension RiskAlertPatterns on RiskAlert {
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
    TResult Function(_RiskAlert value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RiskAlert() when $default != null:
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
    TResult Function(_RiskAlert value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RiskAlert():
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
    TResult? Function(_RiskAlert value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RiskAlert() when $default != null:
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
    TResult Function(String type, String title, String message,
            AlertSeverity severity, double value, double threshold)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RiskAlert() when $default != null:
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
    TResult Function(String type, String title, String message,
            AlertSeverity severity, double value, double threshold)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RiskAlert():
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
            AlertSeverity severity, double value, double threshold)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RiskAlert() when $default != null:
        return $default(_that.type, _that.title, _that.message, _that.severity,
            _that.value, _that.threshold);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _RiskAlert implements RiskAlert {
  const _RiskAlert(
      {required this.type,
      required this.title,
      required this.message,
      required this.severity,
      required this.value,
      required this.threshold});

  @override
  final String type;
  @override
  final String title;
  @override
  final String message;
  @override
  final AlertSeverity severity;
  @override
  final double value;
  @override
  final double threshold;

  /// Create a copy of RiskAlert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RiskAlertCopyWith<_RiskAlert> get copyWith =>
      __$RiskAlertCopyWithImpl<_RiskAlert>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RiskAlert &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, type, title, message, severity, value, threshold);

  @override
  String toString() {
    return 'RiskAlert(type: $type, title: $title, message: $message, severity: $severity, value: $value, threshold: $threshold)';
  }
}

/// @nodoc
abstract mixin class _$RiskAlertCopyWith<$Res>
    implements $RiskAlertCopyWith<$Res> {
  factory _$RiskAlertCopyWith(
          _RiskAlert value, $Res Function(_RiskAlert) _then) =
      __$RiskAlertCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String type,
      String title,
      String message,
      AlertSeverity severity,
      double value,
      double threshold});
}

/// @nodoc
class __$RiskAlertCopyWithImpl<$Res> implements _$RiskAlertCopyWith<$Res> {
  __$RiskAlertCopyWithImpl(this._self, this._then);

  final _RiskAlert _self;
  final $Res Function(_RiskAlert) _then;

  /// Create a copy of RiskAlert
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
    return _then(_RiskAlert(
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
              as AlertSeverity,
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
