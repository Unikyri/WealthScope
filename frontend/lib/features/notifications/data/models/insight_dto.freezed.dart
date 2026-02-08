// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insight_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InsightDto {
  String get id;
  String get type;
  String get category;
  String get priority;
  String get title;
  String get content;
  @JsonKey(name: 'action_items')
  List<String> get actionItems;
  @JsonKey(name: 'related_symbols')
  List<String> get relatedSymbols;
  @JsonKey(name: 'is_read')
  bool get isRead;
  @JsonKey(name: 'created_at')
  String get createdAt;

  /// Create a copy of InsightDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InsightDtoCopyWith<InsightDto> get copyWith =>
      _$InsightDtoCopyWithImpl<InsightDto>(this as InsightDto, _$identity);

  /// Serializes this InsightDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InsightDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality()
                .equals(other.actionItems, actionItems) &&
            const DeepCollectionEquality()
                .equals(other.relatedSymbols, relatedSymbols) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      category,
      priority,
      title,
      content,
      const DeepCollectionEquality().hash(actionItems),
      const DeepCollectionEquality().hash(relatedSymbols),
      isRead,
      createdAt);

  @override
  String toString() {
    return 'InsightDto(id: $id, type: $type, category: $category, priority: $priority, title: $title, content: $content, actionItems: $actionItems, relatedSymbols: $relatedSymbols, isRead: $isRead, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $InsightDtoCopyWith<$Res> {
  factory $InsightDtoCopyWith(
          InsightDto value, $Res Function(InsightDto) _then) =
      _$InsightDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String type,
      String category,
      String priority,
      String title,
      String content,
      @JsonKey(name: 'action_items') List<String> actionItems,
      @JsonKey(name: 'related_symbols') List<String> relatedSymbols,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class _$InsightDtoCopyWithImpl<$Res> implements $InsightDtoCopyWith<$Res> {
  _$InsightDtoCopyWithImpl(this._self, this._then);

  final InsightDto _self;
  final $Res Function(InsightDto) _then;

  /// Create a copy of InsightDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? category = null,
    Object? priority = null,
    Object? title = null,
    Object? content = null,
    Object? actionItems = null,
    Object? relatedSymbols = null,
    Object? isRead = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _self.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      actionItems: null == actionItems
          ? _self.actionItems
          : actionItems // ignore: cast_nullable_to_non_nullable
              as List<String>,
      relatedSymbols: null == relatedSymbols
          ? _self.relatedSymbols
          : relatedSymbols // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isRead: null == isRead
          ? _self.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [InsightDto].
extension InsightDtoPatterns on InsightDto {
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
    TResult Function(_InsightDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InsightDto() when $default != null:
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
    TResult Function(_InsightDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsightDto():
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
    TResult? Function(_InsightDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsightDto() when $default != null:
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
            String id,
            String type,
            String category,
            String priority,
            String title,
            String content,
            @JsonKey(name: 'action_items') List<String> actionItems,
            @JsonKey(name: 'related_symbols') List<String> relatedSymbols,
            @JsonKey(name: 'is_read') bool isRead,
            @JsonKey(name: 'created_at') String createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InsightDto() when $default != null:
        return $default(
            _that.id,
            _that.type,
            _that.category,
            _that.priority,
            _that.title,
            _that.content,
            _that.actionItems,
            _that.relatedSymbols,
            _that.isRead,
            _that.createdAt);
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
            String id,
            String type,
            String category,
            String priority,
            String title,
            String content,
            @JsonKey(name: 'action_items') List<String> actionItems,
            @JsonKey(name: 'related_symbols') List<String> relatedSymbols,
            @JsonKey(name: 'is_read') bool isRead,
            @JsonKey(name: 'created_at') String createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsightDto():
        return $default(
            _that.id,
            _that.type,
            _that.category,
            _that.priority,
            _that.title,
            _that.content,
            _that.actionItems,
            _that.relatedSymbols,
            _that.isRead,
            _that.createdAt);
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
            String id,
            String type,
            String category,
            String priority,
            String title,
            String content,
            @JsonKey(name: 'action_items') List<String> actionItems,
            @JsonKey(name: 'related_symbols') List<String> relatedSymbols,
            @JsonKey(name: 'is_read') bool isRead,
            @JsonKey(name: 'created_at') String createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsightDto() when $default != null:
        return $default(
            _that.id,
            _that.type,
            _that.category,
            _that.priority,
            _that.title,
            _that.content,
            _that.actionItems,
            _that.relatedSymbols,
            _that.isRead,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _InsightDto implements InsightDto {
  const _InsightDto(
      {required this.id,
      required this.type,
      required this.category,
      required this.priority,
      required this.title,
      required this.content,
      @JsonKey(name: 'action_items') final List<String> actionItems = const [],
      @JsonKey(name: 'related_symbols')
      final List<String> relatedSymbols = const [],
      @JsonKey(name: 'is_read') required this.isRead,
      @JsonKey(name: 'created_at') required this.createdAt})
      : _actionItems = actionItems,
        _relatedSymbols = relatedSymbols;
  factory _InsightDto.fromJson(Map<String, dynamic> json) =>
      _$InsightDtoFromJson(json);

  @override
  final String id;
  @override
  final String type;
  @override
  final String category;
  @override
  final String priority;
  @override
  final String title;
  @override
  final String content;
  final List<String> _actionItems;
  @override
  @JsonKey(name: 'action_items')
  List<String> get actionItems {
    if (_actionItems is EqualUnmodifiableListView) return _actionItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actionItems);
  }

  final List<String> _relatedSymbols;
  @override
  @JsonKey(name: 'related_symbols')
  List<String> get relatedSymbols {
    if (_relatedSymbols is EqualUnmodifiableListView) return _relatedSymbols;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_relatedSymbols);
  }

  @override
  @JsonKey(name: 'is_read')
  final bool isRead;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  /// Create a copy of InsightDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InsightDtoCopyWith<_InsightDto> get copyWith =>
      __$InsightDtoCopyWithImpl<_InsightDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$InsightDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InsightDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality()
                .equals(other._actionItems, _actionItems) &&
            const DeepCollectionEquality()
                .equals(other._relatedSymbols, _relatedSymbols) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      category,
      priority,
      title,
      content,
      const DeepCollectionEquality().hash(_actionItems),
      const DeepCollectionEquality().hash(_relatedSymbols),
      isRead,
      createdAt);

  @override
  String toString() {
    return 'InsightDto(id: $id, type: $type, category: $category, priority: $priority, title: $title, content: $content, actionItems: $actionItems, relatedSymbols: $relatedSymbols, isRead: $isRead, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$InsightDtoCopyWith<$Res>
    implements $InsightDtoCopyWith<$Res> {
  factory _$InsightDtoCopyWith(
          _InsightDto value, $Res Function(_InsightDto) _then) =
      __$InsightDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      String category,
      String priority,
      String title,
      String content,
      @JsonKey(name: 'action_items') List<String> actionItems,
      @JsonKey(name: 'related_symbols') List<String> relatedSymbols,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class __$InsightDtoCopyWithImpl<$Res> implements _$InsightDtoCopyWith<$Res> {
  __$InsightDtoCopyWithImpl(this._self, this._then);

  final _InsightDto _self;
  final $Res Function(_InsightDto) _then;

  /// Create a copy of InsightDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? category = null,
    Object? priority = null,
    Object? title = null,
    Object? content = null,
    Object? actionItems = null,
    Object? relatedSymbols = null,
    Object? isRead = null,
    Object? createdAt = null,
  }) {
    return _then(_InsightDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _self.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      actionItems: null == actionItems
          ? _self._actionItems
          : actionItems // ignore: cast_nullable_to_non_nullable
              as List<String>,
      relatedSymbols: null == relatedSymbols
          ? _self._relatedSymbols
          : relatedSymbols // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isRead: null == isRead
          ? _self.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$InsightListDto {
  List<InsightDto> get insights;
  int get total;
  int get limit;
  int get offset;
  @JsonKey(name: 'unread_count')
  int get unreadCount;

  /// Create a copy of InsightListDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InsightListDtoCopyWith<InsightListDto> get copyWith =>
      _$InsightListDtoCopyWithImpl<InsightListDto>(
          this as InsightListDto, _$identity);

  /// Serializes this InsightListDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InsightListDto &&
            const DeepCollectionEquality().equals(other.insights, insights) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(insights),
      total,
      limit,
      offset,
      unreadCount);

  @override
  String toString() {
    return 'InsightListDto(insights: $insights, total: $total, limit: $limit, offset: $offset, unreadCount: $unreadCount)';
  }
}

/// @nodoc
abstract mixin class $InsightListDtoCopyWith<$Res> {
  factory $InsightListDtoCopyWith(
          InsightListDto value, $Res Function(InsightListDto) _then) =
      _$InsightListDtoCopyWithImpl;
  @useResult
  $Res call(
      {List<InsightDto> insights,
      int total,
      int limit,
      int offset,
      @JsonKey(name: 'unread_count') int unreadCount});
}

/// @nodoc
class _$InsightListDtoCopyWithImpl<$Res>
    implements $InsightListDtoCopyWith<$Res> {
  _$InsightListDtoCopyWithImpl(this._self, this._then);

  final InsightListDto _self;
  final $Res Function(InsightListDto) _then;

  /// Create a copy of InsightListDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? insights = null,
    Object? total = null,
    Object? limit = null,
    Object? offset = null,
    Object? unreadCount = null,
  }) {
    return _then(_self.copyWith(
      insights: null == insights
          ? _self.insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<InsightDto>,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _self.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      offset: null == offset
          ? _self.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      unreadCount: null == unreadCount
          ? _self.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [InsightListDto].
extension InsightListDtoPatterns on InsightListDto {
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
    TResult Function(_InsightListDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InsightListDto() when $default != null:
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
    TResult Function(_InsightListDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsightListDto():
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
    TResult? Function(_InsightListDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsightListDto() when $default != null:
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
    TResult Function(List<InsightDto> insights, int total, int limit,
            int offset, @JsonKey(name: 'unread_count') int unreadCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InsightListDto() when $default != null:
        return $default(_that.insights, _that.total, _that.limit, _that.offset,
            _that.unreadCount);
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
    TResult Function(List<InsightDto> insights, int total, int limit,
            int offset, @JsonKey(name: 'unread_count') int unreadCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsightListDto():
        return $default(_that.insights, _that.total, _that.limit, _that.offset,
            _that.unreadCount);
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
    TResult? Function(List<InsightDto> insights, int total, int limit,
            int offset, @JsonKey(name: 'unread_count') int unreadCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsightListDto() when $default != null:
        return $default(_that.insights, _that.total, _that.limit, _that.offset,
            _that.unreadCount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _InsightListDto implements InsightListDto {
  const _InsightListDto(
      {required final List<InsightDto> insights,
      required this.total,
      required this.limit,
      required this.offset,
      @JsonKey(name: 'unread_count') required this.unreadCount})
      : _insights = insights;
  factory _InsightListDto.fromJson(Map<String, dynamic> json) =>
      _$InsightListDtoFromJson(json);

  final List<InsightDto> _insights;
  @override
  List<InsightDto> get insights {
    if (_insights is EqualUnmodifiableListView) return _insights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_insights);
  }

  @override
  final int total;
  @override
  final int limit;
  @override
  final int offset;
  @override
  @JsonKey(name: 'unread_count')
  final int unreadCount;

  /// Create a copy of InsightListDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InsightListDtoCopyWith<_InsightListDto> get copyWith =>
      __$InsightListDtoCopyWithImpl<_InsightListDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$InsightListDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InsightListDto &&
            const DeepCollectionEquality().equals(other._insights, _insights) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_insights),
      total,
      limit,
      offset,
      unreadCount);

  @override
  String toString() {
    return 'InsightListDto(insights: $insights, total: $total, limit: $limit, offset: $offset, unreadCount: $unreadCount)';
  }
}

/// @nodoc
abstract mixin class _$InsightListDtoCopyWith<$Res>
    implements $InsightListDtoCopyWith<$Res> {
  factory _$InsightListDtoCopyWith(
          _InsightListDto value, $Res Function(_InsightListDto) _then) =
      __$InsightListDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<InsightDto> insights,
      int total,
      int limit,
      int offset,
      @JsonKey(name: 'unread_count') int unreadCount});
}

/// @nodoc
class __$InsightListDtoCopyWithImpl<$Res>
    implements _$InsightListDtoCopyWith<$Res> {
  __$InsightListDtoCopyWithImpl(this._self, this._then);

  final _InsightListDto _self;
  final $Res Function(_InsightListDto) _then;

  /// Create a copy of InsightListDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? insights = null,
    Object? total = null,
    Object? limit = null,
    Object? offset = null,
    Object? unreadCount = null,
  }) {
    return _then(_InsightListDto(
      insights: null == insights
          ? _self._insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<InsightDto>,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _self.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      offset: null == offset
          ? _self.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      unreadCount: null == unreadCount
          ? _self.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$UnreadCountDto {
  int get count;

  /// Create a copy of UnreadCountDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UnreadCountDtoCopyWith<UnreadCountDto> get copyWith =>
      _$UnreadCountDtoCopyWithImpl<UnreadCountDto>(
          this as UnreadCountDto, _$identity);

  /// Serializes this UnreadCountDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UnreadCountDto &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, count);

  @override
  String toString() {
    return 'UnreadCountDto(count: $count)';
  }
}

/// @nodoc
abstract mixin class $UnreadCountDtoCopyWith<$Res> {
  factory $UnreadCountDtoCopyWith(
          UnreadCountDto value, $Res Function(UnreadCountDto) _then) =
      _$UnreadCountDtoCopyWithImpl;
  @useResult
  $Res call({int count});
}

/// @nodoc
class _$UnreadCountDtoCopyWithImpl<$Res>
    implements $UnreadCountDtoCopyWith<$Res> {
  _$UnreadCountDtoCopyWithImpl(this._self, this._then);

  final UnreadCountDto _self;
  final $Res Function(UnreadCountDto) _then;

  /// Create a copy of UnreadCountDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
  }) {
    return _then(_self.copyWith(
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [UnreadCountDto].
extension UnreadCountDtoPatterns on UnreadCountDto {
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
    TResult Function(_UnreadCountDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UnreadCountDto() when $default != null:
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
    TResult Function(_UnreadCountDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UnreadCountDto():
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
    TResult? Function(_UnreadCountDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UnreadCountDto() when $default != null:
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
    TResult Function(int count)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UnreadCountDto() when $default != null:
        return $default(_that.count);
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
    TResult Function(int count) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UnreadCountDto():
        return $default(_that.count);
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
    TResult? Function(int count)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UnreadCountDto() when $default != null:
        return $default(_that.count);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UnreadCountDto implements UnreadCountDto {
  const _UnreadCountDto({required this.count});
  factory _UnreadCountDto.fromJson(Map<String, dynamic> json) =>
      _$UnreadCountDtoFromJson(json);

  @override
  final int count;

  /// Create a copy of UnreadCountDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UnreadCountDtoCopyWith<_UnreadCountDto> get copyWith =>
      __$UnreadCountDtoCopyWithImpl<_UnreadCountDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UnreadCountDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UnreadCountDto &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, count);

  @override
  String toString() {
    return 'UnreadCountDto(count: $count)';
  }
}

/// @nodoc
abstract mixin class _$UnreadCountDtoCopyWith<$Res>
    implements $UnreadCountDtoCopyWith<$Res> {
  factory _$UnreadCountDtoCopyWith(
          _UnreadCountDto value, $Res Function(_UnreadCountDto) _then) =
      __$UnreadCountDtoCopyWithImpl;
  @override
  @useResult
  $Res call({int count});
}

/// @nodoc
class __$UnreadCountDtoCopyWithImpl<$Res>
    implements _$UnreadCountDtoCopyWith<$Res> {
  __$UnreadCountDtoCopyWithImpl(this._self, this._then);

  final _UnreadCountDto _self;
  final $Res Function(_UnreadCountDto) _then;

  /// Create a copy of UnreadCountDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? count = null,
  }) {
    return _then(_UnreadCountDto(
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
