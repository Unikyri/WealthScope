// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatMessageDTO _$ChatMessageDTOFromJson(Map<String, dynamic> json) {
  return _ChatMessageDTO.fromJson(json);
}

/// @nodoc
mixin _$ChatMessageDTO {
  String get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get timestamp => throw _privateConstructorUsedError;
  bool get isError => throw _privateConstructorUsedError;

  /// Serializes this ChatMessageDTO to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessageDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageDTOCopyWith<ChatMessageDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageDTOCopyWith<$Res> {
  factory $ChatMessageDTOCopyWith(
          ChatMessageDTO value, $Res Function(ChatMessageDTO) then) =
      _$ChatMessageDTOCopyWithImpl<$Res, ChatMessageDTO>;
  @useResult
  $Res call(
      {String id, String content, String role, String timestamp, bool isError});
}

/// @nodoc
class _$ChatMessageDTOCopyWithImpl<$Res, $Val extends ChatMessageDTO>
    implements $ChatMessageDTOCopyWith<$Res> {
  _$ChatMessageDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessageDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? role = null,
    Object? timestamp = null,
    Object? isError = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
      isError: null == isError
          ? _value.isError
          : isError // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatMessageDTOImplCopyWith<$Res>
    implements $ChatMessageDTOCopyWith<$Res> {
  factory _$$ChatMessageDTOImplCopyWith(_$ChatMessageDTOImpl value,
          $Res Function(_$ChatMessageDTOImpl) then) =
      __$$ChatMessageDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String content, String role, String timestamp, bool isError});
}

/// @nodoc
class __$$ChatMessageDTOImplCopyWithImpl<$Res>
    extends _$ChatMessageDTOCopyWithImpl<$Res, _$ChatMessageDTOImpl>
    implements _$$ChatMessageDTOImplCopyWith<$Res> {
  __$$ChatMessageDTOImplCopyWithImpl(
      _$ChatMessageDTOImpl _value, $Res Function(_$ChatMessageDTOImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatMessageDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? role = null,
    Object? timestamp = null,
    Object? isError = null,
  }) {
    return _then(_$ChatMessageDTOImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
      isError: null == isError
          ? _value.isError
          : isError // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageDTOImpl extends _ChatMessageDTO {
  const _$ChatMessageDTOImpl(
      {required this.id,
      required this.content,
      required this.role,
      required this.timestamp,
      this.isError = false})
      : super._();

  factory _$ChatMessageDTOImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageDTOImplFromJson(json);

  @override
  final String id;
  @override
  final String content;
  @override
  final String role;
  @override
  final String timestamp;
  @override
  @JsonKey()
  final bool isError;

  @override
  String toString() {
    return 'ChatMessageDTO(id: $id, content: $content, role: $role, timestamp: $timestamp, isError: $isError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageDTOImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isError, isError) || other.isError == isError));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, content, role, timestamp, isError);

  /// Create a copy of ChatMessageDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageDTOImplCopyWith<_$ChatMessageDTOImpl> get copyWith =>
      __$$ChatMessageDTOImplCopyWithImpl<_$ChatMessageDTOImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageDTOImplToJson(
      this,
    );
  }
}

abstract class _ChatMessageDTO extends ChatMessageDTO {
  const factory _ChatMessageDTO(
      {required final String id,
      required final String content,
      required final String role,
      required final String timestamp,
      final bool isError}) = _$ChatMessageDTOImpl;
  const _ChatMessageDTO._() : super._();

  factory _ChatMessageDTO.fromJson(Map<String, dynamic> json) =
      _$ChatMessageDTOImpl.fromJson;

  @override
  String get id;
  @override
  String get content;
  @override
  String get role;
  @override
  String get timestamp;
  @override
  bool get isError;

  /// Create a copy of ChatMessageDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageDTOImplCopyWith<_$ChatMessageDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
