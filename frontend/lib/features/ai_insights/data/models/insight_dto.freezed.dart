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
