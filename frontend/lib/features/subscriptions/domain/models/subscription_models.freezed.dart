// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubscriptionStatus {
  bool get isActive;
  bool get isPremium;
  String? get activeEntitlementId;
  DateTime? get expirationDate;
  bool get willRenew;
  String? get managementURL;

  /// Create a copy of SubscriptionStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SubscriptionStatusCopyWith<SubscriptionStatus> get copyWith =>
      _$SubscriptionStatusCopyWithImpl<SubscriptionStatus>(
          this as SubscriptionStatus, _$identity);

  /// Serializes this SubscriptionStatus to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SubscriptionStatus &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.activeEntitlementId, activeEntitlementId) ||
                other.activeEntitlementId == activeEntitlementId) &&
            (identical(other.expirationDate, expirationDate) ||
                other.expirationDate == expirationDate) &&
            (identical(other.willRenew, willRenew) ||
                other.willRenew == willRenew) &&
            (identical(other.managementURL, managementURL) ||
                other.managementURL == managementURL));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isActive, isPremium,
      activeEntitlementId, expirationDate, willRenew, managementURL);

  @override
  String toString() {
    return 'SubscriptionStatus(isActive: $isActive, isPremium: $isPremium, activeEntitlementId: $activeEntitlementId, expirationDate: $expirationDate, willRenew: $willRenew, managementURL: $managementURL)';
  }
}

/// @nodoc
abstract mixin class $SubscriptionStatusCopyWith<$Res> {
  factory $SubscriptionStatusCopyWith(
          SubscriptionStatus value, $Res Function(SubscriptionStatus) _then) =
      _$SubscriptionStatusCopyWithImpl;
  @useResult
  $Res call(
      {bool isActive,
      bool isPremium,
      String? activeEntitlementId,
      DateTime? expirationDate,
      bool willRenew,
      String? managementURL});
}

/// @nodoc
class _$SubscriptionStatusCopyWithImpl<$Res>
    implements $SubscriptionStatusCopyWith<$Res> {
  _$SubscriptionStatusCopyWithImpl(this._self, this._then);

  final SubscriptionStatus _self;
  final $Res Function(SubscriptionStatus) _then;

  /// Create a copy of SubscriptionStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isActive = null,
    Object? isPremium = null,
    Object? activeEntitlementId = freezed,
    Object? expirationDate = freezed,
    Object? willRenew = null,
    Object? managementURL = freezed,
  }) {
    return _then(_self.copyWith(
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isPremium: null == isPremium
          ? _self.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      activeEntitlementId: freezed == activeEntitlementId
          ? _self.activeEntitlementId
          : activeEntitlementId // ignore: cast_nullable_to_non_nullable
              as String?,
      expirationDate: freezed == expirationDate
          ? _self.expirationDate
          : expirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      willRenew: null == willRenew
          ? _self.willRenew
          : willRenew // ignore: cast_nullable_to_non_nullable
              as bool,
      managementURL: freezed == managementURL
          ? _self.managementURL
          : managementURL // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SubscriptionStatus].
extension SubscriptionStatusPatterns on SubscriptionStatus {
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
    TResult Function(_SubscriptionStatus value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SubscriptionStatus() when $default != null:
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
    TResult Function(_SubscriptionStatus value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubscriptionStatus():
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
    TResult? Function(_SubscriptionStatus value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubscriptionStatus() when $default != null:
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
    TResult Function(bool isActive, bool isPremium, String? activeEntitlementId,
            DateTime? expirationDate, bool willRenew, String? managementURL)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SubscriptionStatus() when $default != null:
        return $default(
            _that.isActive,
            _that.isPremium,
            _that.activeEntitlementId,
            _that.expirationDate,
            _that.willRenew,
            _that.managementURL);
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
    TResult Function(bool isActive, bool isPremium, String? activeEntitlementId,
            DateTime? expirationDate, bool willRenew, String? managementURL)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubscriptionStatus():
        return $default(
            _that.isActive,
            _that.isPremium,
            _that.activeEntitlementId,
            _that.expirationDate,
            _that.willRenew,
            _that.managementURL);
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
            bool isActive,
            bool isPremium,
            String? activeEntitlementId,
            DateTime? expirationDate,
            bool willRenew,
            String? managementURL)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubscriptionStatus() when $default != null:
        return $default(
            _that.isActive,
            _that.isPremium,
            _that.activeEntitlementId,
            _that.expirationDate,
            _that.willRenew,
            _that.managementURL);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SubscriptionStatus implements SubscriptionStatus {
  const _SubscriptionStatus(
      {required this.isActive,
      required this.isPremium,
      required this.activeEntitlementId,
      required this.expirationDate,
      required this.willRenew,
      required this.managementURL});
  factory _SubscriptionStatus.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionStatusFromJson(json);

  @override
  final bool isActive;
  @override
  final bool isPremium;
  @override
  final String? activeEntitlementId;
  @override
  final DateTime? expirationDate;
  @override
  final bool willRenew;
  @override
  final String? managementURL;

  /// Create a copy of SubscriptionStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SubscriptionStatusCopyWith<_SubscriptionStatus> get copyWith =>
      __$SubscriptionStatusCopyWithImpl<_SubscriptionStatus>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SubscriptionStatusToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SubscriptionStatus &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.activeEntitlementId, activeEntitlementId) ||
                other.activeEntitlementId == activeEntitlementId) &&
            (identical(other.expirationDate, expirationDate) ||
                other.expirationDate == expirationDate) &&
            (identical(other.willRenew, willRenew) ||
                other.willRenew == willRenew) &&
            (identical(other.managementURL, managementURL) ||
                other.managementURL == managementURL));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isActive, isPremium,
      activeEntitlementId, expirationDate, willRenew, managementURL);

  @override
  String toString() {
    return 'SubscriptionStatus(isActive: $isActive, isPremium: $isPremium, activeEntitlementId: $activeEntitlementId, expirationDate: $expirationDate, willRenew: $willRenew, managementURL: $managementURL)';
  }
}

/// @nodoc
abstract mixin class _$SubscriptionStatusCopyWith<$Res>
    implements $SubscriptionStatusCopyWith<$Res> {
  factory _$SubscriptionStatusCopyWith(
          _SubscriptionStatus value, $Res Function(_SubscriptionStatus) _then) =
      __$SubscriptionStatusCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isActive,
      bool isPremium,
      String? activeEntitlementId,
      DateTime? expirationDate,
      bool willRenew,
      String? managementURL});
}

