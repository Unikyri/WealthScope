# Conversations Feature - Quick Reference

## Overview
Integration of AI conversations API with the WealthScope frontend. Allows users to view, create, rename, and delete conversation threads with the AI advisor.

## Features Implemented

### 1. Conversations List Screen
**Location:** `lib/features/conversations/presentation/screens/conversations_list_screen.dart`

**Features:**
- Display all user conversations
- Create new conversation with custom title
- Rename existing conversations
- Delete conversations with confirmation
- Navigate to conversation detail
- Pull-to-refresh support
- Empty state with action button

**Usage:**
```dart
// Navigate to conversations list
context.push('/conversations');

// From notifications or other features
context.push('/ai-chat/conversation-id-here');
```

### 2. Conversation Chat Screen
**Location:** `lib/features/conversations/presentation/screens/conversation_chat_screen.dart`

**Features:**
- View conversation messages (user + AI responses)
- Real-time conversation title in app bar
- Rename conversation from options menu
- Delete conversation from options menu
- Message input field (ready for integration)
- Pull-to-refresh support
- Error handling with retry

**Navigation:**
```dart
// From conversations list or notifications
context.push('/ai-chat/:conversationId');
```

### 3. API Integration
**Location:** `lib/features/conversations/`

**Structure:**
```
conversations/
├── domain/
│   ├── entities/conversation_entity.dart
│   └── repositories/conversations_repository.dart
├── data/
│   ├── models/conversation_dto.dart
│   ├── datasources/conversations_remote_datasource.dart
│   └── repositories/conversations_repository_impl.dart
└── presentation/
    ├── providers/conversations_providers.dart
    └── screens/
        ├── conversations_list_screen.dart
        └── conversation_chat_screen.dart
```

## Providers Available

### List Conversations
```dart
final conversationsAsync = ref.watch(conversationsListProvider(
  limit: 20,
  offset: 0,
));
```

### Get Conversation with Messages
```dart
final conversationAsync = ref.watch(conversationProvider(conversationId));
```

### Get Welcome Message & Starters
```dart
final welcomeAsync = ref.watch(welcomeMessageProvider);
```

### Create Conversation
```dart
final conversation = await ref
    .read(createConversationProvider.notifier)
    .create('My Title');
```

### Update Conversation Title
```dart
await ref.read(updateConversationProvider.notifier).update(
  id: conversationId,
  title: 'New Title',
);
```

### Delete Conversation
```dart
await ref
    .read(deleteConversationProvider.notifier)
    .delete(conversationId);
```

## Routes Added

```dart
// Conversations list
GoRoute(
  path: '/conversations',
  name: 'conversations',
  builder: (context, state) => const ConversationsListScreen(),
),

// Conversation detail/chat
GoRoute(
  path: '/ai-chat/:conversationId',
  name: 'ai-chat-conversation',
  builder: (context, state) {
    final conversationId = state.pathParameters['conversationId']!;
    return ConversationChatScreen(conversationId: conversationId);
  },
),
```

## API Endpoints Integrated

1. `GET /api/v1/ai/conversations` - List conversations
2. `POST /api/v1/ai/conversations` - Create conversation
3. `GET /api/v1/ai/conversations/{id}` - Get conversation with messages
4. `PUT /api/v1/ai/conversations/{id}` - Update conversation title
5. `DELETE /api/v1/ai/conversations/{id}` - Delete conversation
6. `GET /api/v1/ai/welcome` - Get welcome message

## Integration Points

### Notifications
The conversations feature is ready to be integrated with notifications. When a new AI message arrives, create a notification with:
```dart
AppNotification(
  id: 'conv-${conversationId}',
  title: 'AI Conversation',
  message: conversationTitle,
  type: NotificationType.aiInsight,
  timestamp: updatedAt,
  actionUrl: '/ai-chat/$conversationId',
);
```

### AI Chat
The existing AI chat screen (`ai_chat_screen.dart`) remains for quick, non-persistent chats. Conversations are for persistent, saved chat threads.

## Next Steps (Future Enhancements)

1. **Send Messages in Conversations**
   - Currently read-only, need to integrate with `/api/v1/ai/chat` endpoint
   - Pass `conversation_id` when sending messages
   - Update conversation messages optimistically

2. **Welcome Message Integration**
   - Show conversation starters from `/api/v1/ai/welcome`
   - Quick-create conversation from starter

3. **Real-time Updates**
   - WebSocket integration for new messages
   - Auto-refresh conversation list when new messages arrive

4. **Search & Filter**
   - Search conversations by title or content
   - Filter by date or unread status

5. **Conversation Sharing**
   - Export conversation as PDF/text
   - Share insights from conversations

## Testing

Run tests for conversations (when created):
```bash
flutter test test/conversations/
```

## Notes

- All API calls use JWT authentication from Supabase
- Error handling follows Dartz Either<Failure, T> pattern
- DTOs use Freezed for immutability
- Providers use Riverpod generator syntax (@riverpod)
- Routes are type-safe with GoRouter

## Example Flow

1. User navigates to `/conversations`
2. User clicks "New Conversation" button
3. Dialog prompts for title
4. On confirmation, POST request creates conversation
5. User navigates to `/ai-chat/:conversationId`
6. Conversation messages load from API
7. User can send messages (when implemented)
8. User can rename or delete from options menu

---

**Status:** ✅ Backend integration complete  
**UI:** ✅ Screens implemented  
**Navigation:** ✅ Routes configured  
**TODO:** Message sending, real-time updates, welcome message UI
