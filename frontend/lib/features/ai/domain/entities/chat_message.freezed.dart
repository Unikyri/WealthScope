// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatMessage {
  String get id;
  String get role; // 'user' or 'assistant'
  String get content;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      _$ChatMessageCopyWithImpl<ChatMessage>(this as ChatMessage, _$identity);

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatMessage &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, role, content, createdAt);

  @override
  String toString() {
    return 'ChatMessage(id: $id, role: $role, content: $content, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
          ChatMessage value, $Res Function(ChatMessage) _then) =
      _$ChatMessageCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String role,
      String content,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res> implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._self, this._then);

  final ChatMessage _self;
  final $Res Function(ChatMessage) _then;

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
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
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
    TResult Function(_ChatMessage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatMessage() when $default != null:
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
    TResult Function(_ChatMessage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessage():
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
    TResult? Function(_ChatMessage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessage() when $default != null:
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
    TResult Function(String id, String role, String content,
            @JsonKey(name: 'created_at') DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatMessage() when $default != null:
        return $default(_that.id, _that.role, _that.content, _that.createdAt);
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
    TResult Function(String id, String role, String content,
            @JsonKey(name: 'created_at') DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessage():
        return $default(_that.id, _that.role, _that.content, _that.createdAt);
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
    TResult? Function(String id, String role, String content,
            @JsonKey(name: 'created_at') DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessage() when $default != null:
        return $default(_that.id, _that.role, _that.content, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ChatMessage implements ChatMessage {
  const _ChatMessage(
      {required this.id,
      required this.role,
      required this.content,
      @JsonKey(name: 'created_at') required this.createdAt});
  factory _ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

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

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChatMessageCopyWith<_ChatMessage> get copyWith =>
      __$ChatMessageCopyWithImpl<_ChatMessage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ChatMessageToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChatMessage &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, role, content, createdAt);

  @override
  String toString() {
    return 'ChatMessage(id: $id, role: $role, content: $content, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$ChatMessageCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$ChatMessageCopyWith(
          _ChatMessage value, $Res Function(_ChatMessage) _then) =
      __$ChatMessageCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String role,
      String content,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$ChatMessageCopyWithImpl<$Res> implements _$ChatMessageCopyWith<$Res> {
  __$ChatMessageCopyWithImpl(this._self, this._then);

  final _ChatMessage _self;
  final $Res Function(_ChatMessage) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? createdAt = null,
  }) {
    return _then(_ChatMessage(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$ChatResponse {
  ChatMessage get userMessage;
  ChatMessage get aiMessage;
  String get conversationId;
  int? get tokensUsed;

  /// Create a copy of ChatResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatResponseCopyWith<ChatResponse> get copyWith =>
      _$ChatResponseCopyWithImpl<ChatResponse>(
          this as ChatResponse, _$identity);

  /// Serializes this ChatResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatResponse &&
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

  @override
  String toString() {
    return 'ChatResponse(userMessage: $userMessage, aiMessage: $aiMessage, conversationId: $conversationId, tokensUsed: $tokensUsed)';
  }
}

/// @nodoc
abstract mixin class $ChatResponseCopyWith<$Res> {
  factory $ChatResponseCopyWith(
          ChatResponse value, $Res Function(ChatResponse) _then) =
      _$ChatResponseCopyWithImpl;
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
class _$ChatResponseCopyWithImpl<$Res> implements $ChatResponseCopyWith<$Res> {
  _$ChatResponseCopyWithImpl(this._self, this._then);

  final ChatResponse _self;
  final $Res Function(ChatResponse) _then;

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
    return _then(_self.copyWith(
      userMessage: null == userMessage
          ? _self.userMessage
          : userMessage // ignore: cast_nullable_to_non_nullable
              as ChatMessage,
      aiMessage: null == aiMessage
          ? _self.aiMessage
          : aiMessage // ignore: cast_nullable_to_non_nullable
              as ChatMessage,
      conversationId: null == conversationId
          ? _self.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      tokensUsed: freezed == tokensUsed
          ? _self.tokensUsed
          : tokensUsed // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of ChatResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatMessageCopyWith<$Res> get userMessage {
    return $ChatMessageCopyWith<$Res>(_self.userMessage, (value) {
      return _then(_self.copyWith(userMessage: value));
    });
  }

  /// Create a copy of ChatResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatMessageCopyWith<$Res> get aiMessage {
    return $ChatMessageCopyWith<$Res>(_self.aiMessage, (value) {
      return _then(_self.copyWith(aiMessage: value));
    });
  }
}

/// Adds pattern-matching-related methods to [ChatResponse].
extension ChatResponsePatterns on ChatResponse {
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
    TResult Function(_ChatResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatResponse() when $default != null:
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
    TResult Function(_ChatResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatResponse():
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
    TResult? Function(_ChatResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatResponse() when $default != null:
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
    TResult Function(ChatMessage userMessage, ChatMessage aiMessage,
            String conversationId, int? tokensUsed)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatResponse() when $default != null:
        return $default(_that.userMessage, _that.aiMessage,
            _that.conversationId, _that.tokensUsed);
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
    TResult Function(ChatMessage userMessage, ChatMessage aiMessage,
            String conversationId, int? tokensUsed)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatResponse():
        return $default(_that.userMessage, _that.aiMessage,
            _that.conversationId, _that.tokensUsed);
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
    TResult? Function(ChatMessage userMessage, ChatMessage aiMessage,
            String conversationId, int? tokensUsed)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatResponse() when $default != null:
        return $default(_that.userMessage, _that.aiMessage,
            _that.conversationId, _that.tokensUsed);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ChatResponse implements ChatResponse {
  const _ChatResponse(
      {required this.userMessage,
      required this.aiMessage,
      required this.conversationId,
      this.tokensUsed});
  factory _ChatResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseFromJson(json);

  @override
  final ChatMessage userMessage;
  @override
  final ChatMessage aiMessage;
  @override
  final String conversationId;
  @override
  final int? tokensUsed;

  /// Create a copy of ChatResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChatResponseCopyWith<_ChatResponse> get copyWith =>
      __$ChatResponseCopyWithImpl<_ChatResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ChatResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChatResponse &&
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

  @override
  String toString() {
    return 'ChatResponse(userMessage: $userMessage, aiMessage: $aiMessage, conversationId: $conversationId, tokensUsed: $tokensUsed)';
  }
}

/// @nodoc
abstract mixin class _$ChatResponseCopyWith<$Res>
    implements $ChatResponseCopyWith<$Res> {
  factory _$ChatResponseCopyWith(
          _ChatResponse value, $Res Function(_ChatResponse) _then) =
      __$ChatResponseCopyWithImpl;
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
class __$ChatResponseCopyWithImpl<$Res>
    implements _$ChatResponseCopyWith<$Res> {
  __$ChatResponseCopyWithImpl(this._self, this._then);

  final _ChatResponse _self;
  final $Res Function(_ChatResponse) _then;

  /// Create a copy of ChatResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userMessage = null,
    Object? aiMessage = null,
    Object? conversationId = null,
    Object? tokensUsed = freezed,
  }) {
    return _then(_ChatResponse(
      userMessage: null == userMessage
          ? _self.userMessage
          : userMessage // ignore: cast_nullable_to_non_nullable
              as ChatMessage,
      aiMessage: null == aiMessage
          ? _self.aiMessage
          : aiMessage // ignore: cast_nullable_to_non_nullable
              as ChatMessage,
      conversationId: null == conversationId
          ? _self.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      tokensUsed: freezed == tokensUsed
          ? _self.tokensUsed
          : tokensUsed // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of ChatResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatMessageCopyWith<$Res> get userMessage {
    return $ChatMessageCopyWith<$Res>(_self.userMessage, (value) {
      return _then(_self.copyWith(userMessage: value));
    });
  }

  /// Create a copy of ChatResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatMessageCopyWith<$Res> get aiMessage {
    return $ChatMessageCopyWith<$Res>(_self.aiMessage, (value) {
      return _then(_self.copyWith(aiMessage: value));
    });
  }
}

/// @nodoc
mixin _$InsightsResponse {
  String get summary;
  List<String> get keyPoints;
  String? get briefing;
  double? get sentimentScore;
  String? get sentimentTrend;

  /// Create a copy of InsightsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InsightsResponseCopyWith<InsightsResponse> get copyWith =>
      _$InsightsResponseCopyWithImpl<InsightsResponse>(
          this as InsightsResponse, _$identity);

  /// Serializes this InsightsResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InsightsResponse &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(other.keyPoints, keyPoints) &&
            (identical(other.briefing, briefing) ||
                other.briefing == briefing) &&
            (identical(other.sentimentScore, sentimentScore) ||
                other.sentimentScore == sentimentScore) &&
            (identical(other.sentimentTrend, sentimentTrend) ||
                other.sentimentTrend == sentimentTrend));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      summary,
      const DeepCollectionEquality().hash(keyPoints),
      briefing,
      sentimentScore,
      sentimentTrend);

  @override
  String toString() {
    return 'InsightsResponse(summary: $summary, keyPoints: $keyPoints, briefing: $briefing, sentimentScore: $sentimentScore, sentimentTrend: $sentimentTrend)';
  }
}

/// @nodoc
abstract mixin class $InsightsResponseCopyWith<$Res> {
  factory $InsightsResponseCopyWith(
          InsightsResponse value, $Res Function(InsightsResponse) _then) =
      _$InsightsResponseCopyWithImpl;
  @useResult
  $Res call(
      {String summary,
      List<String> keyPoints,
      String? briefing,
      double? sentimentScore,
      String? sentimentTrend});
}

/// @nodoc
class _$InsightsResponseCopyWithImpl<$Res>
    implements $InsightsResponseCopyWith<$Res> {
  _$InsightsResponseCopyWithImpl(this._self, this._then);

  final InsightsResponse _self;
  final $Res Function(InsightsResponse) _then;

  /// Create a copy of InsightsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? keyPoints = null,
    Object? briefing = freezed,
    Object? sentimentScore = freezed,
    Object? sentimentTrend = freezed,
  }) {
    return _then(_self.copyWith(
      summary: null == summary
          ? _self.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      keyPoints: null == keyPoints
          ? _self.keyPoints
          : keyPoints // ignore: cast_nullable_to_non_nullable
              as List<String>,
      briefing: freezed == briefing
          ? _self.briefing
          : briefing // ignore: cast_nullable_to_non_nullable
              as String?,
      sentimentScore: freezed == sentimentScore
          ? _self.sentimentScore
          : sentimentScore // ignore: cast_nullable_to_non_nullable
              as double?,
      sentimentTrend: freezed == sentimentTrend
          ? _self.sentimentTrend
          : sentimentTrend // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [InsightsResponse].
extension InsightsResponsePatterns on InsightsResponse {
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
    TResult Function(_InsightsResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InsightsResponse() when $default != null:
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
    TResult Function(_InsightsResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsightsResponse():
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
    TResult? Function(_InsightsResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsightsResponse() when $default != null:
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
    TResult Function(String summary, List<String> keyPoints, String? briefing,
            double? sentimentScore, String? sentimentTrend)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InsightsResponse() when $default != null:
        return $default(_that.summary, _that.keyPoints, _that.briefing,
            _that.sentimentScore, _that.sentimentTrend);
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
    TResult Function(String summary, List<String> keyPoints, String? briefing,
            double? sentimentScore, String? sentimentTrend)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsightsResponse():
        return $default(_that.summary, _that.keyPoints, _that.briefing,
            _that.sentimentScore, _that.sentimentTrend);
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
    TResult? Function(String summary, List<String> keyPoints, String? briefing,
            double? sentimentScore, String? sentimentTrend)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsightsResponse() when $default != null:
        return $default(_that.summary, _that.keyPoints, _that.briefing,
            _that.sentimentScore, _that.sentimentTrend);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _InsightsResponse implements InsightsResponse {
  const _InsightsResponse(
      {required this.summary,
      required final List<String> keyPoints,
      this.briefing,
      this.sentimentScore,
      this.sentimentTrend})
      : _keyPoints = keyPoints;
  factory _InsightsResponse.fromJson(Map<String, dynamic> json) =>
      _$InsightsResponseFromJson(json);

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
  final double? sentimentScore;
  @override
  final String? sentimentTrend;

  /// Create a copy of InsightsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InsightsResponseCopyWith<_InsightsResponse> get copyWith =>
      __$InsightsResponseCopyWithImpl<_InsightsResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$InsightsResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InsightsResponse &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality()
                .equals(other._keyPoints, _keyPoints) &&
            (identical(other.briefing, briefing) ||
                other.briefing == briefing) &&
            (identical(other.sentimentScore, sentimentScore) ||
                other.sentimentScore == sentimentScore) &&
            (identical(other.sentimentTrend, sentimentTrend) ||
                other.sentimentTrend == sentimentTrend));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      summary,
      const DeepCollectionEquality().hash(_keyPoints),
      briefing,
      sentimentScore,
      sentimentTrend);

  @override
  String toString() {
    return 'InsightsResponse(summary: $summary, keyPoints: $keyPoints, briefing: $briefing, sentimentScore: $sentimentScore, sentimentTrend: $sentimentTrend)';
  }
}

/// @nodoc
abstract mixin class _$InsightsResponseCopyWith<$Res>
    implements $InsightsResponseCopyWith<$Res> {
  factory _$InsightsResponseCopyWith(
          _InsightsResponse value, $Res Function(_InsightsResponse) _then) =
      __$InsightsResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String summary,
      List<String> keyPoints,
      String? briefing,
      double? sentimentScore,
      String? sentimentTrend});
}

/// @nodoc
class __$InsightsResponseCopyWithImpl<$Res>
    implements _$InsightsResponseCopyWith<$Res> {
  __$InsightsResponseCopyWithImpl(this._self, this._then);

  final _InsightsResponse _self;
  final $Res Function(_InsightsResponse) _then;

  /// Create a copy of InsightsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? summary = null,
    Object? keyPoints = null,
    Object? briefing = freezed,
    Object? sentimentScore = freezed,
    Object? sentimentTrend = freezed,
  }) {
    return _then(_InsightsResponse(
      summary: null == summary
          ? _self.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      keyPoints: null == keyPoints
          ? _self._keyPoints
          : keyPoints // ignore: cast_nullable_to_non_nullable
              as List<String>,
      briefing: freezed == briefing
          ? _self.briefing
          : briefing // ignore: cast_nullable_to_non_nullable
              as String?,
      sentimentScore: freezed == sentimentScore
          ? _self.sentimentScore
          : sentimentScore // ignore: cast_nullable_to_non_nullable
              as double?,
      sentimentTrend: freezed == sentimentTrend
          ? _self.sentimentTrend
          : sentimentTrend // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
