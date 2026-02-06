// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConversationDto _$ConversationDtoFromJson(Map<String, dynamic> json) {
  return _ConversationDto.fromJson(json);
}

/// @nodoc
mixin _$ConversationDto {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ConversationDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConversationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationDtoCopyWith<ConversationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationDtoCopyWith<$Res> {
  factory $ConversationDtoCopyWith(
          ConversationDto value, $Res Function(ConversationDto) then) =
      _$ConversationDtoCopyWithImpl<$Res, ConversationDto>;
  @useResult
  $Res call(
      {String id,
      String title,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt});
}

/// @nodoc
class _$ConversationDtoCopyWithImpl<$Res, $Val extends ConversationDto>
    implements $ConversationDtoCopyWith<$Res> {
  _$ConversationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationDtoImplCopyWith<$Res>
    implements $ConversationDtoCopyWith<$Res> {
  factory _$$ConversationDtoImplCopyWith(_$ConversationDtoImpl value,
          $Res Function(_$ConversationDtoImpl) then) =
      __$$ConversationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt});
}

/// @nodoc
class __$$ConversationDtoImplCopyWithImpl<$Res>
    extends _$ConversationDtoCopyWithImpl<$Res, _$ConversationDtoImpl>
    implements _$$ConversationDtoImplCopyWith<$Res> {
  __$$ConversationDtoImplCopyWithImpl(
      _$ConversationDtoImpl _value, $Res Function(_$ConversationDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConversationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ConversationDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationDtoImpl implements _ConversationDto {
  const _$ConversationDtoImpl(
      {required this.id,
      required this.title,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$ConversationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @override
  String toString() {
    return 'ConversationDto(id: $id, title: $title, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, createdAt, updatedAt);

  /// Create a copy of ConversationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationDtoImplCopyWith<_$ConversationDtoImpl> get copyWith =>
      __$$ConversationDtoImplCopyWithImpl<_$ConversationDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationDtoImplToJson(
      this,
    );
  }
}

abstract class _ConversationDto implements ConversationDto {
  const factory _ConversationDto(
          {required final String id,
          required final String title,
          @JsonKey(name: 'created_at') required final String createdAt,
          @JsonKey(name: 'updated_at') required final String updatedAt}) =
      _$ConversationDtoImpl;

  factory _ConversationDto.fromJson(Map<String, dynamic> json) =
      _$ConversationDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;

  /// Create a copy of ConversationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationDtoImplCopyWith<_$ConversationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) {
  return _MessageDto.fromJson(json);
}

/// @nodoc
mixin _$MessageDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversation_id')
  String get conversationId => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this MessageDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageDtoCopyWith<MessageDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageDtoCopyWith<$Res> {
  factory $MessageDtoCopyWith(
          MessageDto value, $Res Function(MessageDto) then) =
      _$MessageDtoCopyWithImpl<$Res, MessageDto>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'conversation_id') String conversationId,
      String role,
      String content,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class _$MessageDtoCopyWithImpl<$Res, $Val extends MessageDto>
    implements $MessageDtoCopyWith<$Res> {
  _$MessageDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? role = null,
    Object? content = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageDtoImplCopyWith<$Res>
    implements $MessageDtoCopyWith<$Res> {
  factory _$$MessageDtoImplCopyWith(
          _$MessageDtoImpl value, $Res Function(_$MessageDtoImpl) then) =
      __$$MessageDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'conversation_id') String conversationId,
      String role,
      String content,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class __$$MessageDtoImplCopyWithImpl<$Res>
    extends _$MessageDtoCopyWithImpl<$Res, _$MessageDtoImpl>
    implements _$$MessageDtoImplCopyWith<$Res> {
  __$$MessageDtoImplCopyWithImpl(
      _$MessageDtoImpl _value, $Res Function(_$MessageDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? role = null,
    Object? content = null,
    Object? createdAt = null,
  }) {
    return _then(_$MessageDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageDtoImpl implements _MessageDto {
  const _$MessageDtoImpl(
      {required this.id,
      @JsonKey(name: 'conversation_id') required this.conversationId,
      required this.role,
      required this.content,
      @JsonKey(name: 'created_at') required this.createdAt});

  factory _$MessageDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'conversation_id')
  final String conversationId;
  @override
  final String role;
  @override
  final String content;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  @override
  String toString() {
    return 'MessageDto(id: $id, conversationId: $conversationId, role: $role, content: $content, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, conversationId, role, content, createdAt);

  /// Create a copy of MessageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageDtoImplCopyWith<_$MessageDtoImpl> get copyWith =>
      __$$MessageDtoImplCopyWithImpl<_$MessageDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageDtoImplToJson(
      this,
    );
  }
}

abstract class _MessageDto implements MessageDto {
  const factory _MessageDto(
      {required final String id,
      @JsonKey(name: 'conversation_id') required final String conversationId,
      required final String role,
      required final String content,
      @JsonKey(name: 'created_at')
      required final String createdAt}) = _$MessageDtoImpl;

  factory _MessageDto.fromJson(Map<String, dynamic> json) =
      _$MessageDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'conversation_id')
  String get conversationId;
  @override
  String get role;
  @override
  String get content;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;

  /// Create a copy of MessageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageDtoImplCopyWith<_$MessageDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConversationWithMessagesDto _$ConversationWithMessagesDtoFromJson(
    Map<String, dynamic> json) {
  return _ConversationWithMessagesDto.fromJson(json);
}

/// @nodoc
mixin _$ConversationWithMessagesDto {
  ConversationDto get conversation => throw _privateConstructorUsedError;
  List<MessageDto> get messages => throw _privateConstructorUsedError;

  /// Serializes this ConversationWithMessagesDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConversationWithMessagesDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationWithMessagesDtoCopyWith<ConversationWithMessagesDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationWithMessagesDtoCopyWith<$Res> {
  factory $ConversationWithMessagesDtoCopyWith(
          ConversationWithMessagesDto value,
          $Res Function(ConversationWithMessagesDto) then) =
      _$ConversationWithMessagesDtoCopyWithImpl<$Res,
          ConversationWithMessagesDto>;
  @useResult
  $Res call({ConversationDto conversation, List<MessageDto> messages});

  $ConversationDtoCopyWith<$Res> get conversation;
}

/// @nodoc
class _$ConversationWithMessagesDtoCopyWithImpl<$Res,
        $Val extends ConversationWithMessagesDto>
    implements $ConversationWithMessagesDtoCopyWith<$Res> {
  _$ConversationWithMessagesDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationWithMessagesDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversation = null,
    Object? messages = null,
  }) {
    return _then(_value.copyWith(
      conversation: null == conversation
          ? _value.conversation
          : conversation // ignore: cast_nullable_to_non_nullable
              as ConversationDto,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<MessageDto>,
    ) as $Val);
  }

  /// Create a copy of ConversationWithMessagesDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConversationDtoCopyWith<$Res> get conversation {
    return $ConversationDtoCopyWith<$Res>(_value.conversation, (value) {
      return _then(_value.copyWith(conversation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConversationWithMessagesDtoImplCopyWith<$Res>
    implements $ConversationWithMessagesDtoCopyWith<$Res> {
  factory _$$ConversationWithMessagesDtoImplCopyWith(
          _$ConversationWithMessagesDtoImpl value,
          $Res Function(_$ConversationWithMessagesDtoImpl) then) =
      __$$ConversationWithMessagesDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ConversationDto conversation, List<MessageDto> messages});

  @override
  $ConversationDtoCopyWith<$Res> get conversation;
}

/// @nodoc
class __$$ConversationWithMessagesDtoImplCopyWithImpl<$Res>
    extends _$ConversationWithMessagesDtoCopyWithImpl<$Res,
        _$ConversationWithMessagesDtoImpl>
    implements _$$ConversationWithMessagesDtoImplCopyWith<$Res> {
  __$$ConversationWithMessagesDtoImplCopyWithImpl(
      _$ConversationWithMessagesDtoImpl _value,
      $Res Function(_$ConversationWithMessagesDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConversationWithMessagesDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversation = null,
    Object? messages = null,
  }) {
    return _then(_$ConversationWithMessagesDtoImpl(
      conversation: null == conversation
          ? _value.conversation
          : conversation // ignore: cast_nullable_to_non_nullable
              as ConversationDto,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<MessageDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationWithMessagesDtoImpl
    implements _ConversationWithMessagesDto {
  const _$ConversationWithMessagesDtoImpl(
      {required this.conversation, required final List<MessageDto> messages})
      : _messages = messages;

  factory _$ConversationWithMessagesDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ConversationWithMessagesDtoImplFromJson(json);

  @override
  final ConversationDto conversation;
  final List<MessageDto> _messages;
  @override
  List<MessageDto> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  String toString() {
    return 'ConversationWithMessagesDto(conversation: $conversation, messages: $messages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationWithMessagesDtoImpl &&
            (identical(other.conversation, conversation) ||
                other.conversation == conversation) &&
            const DeepCollectionEquality().equals(other._messages, _messages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, conversation,
      const DeepCollectionEquality().hash(_messages));

  /// Create a copy of ConversationWithMessagesDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationWithMessagesDtoImplCopyWith<_$ConversationWithMessagesDtoImpl>
      get copyWith => __$$ConversationWithMessagesDtoImplCopyWithImpl<
          _$ConversationWithMessagesDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationWithMessagesDtoImplToJson(
      this,
    );
  }
}

abstract class _ConversationWithMessagesDto
    implements ConversationWithMessagesDto {
  const factory _ConversationWithMessagesDto(
          {required final ConversationDto conversation,
          required final List<MessageDto> messages}) =
      _$ConversationWithMessagesDtoImpl;

  factory _ConversationWithMessagesDto.fromJson(Map<String, dynamic> json) =
      _$ConversationWithMessagesDtoImpl.fromJson;

  @override
  ConversationDto get conversation;
  @override
  List<MessageDto> get messages;

  /// Create a copy of ConversationWithMessagesDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationWithMessagesDtoImplCopyWith<_$ConversationWithMessagesDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ConversationListDto _$ConversationListDtoFromJson(Map<String, dynamic> json) {
  return _ConversationListDto.fromJson(json);
}

/// @nodoc
mixin _$ConversationListDto {
  List<ConversationDto> get conversations => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get offset => throw _privateConstructorUsedError;

  /// Serializes this ConversationListDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConversationListDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationListDtoCopyWith<ConversationListDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationListDtoCopyWith<$Res> {
  factory $ConversationListDtoCopyWith(
          ConversationListDto value, $Res Function(ConversationListDto) then) =
      _$ConversationListDtoCopyWithImpl<$Res, ConversationListDto>;
  @useResult
  $Res call(
      {List<ConversationDto> conversations, int total, int limit, int offset});
}

/// @nodoc
class _$ConversationListDtoCopyWithImpl<$Res, $Val extends ConversationListDto>
    implements $ConversationListDtoCopyWith<$Res> {
  _$ConversationListDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationListDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversations = null,
    Object? total = null,
    Object? limit = null,
    Object? offset = null,
  }) {
    return _then(_value.copyWith(
      conversations: null == conversations
          ? _value.conversations
          : conversations // ignore: cast_nullable_to_non_nullable
              as List<ConversationDto>,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationListDtoImplCopyWith<$Res>
    implements $ConversationListDtoCopyWith<$Res> {
  factory _$$ConversationListDtoImplCopyWith(_$ConversationListDtoImpl value,
          $Res Function(_$ConversationListDtoImpl) then) =
      __$$ConversationListDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ConversationDto> conversations, int total, int limit, int offset});
}

/// @nodoc
class __$$ConversationListDtoImplCopyWithImpl<$Res>
    extends _$ConversationListDtoCopyWithImpl<$Res, _$ConversationListDtoImpl>
    implements _$$ConversationListDtoImplCopyWith<$Res> {
  __$$ConversationListDtoImplCopyWithImpl(_$ConversationListDtoImpl _value,
      $Res Function(_$ConversationListDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConversationListDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversations = null,
    Object? total = null,
    Object? limit = null,
    Object? offset = null,
  }) {
    return _then(_$ConversationListDtoImpl(
      conversations: null == conversations
          ? _value._conversations
          : conversations // ignore: cast_nullable_to_non_nullable
              as List<ConversationDto>,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationListDtoImpl implements _ConversationListDto {
  const _$ConversationListDtoImpl(
      {required final List<ConversationDto> conversations,
      required this.total,
      required this.limit,
      required this.offset})
      : _conversations = conversations;

  factory _$ConversationListDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationListDtoImplFromJson(json);

  final List<ConversationDto> _conversations;
  @override
  List<ConversationDto> get conversations {
    if (_conversations is EqualUnmodifiableListView) return _conversations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conversations);
  }

  @override
  final int total;
  @override
  final int limit;
  @override
  final int offset;

  @override
  String toString() {
    return 'ConversationListDto(conversations: $conversations, total: $total, limit: $limit, offset: $offset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationListDtoImpl &&
            const DeepCollectionEquality()
                .equals(other._conversations, _conversations) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_conversations),
      total,
      limit,
      offset);

  /// Create a copy of ConversationListDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationListDtoImplCopyWith<_$ConversationListDtoImpl> get copyWith =>
      __$$ConversationListDtoImplCopyWithImpl<_$ConversationListDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationListDtoImplToJson(
      this,
    );
  }
}

abstract class _ConversationListDto implements ConversationListDto {
  const factory _ConversationListDto(
      {required final List<ConversationDto> conversations,
      required final int total,
      required final int limit,
      required final int offset}) = _$ConversationListDtoImpl;

  factory _ConversationListDto.fromJson(Map<String, dynamic> json) =
      _$ConversationListDtoImpl.fromJson;

  @override
  List<ConversationDto> get conversations;
  @override
  int get total;
  @override
  int get limit;
  @override
  int get offset;

  /// Create a copy of ConversationListDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationListDtoImplCopyWith<_$ConversationListDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WelcomeMessageDto _$WelcomeMessageDtoFromJson(Map<String, dynamic> json) {
  return _WelcomeMessageDto.fromJson(json);
}

/// @nodoc
mixin _$WelcomeMessageDto {
  String get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversation_starters')
  List<String> get conversationStarters => throw _privateConstructorUsedError;

  /// Serializes this WelcomeMessageDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WelcomeMessageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WelcomeMessageDtoCopyWith<WelcomeMessageDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WelcomeMessageDtoCopyWith<$Res> {
  factory $WelcomeMessageDtoCopyWith(
          WelcomeMessageDto value, $Res Function(WelcomeMessageDto) then) =
      _$WelcomeMessageDtoCopyWithImpl<$Res, WelcomeMessageDto>;
  @useResult
  $Res call(
      {String message,
      @JsonKey(name: 'conversation_starters')
      List<String> conversationStarters});
}

/// @nodoc
class _$WelcomeMessageDtoCopyWithImpl<$Res, $Val extends WelcomeMessageDto>
    implements $WelcomeMessageDtoCopyWith<$Res> {
  _$WelcomeMessageDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WelcomeMessageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? conversationStarters = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      conversationStarters: null == conversationStarters
          ? _value.conversationStarters
          : conversationStarters // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WelcomeMessageDtoImplCopyWith<$Res>
    implements $WelcomeMessageDtoCopyWith<$Res> {
  factory _$$WelcomeMessageDtoImplCopyWith(_$WelcomeMessageDtoImpl value,
          $Res Function(_$WelcomeMessageDtoImpl) then) =
      __$$WelcomeMessageDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String message,
      @JsonKey(name: 'conversation_starters')
      List<String> conversationStarters});
}

/// @nodoc
class __$$WelcomeMessageDtoImplCopyWithImpl<$Res>
    extends _$WelcomeMessageDtoCopyWithImpl<$Res, _$WelcomeMessageDtoImpl>
    implements _$$WelcomeMessageDtoImplCopyWith<$Res> {
  __$$WelcomeMessageDtoImplCopyWithImpl(_$WelcomeMessageDtoImpl _value,
      $Res Function(_$WelcomeMessageDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of WelcomeMessageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? conversationStarters = null,
  }) {
    return _then(_$WelcomeMessageDtoImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      conversationStarters: null == conversationStarters
          ? _value._conversationStarters
          : conversationStarters // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WelcomeMessageDtoImpl implements _WelcomeMessageDto {
  const _$WelcomeMessageDtoImpl(
      {required this.message,
      @JsonKey(name: 'conversation_starters')
      required final List<String> conversationStarters})
      : _conversationStarters = conversationStarters;

  factory _$WelcomeMessageDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WelcomeMessageDtoImplFromJson(json);

  @override
  final String message;
  final List<String> _conversationStarters;
  @override
  @JsonKey(name: 'conversation_starters')
  List<String> get conversationStarters {
    if (_conversationStarters is EqualUnmodifiableListView)
      return _conversationStarters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conversationStarters);
  }

  @override
  String toString() {
    return 'WelcomeMessageDto(message: $message, conversationStarters: $conversationStarters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WelcomeMessageDtoImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other._conversationStarters, _conversationStarters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message,
      const DeepCollectionEquality().hash(_conversationStarters));

  /// Create a copy of WelcomeMessageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WelcomeMessageDtoImplCopyWith<_$WelcomeMessageDtoImpl> get copyWith =>
      __$$WelcomeMessageDtoImplCopyWithImpl<_$WelcomeMessageDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WelcomeMessageDtoImplToJson(
      this,
    );
  }
}

abstract class _WelcomeMessageDto implements WelcomeMessageDto {
  const factory _WelcomeMessageDto(
          {required final String message,
          @JsonKey(name: 'conversation_starters')
          required final List<String> conversationStarters}) =
      _$WelcomeMessageDtoImpl;

  factory _WelcomeMessageDto.fromJson(Map<String, dynamic> json) =
      _$WelcomeMessageDtoImpl.fromJson;

  @override
  String get message;
  @override
  @JsonKey(name: 'conversation_starters')
  List<String> get conversationStarters;

  /// Create a copy of WelcomeMessageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WelcomeMessageDtoImplCopyWith<_$WelcomeMessageDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateConversationRequestDto _$CreateConversationRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _CreateConversationRequestDto.fromJson(json);
}

/// @nodoc
mixin _$CreateConversationRequestDto {
  String get title => throw _privateConstructorUsedError;

  /// Serializes this CreateConversationRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateConversationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateConversationRequestDtoCopyWith<CreateConversationRequestDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateConversationRequestDtoCopyWith<$Res> {
  factory $CreateConversationRequestDtoCopyWith(
          CreateConversationRequestDto value,
          $Res Function(CreateConversationRequestDto) then) =
      _$CreateConversationRequestDtoCopyWithImpl<$Res,
          CreateConversationRequestDto>;
  @useResult
  $Res call({String title});
}

/// @nodoc
class _$CreateConversationRequestDtoCopyWithImpl<$Res,
        $Val extends CreateConversationRequestDto>
    implements $CreateConversationRequestDtoCopyWith<$Res> {
  _$CreateConversationRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateConversationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateConversationRequestDtoImplCopyWith<$Res>
    implements $CreateConversationRequestDtoCopyWith<$Res> {
  factory _$$CreateConversationRequestDtoImplCopyWith(
          _$CreateConversationRequestDtoImpl value,
          $Res Function(_$CreateConversationRequestDtoImpl) then) =
      __$$CreateConversationRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title});
}

/// @nodoc
class __$$CreateConversationRequestDtoImplCopyWithImpl<$Res>
    extends _$CreateConversationRequestDtoCopyWithImpl<$Res,
        _$CreateConversationRequestDtoImpl>
    implements _$$CreateConversationRequestDtoImplCopyWith<$Res> {
  __$$CreateConversationRequestDtoImplCopyWithImpl(
      _$CreateConversationRequestDtoImpl _value,
      $Res Function(_$CreateConversationRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateConversationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
  }) {
    return _then(_$CreateConversationRequestDtoImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateConversationRequestDtoImpl
    implements _CreateConversationRequestDto {
  const _$CreateConversationRequestDtoImpl({required this.title});

  factory _$CreateConversationRequestDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CreateConversationRequestDtoImplFromJson(json);

  @override
  final String title;

  @override
  String toString() {
    return 'CreateConversationRequestDto(title: $title)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateConversationRequestDtoImpl &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title);

  /// Create a copy of CreateConversationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateConversationRequestDtoImplCopyWith<
          _$CreateConversationRequestDtoImpl>
      get copyWith => __$$CreateConversationRequestDtoImplCopyWithImpl<
          _$CreateConversationRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateConversationRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _CreateConversationRequestDto
    implements CreateConversationRequestDto {
  const factory _CreateConversationRequestDto({required final String title}) =
      _$CreateConversationRequestDtoImpl;

  factory _CreateConversationRequestDto.fromJson(Map<String, dynamic> json) =
      _$CreateConversationRequestDtoImpl.fromJson;

  @override
  String get title;

  /// Create a copy of CreateConversationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateConversationRequestDtoImplCopyWith<
          _$CreateConversationRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpdateConversationRequestDto _$UpdateConversationRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _UpdateConversationRequestDto.fromJson(json);
}

/// @nodoc
mixin _$UpdateConversationRequestDto {
  String get title => throw _privateConstructorUsedError;

  /// Serializes this UpdateConversationRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateConversationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateConversationRequestDtoCopyWith<UpdateConversationRequestDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateConversationRequestDtoCopyWith<$Res> {
  factory $UpdateConversationRequestDtoCopyWith(
          UpdateConversationRequestDto value,
          $Res Function(UpdateConversationRequestDto) then) =
      _$UpdateConversationRequestDtoCopyWithImpl<$Res,
          UpdateConversationRequestDto>;
  @useResult
  $Res call({String title});
}

/// @nodoc
class _$UpdateConversationRequestDtoCopyWithImpl<$Res,
        $Val extends UpdateConversationRequestDto>
    implements $UpdateConversationRequestDtoCopyWith<$Res> {
  _$UpdateConversationRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateConversationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateConversationRequestDtoImplCopyWith<$Res>
    implements $UpdateConversationRequestDtoCopyWith<$Res> {
  factory _$$UpdateConversationRequestDtoImplCopyWith(
          _$UpdateConversationRequestDtoImpl value,
          $Res Function(_$UpdateConversationRequestDtoImpl) then) =
      __$$UpdateConversationRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title});
}

/// @nodoc
class __$$UpdateConversationRequestDtoImplCopyWithImpl<$Res>
    extends _$UpdateConversationRequestDtoCopyWithImpl<$Res,
        _$UpdateConversationRequestDtoImpl>
    implements _$$UpdateConversationRequestDtoImplCopyWith<$Res> {
  __$$UpdateConversationRequestDtoImplCopyWithImpl(
      _$UpdateConversationRequestDtoImpl _value,
      $Res Function(_$UpdateConversationRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateConversationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
  }) {
    return _then(_$UpdateConversationRequestDtoImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateConversationRequestDtoImpl
    implements _UpdateConversationRequestDto {
  const _$UpdateConversationRequestDtoImpl({required this.title});

  factory _$UpdateConversationRequestDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UpdateConversationRequestDtoImplFromJson(json);

  @override
  final String title;

  @override
  String toString() {
    return 'UpdateConversationRequestDto(title: $title)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateConversationRequestDtoImpl &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title);

  /// Create a copy of UpdateConversationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateConversationRequestDtoImplCopyWith<
          _$UpdateConversationRequestDtoImpl>
      get copyWith => __$$UpdateConversationRequestDtoImplCopyWithImpl<
          _$UpdateConversationRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateConversationRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _UpdateConversationRequestDto
    implements UpdateConversationRequestDto {
  const factory _UpdateConversationRequestDto({required final String title}) =
      _$UpdateConversationRequestDtoImpl;

  factory _UpdateConversationRequestDto.fromJson(Map<String, dynamic> json) =
      _$UpdateConversationRequestDtoImpl.fromJson;

  @override
  String get title;

  /// Create a copy of UpdateConversationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateConversationRequestDtoImplCopyWith<
          _$UpdateConversationRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
