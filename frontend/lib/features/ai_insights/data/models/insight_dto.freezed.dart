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
      @JsonKey(name: 'action_items') required final List<String> actionItems,
      @JsonKey(name: 'related_symbols')
      required final List<String> relatedSymbols,
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

// dart format on
