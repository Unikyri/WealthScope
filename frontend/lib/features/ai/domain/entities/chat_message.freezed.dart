// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
mixin _$ChatMessage {
  String get id => throw _privateConstructorUsedError;
  String get role =>
      throw _privateConstructorUsedError; // 'user' or 'assistant'
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
          ChatMessage value, $Res Function(ChatMessage) then) =
      _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call(
      {String id,
      String role,
      String content,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatMessageImplCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(
          _$ChatMessageImpl value, $Res Function(_$ChatMessageImpl) then) =
      __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String role,
      String content,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res>
    extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl>
    implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(
      _$ChatMessageImpl _value, $Res Function(_$ChatMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? createdAt = null,
  }) {
    return _then(_$ChatMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageImpl implements _ChatMessage {
  const _$ChatMessageImpl(
      {required this.id,
      required this.role,
      required this.content,
      @JsonKey(name: 'created_at') required this.createdAt});

  factory _$ChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String role;
// 'user' or 'assistant'
  @override
  final String content;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'ChatMessage(id: $id, role: $role, content: $content, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, role, content, createdAt);

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageImplToJson(
      this,
    );
  }
}

abstract class _ChatMessage implements ChatMessage {
  const factory _ChatMessage(
          {required final String id,
          required final String role,
          required final String content,
          @JsonKey(name: 'created_at') required final DateTime createdAt}) =
      _$ChatMessageImpl;

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$ChatMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get role; // 'user' or 'assistant'
  @override
  String get content;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatResponse _$ChatResponseFromJson(Map<String, dynamic> json) {
  return _ChatResponse.fromJson(json);
}

/// @nodoc
mixin _$ChatResponse {
  ChatMessage get userMessage => throw _privateConstructorUsedError;
  ChatMessage get aiMessage => throw _privateConstructorUsedError;
  String get conversationId => throw _privateConstructorUsedError;
  int? get tokensUsed => throw _privateConstructorUsedError;

  /// Serializes this ChatResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatResponseCopyWith<ChatResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatResponseCopyWith<$Res> {
  factory $ChatResponseCopyWith(
          ChatResponse value, $Res Function(ChatResponse) then) =
      _$ChatResponseCopyWithImpl<$Res, ChatResponse>;
  @useResult
  $Res call(
      {ChatMessage userMessage,
      ChatMessage aiMessage,
      String conversationId,
      int? tokensUsed});

  $ChatMessageCopyWith<$Res> get userMessage;
  $ChatMessageCopyWith<$Res> get aiMessage;
}

/// @nodoc
class _$ChatResponseCopyWithImpl<$Res, $Val extends ChatResponse>
    implements $ChatResponseCopyWith<$Res> {
  _$ChatResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userMessage = null,
    Object? aiMessage = null,
    Object? conversationId = null,
    Object? tokensUsed = freezed,
  }) {
    return _then(_value.copyWith(
      userMessage: null == userMessage
          ? _value.userMessage
          : userMessage // ignore: cast_nullable_to_non_nullable
              as ChatMessage,
      aiMessage: null == aiMessage
          ? _value.aiMessage
          : aiMessage // ignore: cast_nullable_to_non_nullable
              as ChatMessage,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      tokensUsed: freezed == tokensUsed
          ? _value.tokensUsed
          : tokensUsed // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of ChatResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatMessageCopyWith<$Res> get userMessage {
    return $ChatMessageCopyWith<$Res>(_value.userMessage, (value) {
      return _then(_value.copyWith(userMessage: value) as $Val);
    });
  }

  /// Create a copy of ChatResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatMessageCopyWith<$Res> get aiMessage {
    return $ChatMessageCopyWith<$Res>(_value.aiMessage, (value) {
      return _then(_value.copyWith(aiMessage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatResponseImplCopyWith<$Res>
    implements $ChatResponseCopyWith<$Res> {
  factory _$$ChatResponseImplCopyWith(
          _$ChatResponseImpl value, $Res Function(_$ChatResponseImpl) then) =
      __$$ChatResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ChatMessage userMessage,
      ChatMessage aiMessage,
      String conversationId,
      int? tokensUsed});

  @override
  $ChatMessageCopyWith<$Res> get userMessage;
  @override
  $ChatMessageCopyWith<$Res> get aiMessage;
}

/// @nodoc
class __$$ChatResponseImplCopyWithImpl<$Res>
    extends _$ChatResponseCopyWithImpl<$Res, _$ChatResponseImpl>
    implements _$$ChatResponseImplCopyWith<$Res> {
  __$$ChatResponseImplCopyWithImpl(
      _$ChatResponseImpl _value, $Res Function(_$ChatResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userMessage = null,
    Object? aiMessage = null,
    Object? conversationId = null,
    Object? tokensUsed = freezed,
  }) {
    return _then(_$ChatResponseImpl(
      userMessage: null == userMessage
          ? _value.userMessage
          : userMessage // ignore: cast_nullable_to_non_nullable
              as ChatMessage,
      aiMessage: null == aiMessage
          ? _value.aiMessage
          : aiMessage // ignore: cast_nullable_to_non_nullable
              as ChatMessage,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      tokensUsed: freezed == tokensUsed
          ? _value.tokensUsed
          : tokensUsed // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatResponseImpl implements _ChatResponse {
  const _$ChatResponseImpl(
      {required this.userMessage,
      required this.aiMessage,
      required this.conversationId,
      this.tokensUsed});

  factory _$ChatResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatResponseImplFromJson(json);

  @override
  final ChatMessage userMessage;
  @override
  final ChatMessage aiMessage;
  @override
  final String conversationId;
  @override
  final int? tokensUsed;

  @override
  String toString() {
    return 'ChatResponse(userMessage: $userMessage, aiMessage: $aiMessage, conversationId: $conversationId, tokensUsed: $tokensUsed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatResponseImpl &&
            (identical(other.userMessage, userMessage) ||
                other.userMessage == userMessage) &&
            (identical(other.aiMessage, aiMessage) ||
                other.aiMessage == aiMessage) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.tokensUsed, tokensUsed) ||
                other.tokensUsed == tokensUsed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, userMessage, aiMessage, conversationId, tokensUsed);

  /// Create a copy of ChatResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatResponseImplCopyWith<_$ChatResponseImpl> get copyWith =>
      __$$ChatResponseImplCopyWithImpl<_$ChatResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatResponseImplToJson(
      this,
    );
  }
}

abstract class _ChatResponse implements ChatResponse {
  const factory _ChatResponse(
      {required final ChatMessage userMessage,
      required final ChatMessage aiMessage,
      required final String conversationId,
      final int? tokensUsed}) = _$ChatResponseImpl;

  factory _ChatResponse.fromJson(Map<String, dynamic> json) =
      _$ChatResponseImpl.fromJson;

  @override
  ChatMessage get userMessage;
  @override
  ChatMessage get aiMessage;
  @override
  String get conversationId;
  @override
  int? get tokensUsed;

  /// Create a copy of ChatResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatResponseImplCopyWith<_$ChatResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InsightsResponse _$InsightsResponseFromJson(Map<String, dynamic> json) {
  return _InsightsResponse.fromJson(json);
}

/// @nodoc
mixin _$InsightsResponse {
  String get summary => throw _privateConstructorUsedError;
  List<String> get keyPoints => throw _privateConstructorUsedError;
  String? get briefing => throw _privateConstructorUsedError;

  /// Serializes this InsightsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InsightsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InsightsResponseCopyWith<InsightsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsightsResponseCopyWith<$Res> {
  factory $InsightsResponseCopyWith(
          InsightsResponse value, $Res Function(InsightsResponse) then) =
      _$InsightsResponseCopyWithImpl<$Res, InsightsResponse>;
  @useResult
  $Res call({String summary, List<String> keyPoints, String? briefing});
}

/// @nodoc
class _$InsightsResponseCopyWithImpl<$Res, $Val extends InsightsResponse>
    implements $InsightsResponseCopyWith<$Res> {
  _$InsightsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InsightsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? keyPoints = null,
    Object? briefing = freezed,
  }) {
    return _then(_value.copyWith(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      keyPoints: null == keyPoints
          ? _value.keyPoints
          : keyPoints // ignore: cast_nullable_to_non_nullable
              as List<String>,
      briefing: freezed == briefing
          ? _value.briefing
          : briefing // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InsightsResponseImplCopyWith<$Res>
    implements $InsightsResponseCopyWith<$Res> {
  factory _$$InsightsResponseImplCopyWith(_$InsightsResponseImpl value,
          $Res Function(_$InsightsResponseImpl) then) =
      __$$InsightsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String summary, List<String> keyPoints, String? briefing});
}

/// @nodoc
class __$$InsightsResponseImplCopyWithImpl<$Res>
    extends _$InsightsResponseCopyWithImpl<$Res, _$InsightsResponseImpl>
    implements _$$InsightsResponseImplCopyWith<$Res> {
  __$$InsightsResponseImplCopyWithImpl(_$InsightsResponseImpl _value,
      $Res Function(_$InsightsResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of InsightsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? keyPoints = null,
    Object? briefing = freezed,
  }) {
    return _then(_$InsightsResponseImpl(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      keyPoints: null == keyPoints
          ? _value._keyPoints
          : keyPoints // ignore: cast_nullable_to_non_nullable
              as List<String>,
      briefing: freezed == briefing
          ? _value.briefing
          : briefing // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InsightsResponseImpl implements _InsightsResponse {
  const _$InsightsResponseImpl(
      {required this.summary,
      required final List<String> keyPoints,
      this.briefing})
      : _keyPoints = keyPoints;

  factory _$InsightsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$InsightsResponseImplFromJson(json);

  @override
  final String summary;
  final List<String> _keyPoints;
  @override
  List<String> get keyPoints {
    if (_keyPoints is EqualUnmodifiableListView) return _keyPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keyPoints);
  }

  @override
  final String? briefing;

  @override
  String toString() {
    return 'InsightsResponse(summary: $summary, keyPoints: $keyPoints, briefing: $briefing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightsResponseImpl &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality()
                .equals(other._keyPoints, _keyPoints) &&
            (identical(other.briefing, briefing) ||
                other.briefing == briefing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, summary,
      const DeepCollectionEquality().hash(_keyPoints), briefing);

  /// Create a copy of InsightsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightsResponseImplCopyWith<_$InsightsResponseImpl> get copyWith =>
      __$$InsightsResponseImplCopyWithImpl<_$InsightsResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InsightsResponseImplToJson(
      this,
    );
  }
}

abstract class _InsightsResponse implements InsightsResponse {
  const factory _InsightsResponse(
      {required final String summary,
      required final List<String> keyPoints,
      final String? briefing}) = _$InsightsResponseImpl;

  factory _InsightsResponse.fromJson(Map<String, dynamic> json) =
      _$InsightsResponseImpl.fromJson;

  @override
  String get summary;
  @override
  List<String> get keyPoints;
  @override
  String? get briefing;

  /// Create a copy of InsightsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsightsResponseImplCopyWith<_$InsightsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
