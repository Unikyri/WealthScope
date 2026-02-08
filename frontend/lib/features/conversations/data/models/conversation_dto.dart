import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/conversation_entity.dart';

part 'conversation_dto.freezed.dart';
part 'conversation_dto.g.dart';

@freezed
abstract class ConversationDto with _$ConversationDto {
  const factory ConversationDto({
    required String id,
    required String title,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _ConversationDto;

  factory ConversationDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationDtoFromJson(json);
}

@freezed
abstract class MessageDto with _$MessageDto {
  const factory MessageDto({
    required String id,
    @JsonKey(name: 'conversation_id') required String conversationId,
    required String role,
    required String content,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _MessageDto;

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
}

@freezed
abstract class ConversationWithMessagesDto with _$ConversationWithMessagesDto {
  const factory ConversationWithMessagesDto({
    required ConversationDto conversation,
    required List<MessageDto> messages,
  }) = _ConversationWithMessagesDto;

  factory ConversationWithMessagesDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationWithMessagesDtoFromJson(json);
}

@freezed
abstract class ConversationListDto with _$ConversationListDto {
  const factory ConversationListDto({
    required List<ConversationDto> conversations,
    required int total,
    required int limit,
    required int offset,
  }) = _ConversationListDto;

  factory ConversationListDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationListDtoFromJson(json);
}

@freezed
abstract class WelcomeMessageDto with _$WelcomeMessageDto {
  const factory WelcomeMessageDto({
    required String message,
    @JsonKey(name: 'conversation_starters')
    required List<String> conversationStarters,
  }) = _WelcomeMessageDto;

  factory WelcomeMessageDto.fromJson(Map<String, dynamic> json) =>
      _$WelcomeMessageDtoFromJson(json);
}

@freezed
abstract class CreateConversationRequestDto with _$CreateConversationRequestDto {
  const factory CreateConversationRequestDto({
    required String title,
  }) = _CreateConversationRequestDto;

  factory CreateConversationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateConversationRequestDtoFromJson(json);
}

@freezed
abstract class UpdateConversationRequestDto with _$UpdateConversationRequestDto {
  const factory UpdateConversationRequestDto({
    required String title,
  }) = _UpdateConversationRequestDto;

  factory UpdateConversationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateConversationRequestDtoFromJson(json);
}

/// Extensions to convert DTOs to Domain Entities
extension ConversationDtoX on ConversationDto {
  ConversationEntity toDomain() {
    return ConversationEntity(
      id: id,
      title: title,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}

extension MessageDtoX on MessageDto {
  MessageEntity toDomain() {
    return MessageEntity(
      id: id,
      conversationId: conversationId,
      role: role,
      content: content,
      createdAt: DateTime.parse(createdAt),
    );
  }
}

extension ConversationWithMessagesDtoX on ConversationWithMessagesDto {
  ConversationWithMessagesEntity toDomain() {
    return ConversationWithMessagesEntity(
      conversation: conversation.toDomain(),
      messages: messages.map((dto) => dto.toDomain()).toList(),
    );
  }
}

extension WelcomeMessageDtoX on WelcomeMessageDto {
  WelcomeMessageEntity toDomain() {
    return WelcomeMessageEntity(
      message: message,
      conversationStarters: conversationStarters,
    );
  }
}