/// @nodoc
class __$SubscriptionStatusCopyWithImpl<$Res>
    implements _$SubscriptionStatusCopyWith<$Res> {
  __$SubscriptionStatusCopyWithImpl(this._self, this._then);

  final _SubscriptionStatus _self;
  final $Res Function(_SubscriptionStatus) _then;

  /// Create a copy of SubscriptionStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isActive = null,
    Object? isPremium = null,
    Object? activeEntitlementId = freezed,
    Object? expirationDate = freezed,
    Object? willRenew = null,
    Object? managementURL = freezed,
  }) {
    return _then(_SubscriptionStatus(
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isPremium: null == isPremium
          ? _self.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      activeEntitlementId: freezed == activeEntitlementId
          ? _self.activeEntitlementId
          : activeEntitlementId // ignore: cast_nullable_to_non_nullable
              as String?,
      expirationDate: freezed == expirationDate
          ? _self.expirationDate
          : expirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      willRenew: null == willRenew
          ? _self.willRenew
          : willRenew // ignore: cast_nullable_to_non_nullable
              as bool,
      managementURL: freezed == managementURL
          ? _self.managementURL
          : managementURL // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$SubscriptionPackage {
  String get identifier;
  String get productId;
  String get title;
  String get description;
  String get price;
  String get currencyCode;
  double get priceAmount;
  String? get introPrice;
  String? get introPeriod;

  /// Create a copy of SubscriptionPackage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SubscriptionPackageCopyWith<SubscriptionPackage> get copyWith =>
      _$SubscriptionPackageCopyWithImpl<SubscriptionPackage>(
          this as SubscriptionPackage, _$identity);

  /// Serializes this SubscriptionPackage to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SubscriptionPackage &&
            (identical(other.identifier, identifier) ||
                other.identifier == identifier) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.priceAmount, priceAmount) ||
                other.priceAmount == priceAmount) &&
            (identical(other.introPrice, introPrice) ||
                other.introPrice == introPrice) &&
            (identical(other.introPeriod, introPeriod) ||
                other.introPeriod == introPeriod));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, identifier, productId, title,
      description, price, currencyCode, priceAmount, introPrice, introPeriod);

  @override
  String toString() {
    return 'SubscriptionPackage(identifier: $identifier, productId: $productId, title: $title, description: $description, price: $price, currencyCode: $currencyCode, priceAmount: $priceAmount, introPrice: $introPrice, introPeriod: $introPeriod)';
  }
}

