// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insight_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InsightDto _$InsightDtoFromJson(Map<String, dynamic> json) {
  return _InsightDto.fromJson(json);
}

/// @nodoc
mixin _$InsightDto {
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'action_items')
  List<String> get actionItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'related_symbols')
  List<String> get relatedSymbols => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  bool get isRead => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this InsightDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InsightDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InsightDtoCopyWith<InsightDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsightDtoCopyWith<$Res> {
  factory $InsightDtoCopyWith(
          InsightDto value, $Res Function(InsightDto) then) =
      _$InsightDtoCopyWithImpl<$Res, InsightDto>;
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
class _$InsightDtoCopyWithImpl<$Res, $Val extends InsightDto>
    implements $InsightDtoCopyWith<$Res> {
  _$InsightDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      actionItems: null == actionItems
          ? _value.actionItems
          : actionItems // ignore: cast_nullable_to_non_nullable
              as List<String>,
      relatedSymbols: null == relatedSymbols
          ? _value.relatedSymbols
          : relatedSymbols // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InsightDtoImplCopyWith<$Res>
    implements $InsightDtoCopyWith<$Res> {
  factory _$$InsightDtoImplCopyWith(
          _$InsightDtoImpl value, $Res Function(_$InsightDtoImpl) then) =
      __$$InsightDtoImplCopyWithImpl<$Res>;
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
class __$$InsightDtoImplCopyWithImpl<$Res>
    extends _$InsightDtoCopyWithImpl<$Res, _$InsightDtoImpl>
    implements _$$InsightDtoImplCopyWith<$Res> {
  __$$InsightDtoImplCopyWithImpl(
      _$InsightDtoImpl _value, $Res Function(_$InsightDtoImpl) _then)
      : super(_value, _then);

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
    return _then(_$InsightDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      actionItems: null == actionItems
          ? _value._actionItems
          : actionItems // ignore: cast_nullable_to_non_nullable
              as List<String>,
      relatedSymbols: null == relatedSymbols
          ? _value._relatedSymbols
          : relatedSymbols // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InsightDtoImpl implements _InsightDto {
  const _$InsightDtoImpl(
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

  factory _$InsightDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$InsightDtoImplFromJson(json);

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

  @override
  String toString() {
    return 'InsightDto(id: $id, type: $type, category: $category, priority: $priority, title: $title, content: $content, actionItems: $actionItems, relatedSymbols: $relatedSymbols, isRead: $isRead, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightDtoImpl &&
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

  /// Create a copy of InsightDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightDtoImplCopyWith<_$InsightDtoImpl> get copyWith =>
      __$$InsightDtoImplCopyWithImpl<_$InsightDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InsightDtoImplToJson(
      this,
    );
  }
}

abstract class _InsightDto implements InsightDto {
  const factory _InsightDto(
      {required final String id,
      required final String type,
      required final String category,
      required final String priority,
      required final String title,
      required final String content,
      @JsonKey(name: 'action_items') required final List<String> actionItems,
      @JsonKey(name: 'related_symbols')
      required final List<String> relatedSymbols,
      @JsonKey(name: 'is_read') required final bool isRead,
      @JsonKey(name: 'created_at')
      required final String createdAt}) = _$InsightDtoImpl;

  factory _InsightDto.fromJson(Map<String, dynamic> json) =
      _$InsightDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get type;
  @override
  String get category;
  @override
  String get priority;
  @override
  String get title;
  @override
  String get content;
  @override
  @JsonKey(name: 'action_items')
  List<String> get actionItems;
  @override
  @JsonKey(name: 'related_symbols')
  List<String> get relatedSymbols;
  @override
  @JsonKey(name: 'is_read')
  bool get isRead;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;

  /// Create a copy of InsightDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsightDtoImplCopyWith<_$InsightDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InsightListDto _$InsightListDtoFromJson(Map<String, dynamic> json) {
  return _InsightListDto.fromJson(json);
}

/// @nodoc
mixin _$InsightListDto {
  List<InsightDto> get insights => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get offset => throw _privateConstructorUsedError;
  @JsonKey(name: 'unread_count')
  int get unreadCount => throw _privateConstructorUsedError;

  /// Serializes this InsightListDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InsightListDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InsightListDtoCopyWith<InsightListDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsightListDtoCopyWith<$Res> {
  factory $InsightListDtoCopyWith(
          InsightListDto value, $Res Function(InsightListDto) then) =
      _$InsightListDtoCopyWithImpl<$Res, InsightListDto>;
  @useResult
  $Res call(
      {List<InsightDto> insights,
      int total,
      int limit,
      int offset,
      @JsonKey(name: 'unread_count') int unreadCount});
}

/// @nodoc
class _$InsightListDtoCopyWithImpl<$Res, $Val extends InsightListDto>
    implements $InsightListDtoCopyWith<$Res> {
  _$InsightListDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      insights: null == insights
          ? _value.insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<InsightDto>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InsightListDtoImplCopyWith<$Res>
    implements $InsightListDtoCopyWith<$Res> {
  factory _$$InsightListDtoImplCopyWith(_$InsightListDtoImpl value,
          $Res Function(_$InsightListDtoImpl) then) =
      __$$InsightListDtoImplCopyWithImpl<$Res>;
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
class __$$InsightListDtoImplCopyWithImpl<$Res>
    extends _$InsightListDtoCopyWithImpl<$Res, _$InsightListDtoImpl>
    implements _$$InsightListDtoImplCopyWith<$Res> {
  __$$InsightListDtoImplCopyWithImpl(
      _$InsightListDtoImpl _value, $Res Function(_$InsightListDtoImpl) _then)
      : super(_value, _then);

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
    return _then(_$InsightListDtoImpl(
      insights: null == insights
          ? _value._insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<InsightDto>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InsightListDtoImpl implements _InsightListDto {
  const _$InsightListDtoImpl(
      {required final List<InsightDto> insights,
      required this.total,
      required this.limit,
      required this.offset,
      @JsonKey(name: 'unread_count') required this.unreadCount})
      : _insights = insights;

  factory _$InsightListDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$InsightListDtoImplFromJson(json);

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

  @override
  String toString() {
    return 'InsightListDto(insights: $insights, total: $total, limit: $limit, offset: $offset, unreadCount: $unreadCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightListDtoImpl &&
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

  /// Create a copy of InsightListDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightListDtoImplCopyWith<_$InsightListDtoImpl> get copyWith =>
      __$$InsightListDtoImplCopyWithImpl<_$InsightListDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InsightListDtoImplToJson(
      this,
    );
  }
}

abstract class _InsightListDto implements InsightListDto {
  const factory _InsightListDto(
          {required final List<InsightDto> insights,
          required final int total,
          required final int limit,
          required final int offset,
          @JsonKey(name: 'unread_count') required final int unreadCount}) =
      _$InsightListDtoImpl;

  factory _InsightListDto.fromJson(Map<String, dynamic> json) =
      _$InsightListDtoImpl.fromJson;

  @override
  List<InsightDto> get insights;
  @override
  int get total;
  @override
  int get limit;
  @override
  int get offset;
  @override
  @JsonKey(name: 'unread_count')
  int get unreadCount;

  /// Create a copy of InsightListDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsightListDtoImplCopyWith<_$InsightListDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UnreadCountDto _$UnreadCountDtoFromJson(Map<String, dynamic> json) {
  return _UnreadCountDto.fromJson(json);
}

/// @nodoc
mixin _$UnreadCountDto {
  int get count => throw _privateConstructorUsedError;

  /// Serializes this UnreadCountDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UnreadCountDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UnreadCountDtoCopyWith<UnreadCountDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnreadCountDtoCopyWith<$Res> {
  factory $UnreadCountDtoCopyWith(
          UnreadCountDto value, $Res Function(UnreadCountDto) then) =
      _$UnreadCountDtoCopyWithImpl<$Res, UnreadCountDto>;
  @useResult
  $Res call({int count});
}

/// @nodoc
class _$UnreadCountDtoCopyWithImpl<$Res, $Val extends UnreadCountDto>
    implements $UnreadCountDtoCopyWith<$Res> {
  _$UnreadCountDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UnreadCountDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UnreadCountDtoImplCopyWith<$Res>
    implements $UnreadCountDtoCopyWith<$Res> {
  factory _$$UnreadCountDtoImplCopyWith(_$UnreadCountDtoImpl value,
          $Res Function(_$UnreadCountDtoImpl) then) =
      __$$UnreadCountDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int count});
}

/// @nodoc
class __$$UnreadCountDtoImplCopyWithImpl<$Res>
    extends _$UnreadCountDtoCopyWithImpl<$Res, _$UnreadCountDtoImpl>
    implements _$$UnreadCountDtoImplCopyWith<$Res> {
  __$$UnreadCountDtoImplCopyWithImpl(
      _$UnreadCountDtoImpl _value, $Res Function(_$UnreadCountDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UnreadCountDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
  }) {
    return _then(_$UnreadCountDtoImpl(
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UnreadCountDtoImpl implements _UnreadCountDto {
  const _$UnreadCountDtoImpl({required this.count});

  factory _$UnreadCountDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnreadCountDtoImplFromJson(json);

  @override
  final int count;

  @override
  String toString() {
    return 'UnreadCountDto(count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnreadCountDtoImpl &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, count);

  /// Create a copy of UnreadCountDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnreadCountDtoImplCopyWith<_$UnreadCountDtoImpl> get copyWith =>
      __$$UnreadCountDtoImplCopyWithImpl<_$UnreadCountDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnreadCountDtoImplToJson(
      this,
    );
  }
}

abstract class _UnreadCountDto implements UnreadCountDto {
  const factory _UnreadCountDto({required final int count}) =
      _$UnreadCountDtoImpl;

  factory _UnreadCountDto.fromJson(Map<String, dynamic> json) =
      _$UnreadCountDtoImpl.fromJson;

  @override
  int get count;

  /// Create a copy of UnreadCountDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnreadCountDtoImplCopyWith<_$UnreadCountDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
