// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatMessageDTO {
  String get id;
  String get role;
  String get content;
  String get createdAt;

  /// Create a copy of ChatMessageDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatMessageDTOCopyWith<ChatMessageDTO> get copyWith =>
      _$ChatMessageDTOCopyWithImpl<ChatMessageDTO>(
          this as ChatMessageDTO, _$identity);

  /// Serializes this ChatMessageDTO to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatMessageDTO &&
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
    return 'ChatMessageDTO(id: $id, role: $role, content: $content, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $ChatMessageDTOCopyWith<$Res> {
  factory $ChatMessageDTOCopyWith(
          ChatMessageDTO value, $Res Function(ChatMessageDTO) _then) =
      _$ChatMessageDTOCopyWithImpl;
  @useResult
  $Res call({String id, String role, String content, String createdAt});
}

/// @nodoc
class _$ChatMessageDTOCopyWithImpl<$Res>
    implements $ChatMessageDTOCopyWith<$Res> {
  _$ChatMessageDTOCopyWithImpl(this._self, this._then);

  final ChatMessageDTO _self;
  final $Res Function(ChatMessageDTO) _then;

  /// Create a copy of ChatMessageDTO
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
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [ChatMessageDTO].
extension ChatMessageDTOPatterns on ChatMessageDTO {
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
    TResult Function(_ChatMessageDTO value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatMessageDTO() when $default != null:
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
    TResult Function(_ChatMessageDTO value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessageDTO():
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
    TResult? Function(_ChatMessageDTO value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessageDTO() when $default != null:
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
    TResult Function(String id, String role, String content, String createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatMessageDTO() when $default != null:
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
    TResult Function(String id, String role, String content, String createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessageDTO():
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
    TResult? Function(String id, String role, String content, String createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessageDTO() when $default != null:
        return $default(_that.id, _that.role, _that.content, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ChatMessageDTO extends ChatMessageDTO {
  const _ChatMessageDTO(
      {required this.id,
      required this.role,
      required this.content,
      required this.createdAt})
      : super._();
  factory _ChatMessageDTO.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageDTOFromJson(json);

  @override
  final String id;
  @override
  final String role;
  @override
  final String content;
  @override
  final String createdAt;

  /// Create a copy of ChatMessageDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChatMessageDTOCopyWith<_ChatMessageDTO> get copyWith =>
      __$ChatMessageDTOCopyWithImpl<_ChatMessageDTO>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ChatMessageDTOToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChatMessageDTO &&
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
    return 'ChatMessageDTO(id: $id, role: $role, content: $content, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$ChatMessageDTOCopyWith<$Res>
    implements $ChatMessageDTOCopyWith<$Res> {
  factory _$ChatMessageDTOCopyWith(
          _ChatMessageDTO value, $Res Function(_ChatMessageDTO) _then) =
      __$ChatMessageDTOCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String role, String content, String createdAt});
}

/// @nodoc
class __$ChatMessageDTOCopyWithImpl<$Res>
    implements _$ChatMessageDTOCopyWith<$Res> {
  __$ChatMessageDTOCopyWithImpl(this._self, this._then);

  final _ChatMessageDTO _self;
  final $Res Function(_ChatMessageDTO) _then;

  /// Create a copy of ChatMessageDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? createdAt = null,
  }) {
    return _then(_ChatMessageDTO(
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
              as String,
    ));
  }
}

// dart format on