/// @nodoc
abstract mixin class $SubscriptionPackageCopyWith<$Res> {
  factory $SubscriptionPackageCopyWith(
          SubscriptionPackage value, $Res Function(SubscriptionPackage) _then) =
      _$SubscriptionPackageCopyWithImpl;
  @useResult
  $Res call(
      {String identifier,
      String productId,
      String title,
      String description,
      String price,
      String currencyCode,
      double priceAmount,
      String? introPrice,
      String? introPeriod});
}

/// @nodoc
class _$SubscriptionPackageCopyWithImpl<$Res>
    implements $SubscriptionPackageCopyWith<$Res> {
  _$SubscriptionPackageCopyWithImpl(this._self, this._then);

  final SubscriptionPackage _self;
  final $Res Function(SubscriptionPackage) _then;

  /// Create a copy of SubscriptionPackage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identifier = null,
    Object? productId = null,
    Object? title = null,
    Object? description = null,
    Object? price = null,
    Object? currencyCode = null,
    Object? priceAmount = null,
    Object? introPrice = freezed,
    Object? introPeriod = freezed,
  }) {
    return _then(_self.copyWith(
      identifier: null == identifier
          ? _self.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _self.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      priceAmount: null == priceAmount
          ? _self.priceAmount
          : priceAmount // ignore: cast_nullable_to_non_nullable
              as double,
      introPrice: freezed == introPrice
          ? _self.introPrice
          : introPrice // ignore: cast_nullable_to_non_nullable
              as String?,
      introPeriod: freezed == introPeriod
          ? _self.introPeriod
          : introPeriod // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SubscriptionPackage].
extension SubscriptionPackagePatterns on SubscriptionPackage {
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
    TResult Function(_SubscriptionPackage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SubscriptionPackage() when $default != null:
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
    TResult Function(_SubscriptionPackage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubscriptionPackage():
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
    TResult? Function(_SubscriptionPackage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubscriptionPackage() when $default != null:
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
            String identifier,
            String productId,
            String title,
            String description,
            String price,
            String currencyCode,
            double priceAmount,
            String? introPrice,
            String? introPeriod)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SubscriptionPackage() when $default != null:
        return $default(
            _that.identifier,
            _that.productId,
            _that.title,
            _that.description,
            _that.price,
            _that.currencyCode,
            _that.priceAmount,
            _that.introPrice,
            _that.introPeriod);
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
            String identifier,
            String productId,
            String title,
            String description,
            String price,
            String currencyCode,
            double priceAmount,
            String? introPrice,
            String? introPeriod)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubscriptionPackage():
        return $default(
            _that.identifier,
            _that.productId,
            _that.title,
            _that.description,
            _that.price,
            _that.currencyCode,
            _that.priceAmount,
            _that.introPrice,
            _that.introPeriod);
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
            String identifier,
            String productId,
            String title,
            String description,
            String price,
            String currencyCode,
            double priceAmount,
            String? introPrice,
            String? introPeriod)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubscriptionPackage() when $default != null:
        return $default(
            _that.identifier,
            _that.productId,
            _that.title,
            _that.description,
            _that.price,
            _that.currencyCode,
            _that.priceAmount,
            _that.introPrice,
            _that.introPeriod);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SubscriptionPackage implements SubscriptionPackage {
  const _SubscriptionPackage(
      {required this.identifier,
      required this.productId,
      required this.title,
      required this.description,
      required this.price,
      required this.currencyCode,
      required this.priceAmount,
      this.introPrice,
      this.introPeriod});
  factory _SubscriptionPackage.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPackageFromJson(json);

  @override
  final String identifier;
  @override
  final String productId;
  @override
  final String title;
  @override
  final String description;
  @override
  final String price;
  @override
  final String currencyCode;
  @override
  final double priceAmount;
  @override
  final String? introPrice;
  @override
  final String? introPeriod;

  /// Create a copy of SubscriptionPackage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SubscriptionPackageCopyWith<_SubscriptionPackage> get copyWith =>
      __$SubscriptionPackageCopyWithImpl<_SubscriptionPackage>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SubscriptionPackageToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SubscriptionPackage &&
            (identical(other.identifier, identifier) ||
                other.identifier == identifier) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.priceAmount, priceAmount) ||
                other.priceAmount == priceAmount) &&
            (identical(other.introPrice, introPrice) ||
                other.introPrice == introPrice) &&
            (identical(other.introPeriod, introPeriod) ||
                other.introPeriod == introPeriod));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, identifier, productId, title,
      description, price, currencyCode, priceAmount, introPrice, introPeriod);

  @override
  String toString() {
    return 'SubscriptionPackage(identifier: $identifier, productId: $productId, title: $title, description: $description, price: $price, currencyCode: $currencyCode, priceAmount: $priceAmount, introPrice: $introPrice, introPeriod: $introPeriod)';
  }
}

