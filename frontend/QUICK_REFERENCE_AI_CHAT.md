# Quick Reference - AI Chat Feature

## Overview
The AI Chat feature provides an interactive chat interface where users can communicate with an AI financial advisor to get personalized portfolio insights and financial advice.

## Key Features

### 1. Message Exchange
- Send text messages to AI advisor
- Receive intelligent responses
- Real-time typing indicators
- Optimistic UI updates (messages appear instantly)

### 2. Conversation Management
- Persistent conversation history
- Clear conversation option
- Conversation ID tracking across messages
- Auto-scroll to latest messages

### 3. User Experience
- **Empty State**: Sample questions to get started quickly
- **Loading States**: Visual feedback during AI processing
- **Error Handling**: Clear error messages with retry option
- **Responsive Design**: Works on all screen sizes

## User Interface

### App Bar
- **Title**: "AI Advisor"
- **Clear Button**: Refresh icon to start new conversation

### Message List
- **User Messages**: Right-aligned, blue background
- **AI Messages**: Left-aligned, grey background
- **Timestamps**: Relative time (e.g., "Just now", "5m ago")

### Empty State
- Welcome message: "How can I help you today?"
- Sample questions:
  - "How is my portfolio performing?"
  - "What are my top holdings?"
  - "Should I rebalance my portfolio?"
  - "What is my asset allocation?"

### Input Area
- Text field with placeholder: "Type a message..."
- Send button (enabled only when text is present)
- Multi-line support
- Disabled during AI processing

## Navigation

**Route**: `/ai-chat`

Access from:
- Bottom navigation bar
- Dashboard quick actions
- Menu/drawer

## Technical Implementation

### Architecture Pattern
**Feature-First (Scream Architecture)**
```
lib/features/ai/
├── domain/          # Business logic & entities
├── data/            # Data sources & repositories
└── presentation/    # UI & state management
```

### State Management
- **Provider**: Riverpod with @riverpod annotation
- **State Type**: AsyncValue for async operations
- **Loading**: Dedicated typing indicator provider

### API Integration
- **Endpoint**: `/ai/chat`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "message": "user message here",
    "conversationId": "optional-uuid"
  }
  ```

## Usage Examples

### Sending a Message
1. Type message in input field
2. Press Send button or hit Enter
3. Message appears immediately in chat
4. Typing indicator shows while AI processes
5. AI response appears when ready

### Starting New Conversation
1. Tap refresh icon in app bar
2. Confirms clearing current history
3. Returns to empty state with sample questions

### Using Sample Questions
1. On empty state, tap any sample question
2. Message is sent automatically
3. AI responds with relevant information

## Error Handling

### Network Errors
- User message remains visible
- Error message displayed
- Retry option available
- Optimistic update rolled back if needed

### Loading Failures
- Graceful degradation to empty state
- Retry button to reload
- Clear error message displayed

## Accessibility

- Proper semantic labels
- Keyboard navigation support
- Screen reader compatible
- High contrast theme support

## Performance

- **Optimistic Updates**: Instant user feedback
- **Efficient Rendering**: Only rebuild necessary widgets
- **Auto-Scroll**: Smooth animation to latest message
- **Memory Management**: Proper disposal of controllers

## Best Practices

### For Users
1. Start with sample questions if unsure what to ask
2. Be specific in questions for better AI responses
3. Clear conversation when switching topics
4. Check for error messages if response doesn't appear

### For Developers
1. Always use Riverpod providers (no direct API calls)
2. Handle all AsyncValue states (data, loading, error)
3. Use theme colors (never hardcode colors)
4. Test error scenarios thoroughly

## Code Quality Standards

✅ **No setState** - Use Riverpod only  
✅ **No GetX** - Strictly forbidden  
✅ **@riverpod annotation** - Required for all providers  
✅ **Theme-based styling** - No hardcoded colors  
✅ **Null safety** - Fully enforced  
✅ **Absolute imports** - Use package: prefix  

## Testing Strategy

### Unit Tests
- Test message sending logic
- Test conversation state management
- Test error handling and recovery
- Test typing indicator state

### Widget Tests
- Test chat bubble rendering
- Test input field validation
- Test empty state interactions
- Test error state retry

### Integration Tests
- Test full conversation flow
- Test API integration
- Test navigation to/from chat
- Test state persistence

## Future Enhancements

1. **Voice Input**: Speech-to-text support
2. **Rich Content**: Markdown, charts, links in messages
3. **Message Actions**: Copy, share, delete messages
4. **Search**: Find specific messages in history
5. **Export**: Save conversation as PDF/text
6. **Multi-threading**: Multiple conversation topics
7. **Suggestions**: AI-suggested follow-up questions

## Troubleshooting

### Messages Not Sending
- Check internet connection
- Verify API endpoint is reachable
- Check authentication token
- Look for error messages in UI

### Typing Indicator Stuck
- Refresh the screen
- Start new conversation
- Check network connection
- Report to development team

### Conversation History Missing
- Verify API returns history
- Check provider initialization
- Look for console errors
- Clear app cache and retry

## Support

For issues or questions:
1. Check error messages in UI
2. Review console logs (dev mode)
3. Contact development team
4. File bug report with details

---

**Version**: 1.0.0  
**Last Updated**: February 3, 2026  
**Status**: ✅ Production Ready
