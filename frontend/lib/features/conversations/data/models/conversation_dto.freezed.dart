// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConversationDto {
  String get id;
  String get title;
  @JsonKey(name: 'created_at')
  String get createdAt;
  @JsonKey(name: 'updated_at')
  String get updatedAt;

  /// Create a copy of ConversationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConversationDtoCopyWith<ConversationDto> get copyWith =>
      _$ConversationDtoCopyWithImpl<ConversationDto>(
          this as ConversationDto, _$identity);

  /// Serializes this ConversationDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConversationDto &&
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

  @override
  String toString() {
    return 'ConversationDto(id: $id, title: $title, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $ConversationDtoCopyWith<$Res> {
  factory $ConversationDtoCopyWith(
          ConversationDto value, $Res Function(ConversationDto) _then) =
      _$ConversationDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String title,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt});
}

/// @nodoc
class _$ConversationDtoCopyWithImpl<$Res>
    implements $ConversationDtoCopyWith<$Res> {
  _$ConversationDtoCopyWithImpl(this._self, this._then);

  final ConversationDto _self;
  final $Res Function(ConversationDto) _then;

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
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [ConversationDto].
extension ConversationDtoPatterns on ConversationDto {
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
    TResult Function(_ConversationDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConversationDto() when $default != null:
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
    TResult Function(_ConversationDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConversationDto():
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
    TResult? Function(_ConversationDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConversationDto() when $default != null:
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
            String title,
            @JsonKey(name: 'created_at') String createdAt,
            @JsonKey(name: 'updated_at') String updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConversationDto() when $default != null:
        return $default(
            _that.id, _that.title, _that.createdAt, _that.updatedAt);
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
            String title,
            @JsonKey(name: 'created_at') String createdAt,
            @JsonKey(name: 'updated_at') String updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConversationDto():
        return $default(
            _that.id, _that.title, _that.createdAt, _that.updatedAt);
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
            String title,
            @JsonKey(name: 'created_at') String createdAt,
            @JsonKey(name: 'updated_at') String updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConversationDto() when $default != null:
        return $default(
            _that.id, _that.title, _that.createdAt, _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ConversationDto implements ConversationDto {
  const _ConversationDto(
      {required this.id,
      required this.title,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _ConversationDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationDtoFromJson(json);

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

  /// Create a copy of ConversationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConversationDtoCopyWith<_ConversationDto> get copyWith =>
      __$ConversationDtoCopyWithImpl<_ConversationDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ConversationDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConversationDto &&
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

  @override
  String toString() {
    return 'ConversationDto(id: $id, title: $title, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$ConversationDtoCopyWith<$Res>
    implements $ConversationDtoCopyWith<$Res> {
  factory _$ConversationDtoCopyWith(
          _ConversationDto value, $Res Function(_ConversationDto) _then) =
      __$ConversationDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt});
}

/// @nodoc
class __$ConversationDtoCopyWithImpl<$Res>
    implements _$ConversationDtoCopyWith<$Res> {
  __$ConversationDtoCopyWithImpl(this._self, this._then);

  final _ConversationDto _self;
  final $Res Function(_ConversationDto) _then;

  /// Create a copy of ConversationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_ConversationDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$MessageDto {
  String get id;
  @JsonKey(name: 'conversation_id')
  String get conversationId;
  String get role;
  String get content;
  @JsonKey(name: 'created_at')
  String get createdAt;

  /// Create a copy of MessageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageDtoCopyWith<MessageDto> get copyWith =>
      _$MessageDtoCopyWithImpl<MessageDto>(this as MessageDto, _$identity);

  /// Serializes this MessageDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageDto &&
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

  @override
  String toString() {
    return 'MessageDto(id: $id, conversationId: $conversationId, role: $role, content: $content, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $MessageDtoCopyWith<$Res> {
  factory $MessageDtoCopyWith(
          MessageDto value, $Res Function(MessageDto) _then) =
      _$MessageDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'conversation_id') String conversationId,
      String role,
      String content,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class _$MessageDtoCopyWithImpl<$Res> implements $MessageDtoCopyWith<$Res> {
  _$MessageDtoCopyWithImpl(this._self, this._then);

  final MessageDto _self;
  final $Res Function(MessageDto) _then;

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
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _self.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
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
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [MessageDto].
extension MessageDtoPatterns on MessageDto {
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
    TResult Function(_MessageDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MessageDto() when $default != null:
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
    TResult Function(_MessageDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MessageDto():
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
    TResult? Function(_MessageDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MessageDto() when $default != null:
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
            @JsonKey(name: 'conversation_id') String conversationId,
            String role,
            String content,
            @JsonKey(name: 'created_at') String createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MessageDto() when $default != null:
        return $default(_that.id, _that.conversationId, _that.role,
            _that.content, _that.createdAt);
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
            @JsonKey(name: 'conversation_id') String conversationId,
            String role,
            String content,
            @JsonKey(name: 'created_at') String createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MessageDto():
        return $default(_that.id, _that.conversationId, _that.role,
            _that.content, _that.createdAt);
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
            @JsonKey(name: 'conversation_id') String conversationId,
            String role,
            String content,
            @JsonKey(name: 'created_at') String createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MessageDto() when $default != null:
        return $default(_that.id, _that.conversationId, _that.role,
            _that.content, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MessageDto implements MessageDto {
  const _MessageDto(
      {required this.id,
      @JsonKey(name: 'conversation_id') required this.conversationId,
      required this.role,
      required this.content,
      @JsonKey(name: 'created_at') required this.createdAt});
  factory _MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);

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

  /// Create a copy of MessageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MessageDtoCopyWith<_MessageDto> get copyWith =>
      __$MessageDtoCopyWithImpl<_MessageDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MessageDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MessageDto &&
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

  @override
  String toString() {
    return 'MessageDto(id: $id, conversationId: $conversationId, role: $role, content: $content, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$MessageDtoCopyWith<$Res>
    implements $MessageDtoCopyWith<$Res> {
  factory _$MessageDtoCopyWith(
          _MessageDto value, $Res Function(_MessageDto) _then) =
      __$MessageDtoCopyWithImpl;
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
class __$MessageDtoCopyWithImpl<$Res> implements _$MessageDtoCopyWith<$Res> {
  __$MessageDtoCopyWithImpl(this._self, this._then);

  final _MessageDto _self;
  final $Res Function(_MessageDto) _then;

  /// Create a copy of MessageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? role = null,
    Object? content = null,
    Object? createdAt = null,
  }) {
    return _then(_MessageDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _self.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
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
              as String,
    ));
  }
}

/// @nodoc
mixin _$ConversationWithMessagesDto {
  ConversationDto get conversation;
  List<MessageDto> get messages;

  /// Create a copy of ConversationWithMessagesDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConversationWithMessagesDtoCopyWith<ConversationWithMessagesDto>
      get copyWith => _$ConversationWithMessagesDtoCopyWithImpl<
              ConversationWithMessagesDto>(
          this as ConversationWithMessagesDto, _$identity);

  /// Serializes this ConversationWithMessagesDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConversationWithMessagesDto &&
            (identical(other.conversation, conversation) ||
                other.conversation == conversation) &&
            const DeepCollectionEquality().equals(other.messages, messages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, conversation, const DeepCollectionEquality().hash(messages));

  @override
  String toString() {
    return 'ConversationWithMessagesDto(conversation: $conversation, messages: $messages)';
  }
}

/// @nodoc
abstract mixin class $ConversationWithMessagesDtoCopyWith<$Res> {
  factory $ConversationWithMessagesDtoCopyWith(
          ConversationWithMessagesDto value,
          $Res Function(ConversationWithMessagesDto) _then) =
      _$ConversationWithMessagesDtoCopyWithImpl;
  @useResult
  $Res call({ConversationDto conversation, List<MessageDto> messages});

  $ConversationDtoCopyWith<$Res> get conversation;
}

/// @nodoc
class _$ConversationWithMessagesDtoCopyWithImpl<$Res>
    implements $ConversationWithMessagesDtoCopyWith<$Res> {
  _$ConversationWithMessagesDtoCopyWithImpl(this._self, this._then);

  final ConversationWithMessagesDto _self;
  final $Res Function(ConversationWithMessagesDto) _then;

  /// Create a copy of ConversationWithMessagesDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversation = null,
    Object? messages = null,
  }) {
    return _then(_self.copyWith(
      conversation: null == conversation
          ? _self.conversation
          : conversation // ignore: cast_nullable_to_non_nullable
              as ConversationDto,
      messages: null == messages
          ? _self.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<MessageDto>,
    ));
  }

  /// Create a copy of ConversationWithMessagesDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConversationDtoCopyWith<$Res> get conversation {
    return $ConversationDtoCopyWith<$Res>(_self.conversation, (value) {
      return _then(_self.copyWith(conversation: value));
    });
  }
}

/// Adds pattern-matching-related methods to [ConversationWithMessagesDto].
extension ConversationWithMessagesDtoPatterns on ConversationWithMessagesDto {
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
    TResult Function(_ConversationWithMessagesDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConversationWithMessagesDto() when $default != null:
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
    TResult Function(_ConversationWithMessagesDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConversationWithMessagesDto():
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
    TResult? Function(_ConversationWithMessagesDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConversationWithMessagesDto() when $default != null:
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
    TResult Function(ConversationDto conversation, List<MessageDto> messages)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConversationWithMessagesDto() when $default != null:
        return $default(_that.conversation, _that.messages);
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
    TResult Function(ConversationDto conversation, List<MessageDto> messages)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConversationWithMessagesDto():
        return $default(_that.conversation, _that.messages);
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
    TResult? Function(ConversationDto conversation, List<MessageDto> messages)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConversationWithMessagesDto() when $default != null:
        return $default(_that.conversation, _that.messages);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ConversationWithMessagesDto implements ConversationWithMessagesDto {
  const _ConversationWithMessagesDto(
      {required this.conversation, required final List<MessageDto> messages})
      : _messages = messages;
  factory _ConversationWithMessagesDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationWithMessagesDtoFromJson(json);

  @override
  final ConversationDto conversation;
  final List<MessageDto> _messages;
  @override
  List<MessageDto> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  /// Create a copy of ConversationWithMessagesDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConversationWithMessagesDtoCopyWith<_ConversationWithMessagesDto>
      get copyWith => __$ConversationWithMessagesDtoCopyWithImpl<
          _ConversationWithMessagesDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ConversationWithMessagesDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConversationWithMessagesDto &&
            (identical(other.conversation, conversation) ||
                other.conversation == conversation) &&
            const DeepCollectionEquality().equals(other._messages, _messages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, conversation,
      const DeepCollectionEquality().hash(_messages));

  @override
  String toString() {
    return 'ConversationWithMessagesDto(conversation: $conversation, messages: $messages)';
  }
}

/// @nodoc
abstract mixin class _$ConversationWithMessagesDtoCopyWith<$Res>
    implements $ConversationWithMessagesDtoCopyWith<$Res> {
  factory _$ConversationWithMessagesDtoCopyWith(
          _ConversationWithMessagesDto value,
          $Res Function(_ConversationWithMessagesDto) _then) =
      __$ConversationWithMessagesDtoCopyWithImpl;
  @override
  @useResult
  $Res call({ConversationDto conversation, List<MessageDto> messages});

  @override
  $ConversationDtoCopyWith<$Res> get conversation;
}

/// @nodoc
class __$ConversationWithMessagesDtoCopyWithImpl<$Res>
    implements _$ConversationWithMessagesDtoCopyWith<$Res> {
  __$ConversationWithMessagesDtoCopyWithImpl(this._self, this._then);

  final _ConversationWithMessagesDto _self;
  final $Res Function(_ConversationWithMessagesDto) _then;

  /// Create a copy of ConversationWithMessagesDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? conversation = null,
    Object? messages = null,
  }) {
    return _then(_ConversationWithMessagesDto(
      conversation: null == conversation
          ? _self.conversation
          : conversation // ignore: cast_nullable_to_non_nullable
              as ConversationDto,
      messages: null == messages
          ? _self._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<MessageDto>,
    ));
  }

  /// Create a copy of ConversationWithMessagesDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConversationDtoCopyWith<$Res> get conversation {
    return $ConversationDtoCopyWith<$Res>(_self.conversation, (value) {
      return _then(_self.copyWith(conversation: value));
    });
  }
}

/// @nodoc
mixin _$ConversationListDto {
  List<ConversationDto> get conversations;
  int get total;
  int get limit;
  int get offset;

  /// Create a copy of ConversationListDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConversationListDtoCopyWith<ConversationListDto> get copyWith =>
      _$ConversationListDtoCopyWithImpl<ConversationListDto>(
          this as ConversationListDto, _$identity);

  /// Serializes this ConversationListDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConversationListDto &&
            const DeepCollectionEquality()
                .equals(other.conversations, conversations) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(conversations), total, limit, offset);

  @override
  String toString() {
    return 'ConversationListDto(conversations: $conversations, total: $total, limit: $limit, offset: $offset)';
  }
}

/// @nodoc
abstract mixin class $ConversationListDtoCopyWith<$Res> {
  factory $ConversationListDtoCopyWith(
          ConversationListDto value, $Res Function(ConversationListDto) _then) =
      _$ConversationListDtoCopyWithImpl;
  @useResult
  $Res call(
      {List<ConversationDto> conversations, int total, int limit, int offset});
}

/// @nodoc
class _$ConversationListDtoCopyWithImpl<$Res>
    implements $ConversationListDtoCopyWith<$Res> {
  _$ConversationListDtoCopyWithImpl(this._self, this._then);

  final ConversationListDto _self;
  final $Res Function(ConversationListDto) _then;

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
    return _then(_self.copyWith(
      conversations: null == conversations
          ? _self.conversations
          : conversations // ignore: cast_nullable_to_non_nullable
              as List<ConversationDto>,
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
    ));
  }
}

/// Adds pattern-matching-related methods to [ConversationListDto].
extension ConversationListDtoPatterns on ConversationListDto {
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
    TResult Function(_ConversationListDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConversationListDto() when $default != null:
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
    TResult Function(_ConversationListDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConversationListDto():
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
    TResult? Function(_ConversationListDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConversationListDto() when $default != null:
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
    TResult Function(List<ConversationDto> conversations, int total, int limit,
            int offset)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConversationListDto() when $default != null:
        return $default(
            _that.conversations, _that.total, _that.limit, _that.offset);
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
    TResult Function(List<ConversationDto> conversations, int total, int limit,
            int offset)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConversationListDto():
        return $default(
            _that.conversations, _that.total, _that.limit, _that.offset);
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
    TResult? Function(List<ConversationDto> conversations, int total, int limit,
            int offset)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConversationListDto() when $default != null:
        return $default(
            _that.conversations, _that.total, _that.limit, _that.offset);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ConversationListDto implements ConversationListDto {
  const _ConversationListDto(
      {required final List<ConversationDto> conversations,
      required this.total,
      required this.limit,
      required this.offset})
      : _conversations = conversations;
  factory _ConversationListDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationListDtoFromJson(json);

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

  /// Create a copy of ConversationListDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConversationListDtoCopyWith<_ConversationListDto> get copyWith =>
      __$ConversationListDtoCopyWithImpl<_ConversationListDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ConversationListDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConversationListDto &&
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

  @override
  String toString() {
    return 'ConversationListDto(conversations: $conversations, total: $total, limit: $limit, offset: $offset)';
  }
}

/// @nodoc
abstract mixin class _$ConversationListDtoCopyWith<$Res>
    implements $ConversationListDtoCopyWith<$Res> {
  factory _$ConversationListDtoCopyWith(_ConversationListDto value,
          $Res Function(_ConversationListDto) _then) =
      __$ConversationListDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<ConversationDto> conversations, int total, int limit, int offset});
}

/// @nodoc
class __$ConversationListDtoCopyWithImpl<$Res>
    implements _$ConversationListDtoCopyWith<$Res> {
  __$ConversationListDtoCopyWithImpl(this._self, this._then);

  final _ConversationListDto _self;
  final $Res Function(_ConversationListDto) _then;

  /// Create a copy of ConversationListDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? conversations = null,
    Object? total = null,
    Object? limit = null,
    Object? offset = null,
  }) {
    return _then(_ConversationListDto(
      conversations: null == conversations
          ? _self._conversations
          : conversations // ignore: cast_nullable_to_non_nullable
              as List<ConversationDto>,
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
    ));
  }
}

/// @nodoc
mixin _$WelcomeMessageDto {
  String get message;
  @JsonKey(name: 'conversation_starters')
  List<String> get conversationStarters;

  /// Create a copy of WelcomeMessageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WelcomeMessageDtoCopyWith<WelcomeMessageDto> get copyWith =>
      _$WelcomeMessageDtoCopyWithImpl<WelcomeMessageDto>(
          this as WelcomeMessageDto, _$identity);

  /// Serializes this WelcomeMessageDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WelcomeMessageDto &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other.conversationStarters, conversationStarters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message,
      const DeepCollectionEquality().hash(conversationStarters));

  @override
  String toString() {
    return 'WelcomeMessageDto(message: $message, conversationStarters: $conversationStarters)';
  }
}

/// @nodoc
abstract mixin class $WelcomeMessageDtoCopyWith<$Res> {
  factory $WelcomeMessageDtoCopyWith(
          WelcomeMessageDto value, $Res Function(WelcomeMessageDto) _then) =
      _$WelcomeMessageDtoCopyWithImpl;
  @useResult
  $Res call(
      {String message,
      @JsonKey(name: 'conversation_starters')
      List<String> conversationStarters});
}

/// @nodoc
class _$WelcomeMessageDtoCopyWithImpl<$Res>
    implements $WelcomeMessageDtoCopyWith<$Res> {
  _$WelcomeMessageDtoCopyWithImpl(this._self, this._then);

  final WelcomeMessageDto _self;
  final $Res Function(WelcomeMessageDto) _then;

  /// Create a copy of WelcomeMessageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? conversationStarters = null,
  }) {
    return _then(_self.copyWith(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      conversationStarters: null == conversationStarters
          ? _self.conversationStarters
          : conversationStarters // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [WelcomeMessageDto].
extension WelcomeMessageDtoPatterns on WelcomeMessageDto {
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
    TResult Function(_WelcomeMessageDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WelcomeMessageDto() when $default != null:
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
    TResult Function(_WelcomeMessageDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WelcomeMessageDto():
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
    TResult? Function(_WelcomeMessageDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WelcomeMessageDto() when $default != null:
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
            String message,
            @JsonKey(name: 'conversation_starters')
            List<String> conversationStarters)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WelcomeMessageDto() when $default != null:
        return $default(_that.message, _that.conversationStarters);
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
            String message,
            @JsonKey(name: 'conversation_starters')
            List<String> conversationStarters)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WelcomeMessageDto():
        return $default(_that.message, _that.conversationStarters);
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
            String message,
            @JsonKey(name: 'conversation_starters')
            List<String> conversationStarters)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WelcomeMessageDto() when $default != null:
        return $default(_that.message, _that.conversationStarters);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WelcomeMessageDto implements WelcomeMessageDto {
  const _WelcomeMessageDto(
      {required this.message,
      @JsonKey(name: 'conversation_starters')
      required final List<String> conversationStarters})
      : _conversationStarters = conversationStarters;
  factory _WelcomeMessageDto.fromJson(Map<String, dynamic> json) =>
      _$WelcomeMessageDtoFromJson(json);

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

  /// Create a copy of WelcomeMessageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WelcomeMessageDtoCopyWith<_WelcomeMessageDto> get copyWith =>
      __$WelcomeMessageDtoCopyWithImpl<_WelcomeMessageDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WelcomeMessageDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WelcomeMessageDto &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other._conversationStarters, _conversationStarters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message,
      const DeepCollectionEquality().hash(_conversationStarters));

  @override
  String toString() {
    return 'WelcomeMessageDto(message: $message, conversationStarters: $conversationStarters)';
  }
}

/// @nodoc
abstract mixin class _$WelcomeMessageDtoCopyWith<$Res>
    implements $WelcomeMessageDtoCopyWith<$Res> {
  factory _$WelcomeMessageDtoCopyWith(
          _WelcomeMessageDto value, $Res Function(_WelcomeMessageDto) _then) =
      __$WelcomeMessageDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String message,
      @JsonKey(name: 'conversation_starters')
      List<String> conversationStarters});
}

/// @nodoc
class __$WelcomeMessageDtoCopyWithImpl<$Res>
    implements _$WelcomeMessageDtoCopyWith<$Res> {
  __$WelcomeMessageDtoCopyWithImpl(this._self, this._then);

  final _WelcomeMessageDto _self;
  final $Res Function(_WelcomeMessageDto) _then;

  /// Create a copy of WelcomeMessageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? conversationStarters = null,
  }) {
    return _then(_WelcomeMessageDto(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      conversationStarters: null == conversationStarters
          ? _self._conversationStarters
          : conversationStarters // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
mixin _$CreateConversationRequestDto {
  String get title;

  /// Create a copy of CreateConversationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateConversationRequestDtoCopyWith<CreateConversationRequestDto>
      get copyWith => _$CreateConversationRequestDtoCopyWithImpl<
              CreateConversationRequestDto>(
          this as CreateConversationRequestDto, _$identity);

  /// Serializes this CreateConversationRequestDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateConversationRequestDto &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title);

  @override
  String toString() {
    return 'CreateConversationRequestDto(title: $title)';
  }
}

/// @nodoc
abstract mixin class $CreateConversationRequestDtoCopyWith<$Res> {
  factory $CreateConversationRequestDtoCopyWith(
          CreateConversationRequestDto value,
          $Res Function(CreateConversationRequestDto) _then) =
      _$CreateConversationRequestDtoCopyWithImpl;
  @useResult
  $Res call({String title});
}

/// @nodoc
class _$CreateConversationRequestDtoCopyWithImpl<$Res>
    implements $CreateConversationRequestDtoCopyWith<$Res> {
  _$CreateConversationRequestDtoCopyWithImpl(this._self, this._then);

  final CreateConversationRequestDto _self;
  final $Res Function(CreateConversationRequestDto) _then;

  /// Create a copy of CreateConversationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
  }) {
    return _then(_self.copyWith(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [CreateConversationRequestDto].
extension CreateConversationRequestDtoPatterns on CreateConversationRequestDto {
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
    TResult Function(_CreateConversationRequestDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateConversationRequestDto() when $default != null:
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
    TResult Function(_CreateConversationRequestDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateConversationRequestDto():
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
    TResult? Function(_CreateConversationRequestDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateConversationRequestDto() when $default != null:
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
    TResult Function(String title)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateConversationRequestDto() when $default != null:
        return $default(_that.title);
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
    TResult Function(String title) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateConversationRequestDto():
        return $default(_that.title);
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
    TResult? Function(String title)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateConversationRequestDto() when $default != null:
        return $default(_that.title);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CreateConversationRequestDto implements CreateConversationRequestDto {
  const _CreateConversationRequestDto({required this.title});
  factory _CreateConversationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateConversationRequestDtoFromJson(json);

  @override
  final String title;

  /// Create a copy of CreateConversationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreateConversationRequestDtoCopyWith<_CreateConversationRequestDto>
      get copyWith => __$CreateConversationRequestDtoCopyWithImpl<
          _CreateConversationRequestDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CreateConversationRequestDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreateConversationRequestDto &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title);

  @override
  String toString() {
    return 'CreateConversationRequestDto(title: $title)';
  }
}

/// @nodoc
abstract mixin class _$CreateConversationRequestDtoCopyWith<$Res>
    implements $CreateConversationRequestDtoCopyWith<$Res> {
  factory _$CreateConversationRequestDtoCopyWith(
          _CreateConversationRequestDto value,
          $Res Function(_CreateConversationRequestDto) _then) =
      __$CreateConversationRequestDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String title});
}

/// @nodoc
class __$CreateConversationRequestDtoCopyWithImpl<$Res>
    implements _$CreateConversationRequestDtoCopyWith<$Res> {
  __$CreateConversationRequestDtoCopyWithImpl(this._self, this._then);

  final _CreateConversationRequestDto _self;
  final $Res Function(_CreateConversationRequestDto) _then;

  /// Create a copy of CreateConversationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? title = null,
  }) {
    return _then(_CreateConversationRequestDto(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$UpdateConversationRequestDto {
  String get title;

  /// Create a copy of UpdateConversationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateConversationRequestDtoCopyWith<UpdateConversationRequestDto>
      get copyWith => _$UpdateConversationRequestDtoCopyWithImpl<
              UpdateConversationRequestDto>(
          this as UpdateConversationRequestDto, _$identity);

  /// Serializes this UpdateConversationRequestDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateConversationRequestDto &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title);

  @override
  String toString() {
    return 'UpdateConversationRequestDto(title: $title)';
  }
}

/// @nodoc
abstract mixin class $UpdateConversationRequestDtoCopyWith<$Res> {
  factory $UpdateConversationRequestDtoCopyWith(
          UpdateConversationRequestDto value,
          $Res Function(UpdateConversationRequestDto) _then) =
      _$UpdateConversationRequestDtoCopyWithImpl;
  @useResult
  $Res call({String title});
}

/// @nodoc
class _$UpdateConversationRequestDtoCopyWithImpl<$Res>
    implements $UpdateConversationRequestDtoCopyWith<$Res> {
  _$UpdateConversationRequestDtoCopyWithImpl(this._self, this._then);

  final UpdateConversationRequestDto _self;
  final $Res Function(UpdateConversationRequestDto) _then;

  /// Create a copy of UpdateConversationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
  }) {
    return _then(_self.copyWith(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [UpdateConversationRequestDto].
extension UpdateConversationRequestDtoPatterns on UpdateConversationRequestDto {
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
    TResult Function(_UpdateConversationRequestDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UpdateConversationRequestDto() when $default != null:
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
    TResult Function(_UpdateConversationRequestDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateConversationRequestDto():
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
    TResult? Function(_UpdateConversationRequestDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateConversationRequestDto() when $default != null:
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
    TResult Function(String title)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UpdateConversationRequestDto() when $default != null:
        return $default(_that.title);
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
    TResult Function(String title) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateConversationRequestDto():
        return $default(_that.title);
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
    TResult? Function(String title)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateConversationRequestDto() when $default != null:
        return $default(_that.title);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UpdateConversationRequestDto implements UpdateConversationRequestDto {
  const _UpdateConversationRequestDto({required this.title});
  factory _UpdateConversationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateConversationRequestDtoFromJson(json);

  @override
  final String title;

  /// Create a copy of UpdateConversationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UpdateConversationRequestDtoCopyWith<_UpdateConversationRequestDto>
      get copyWith => __$UpdateConversationRequestDtoCopyWithImpl<
          _UpdateConversationRequestDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UpdateConversationRequestDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UpdateConversationRequestDto &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title);

  @override
  String toString() {
    return 'UpdateConversationRequestDto(title: $title)';
  }
}

/// @nodoc
abstract mixin class _$UpdateConversationRequestDtoCopyWith<$Res>
    implements $UpdateConversationRequestDtoCopyWith<$Res> {
  factory _$UpdateConversationRequestDtoCopyWith(
          _UpdateConversationRequestDto value,
          $Res Function(_UpdateConversationRequestDto) _then) =
      __$UpdateConversationRequestDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String title});
}

/// @nodoc
class __$UpdateConversationRequestDtoCopyWithImpl<$Res>
    implements _$UpdateConversationRequestDtoCopyWith<$Res> {
  __$UpdateConversationRequestDtoCopyWithImpl(this._self, this._then);

  final _UpdateConversationRequestDto _self;
  final $Res Function(_UpdateConversationRequestDto) _then;

  /// Create a copy of UpdateConversationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? title = null,
  }) {
    return _then(_UpdateConversationRequestDto(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