/// @nodoc
abstract mixin class _$SubscriptionPackageCopyWith<$Res>
    implements $SubscriptionPackageCopyWith<$Res> {
  factory _$SubscriptionPackageCopyWith(_SubscriptionPackage value,
          $Res Function(_SubscriptionPackage) _then) =
      __$SubscriptionPackageCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String identifier,
      String productId,
      String title,
      String description,
      String price,
      String currencyCode,
      double priceAmount,
      String? introPrice,
      String? introPeriod});
}

/// @nodoc
class __$SubscriptionPackageCopyWithImpl<$Res>
    implements _$SubscriptionPackageCopyWith<$Res> {
  __$SubscriptionPackageCopyWithImpl(this._self, this._then);

  final _SubscriptionPackage _self;
  final $Res Function(_SubscriptionPackage) _then;

  /// Create a copy of SubscriptionPackage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? identifier = null,
    Object? productId = null,
    Object? title = null,
    Object? description = null,
    Object? price = null,
    Object? currencyCode = null,
    Object? priceAmount = null,
    Object? introPrice = freezed,
    Object? introPeriod = freezed,
  }) {
    return _then(_SubscriptionPackage(
      identifier: null == identifier
          ? _self.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _self.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      priceAmount: null == priceAmount
          ? _self.priceAmount
          : priceAmount // ignore: cast_nullable_to_non_nullable
              as double,
      introPrice: freezed == introPrice
          ? _self.introPrice
          : introPrice // ignore: cast_nullable_to_non_nullable
              as String?,
      introPeriod: freezed == introPeriod
          ? _self.introPeriod
          : introPeriod // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$SubscriptionOffering {
  String get identifier;
  String get serverDescription;
  List<SubscriptionPackage> get packages;

  /// Create a copy of SubscriptionOffering
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SubscriptionOfferingCopyWith<SubscriptionOffering> get copyWith =>
      _$SubscriptionOfferingCopyWithImpl<SubscriptionOffering>(
          this as SubscriptionOffering, _$identity);

  /// Serializes this SubscriptionOffering to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SubscriptionOffering &&
            (identical(other.identifier, identifier) ||
                other.identifier == identifier) &&
            (identical(other.serverDescription, serverDescription) ||
                other.serverDescription == serverDescription) &&
            const DeepCollectionEquality().equals(other.packages, packages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, identifier, serverDescription,
      const DeepCollectionEquality().hash(packages));

  @override
  String toString() {
    return 'SubscriptionOffering(identifier: $identifier, serverDescription: $serverDescription, packages: $packages)';
  }
}

/// @nodoc
abstract mixin class $SubscriptionOfferingCopyWith<$Res> {
  factory $SubscriptionOfferingCopyWith(SubscriptionOffering value,
          $Res Function(SubscriptionOffering) _then) =
      _$SubscriptionOfferingCopyWithImpl;
  @useResult
  $Res call(
      {String identifier,
      String serverDescription,
      List<SubscriptionPackage> packages});
}

/// @nodoc
class _$SubscriptionOfferingCopyWithImpl<$Res>
    implements $SubscriptionOfferingCopyWith<$Res> {
  _$SubscriptionOfferingCopyWithImpl(this._self, this._then);

  final SubscriptionOffering _self;
  final $Res Function(SubscriptionOffering) _then;

  /// Create a copy of SubscriptionOffering
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identifier = null,
    Object? serverDescription = null,
    Object? packages = null,
  }) {
    return _then(_self.copyWith(
      identifier: null == identifier
          ? _self.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
              as String,
      serverDescription: null == serverDescription
          ? _self.serverDescription
          : serverDescription // ignore: cast_nullable_to_non_nullable
              as String,
      packages: null == packages
          ? _self.packages
          : packages // ignore: cast_nullable_to_non_nullable
              as List<SubscriptionPackage>,
    ));
  }
}

/// Adds pattern-matching-related methods to [SubscriptionOffering].
extension SubscriptionOfferingPatterns on SubscriptionOffering {
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
    TResult Function(_SubscriptionOffering value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SubscriptionOffering() when $default != null:
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
    TResult Function(_SubscriptionOffering value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubscriptionOffering():
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
    TResult? Function(_SubscriptionOffering value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubscriptionOffering() when $default != null:
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
    TResult Function(String identifier, String serverDescription,
            List<SubscriptionPackage> packages)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SubscriptionOffering() when $default != null:
        return $default(
            _that.identifier, _that.serverDescription, _that.packages);
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
    TResult Function(String identifier, String serverDescription,
            List<SubscriptionPackage> packages)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubscriptionOffering():
        return $default(
            _that.identifier, _that.serverDescription, _that.packages);
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
    TResult? Function(String identifier, String serverDescription,
            List<SubscriptionPackage> packages)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubscriptionOffering() when $default != null:
        return $default(
            _that.identifier, _that.serverDescription, _that.packages);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SubscriptionOffering implements SubscriptionOffering {
  const _SubscriptionOffering(
      {required this.identifier,
      required this.serverDescription,
      required final List<SubscriptionPackage> packages})
      : _packages = packages;
  factory _SubscriptionOffering.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionOfferingFromJson(json);

  @override
  final String identifier;
  @override
  final String serverDescription;
  final List<SubscriptionPackage> _packages;
  @override
  List<SubscriptionPackage> get packages {
    if (_packages is EqualUnmodifiableListView) return _packages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_packages);
  }

  /// Create a copy of SubscriptionOffering
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SubscriptionOfferingCopyWith<_SubscriptionOffering> get copyWith =>
      __$SubscriptionOfferingCopyWithImpl<_SubscriptionOffering>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SubscriptionOfferingToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SubscriptionOffering &&
            (identical(other.identifier, identifier) ||
                other.identifier == identifier) &&
            (identical(other.serverDescription, serverDescription) ||
                other.serverDescription == serverDescription) &&
            const DeepCollectionEquality().equals(other._packages, _packages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, identifier, serverDescription,
      const DeepCollectionEquality().hash(_packages));

  @override
  String toString() {
    return 'SubscriptionOffering(identifier: $identifier, serverDescription: $serverDescription, packages: $packages)';
  }
}

/// @nodoc
abstract mixin class _$SubscriptionOfferingCopyWith<$Res>
    implements $SubscriptionOfferingCopyWith<$Res> {
  factory _$SubscriptionOfferingCopyWith(_SubscriptionOffering value,
          $Res Function(_SubscriptionOffering) _then) =
      __$SubscriptionOfferingCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String identifier,
      String serverDescription,
      List<SubscriptionPackage> packages});
}

/// @nodoc
class __$SubscriptionOfferingCopyWithImpl<$Res>
    implements _$SubscriptionOfferingCopyWith<$Res> {
  __$SubscriptionOfferingCopyWithImpl(this._self, this._then);

  final _SubscriptionOffering _self;
  final $Res Function(_SubscriptionOffering) _then;

  /// Create a copy of SubscriptionOffering
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? identifier = null,
    Object? serverDescription = null,
    Object? packages = null,
  }) {
    return _then(_SubscriptionOffering(
      identifier: null == identifier
          ? _self.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
              as String,
      serverDescription: null == serverDescription
          ? _self.serverDescription
          : serverDescription // ignore: cast_nullable_to_non_nullable
              as String,
      packages: null == packages
          ? _self._packages
          : packages // ignore: cast_nullable_to_non_nullable
              as List<SubscriptionPackage>,
    ));
  }
}

// dart format on
