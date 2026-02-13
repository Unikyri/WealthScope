import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/ai/presentation/providers/ai_chat_provider.dart';
import 'package:wealthscope_app/features/ai/presentation/widgets/chat_bubble.dart';
import 'package:wealthscope_app/features/ai/presentation/widgets/typing_indicator.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/revenuecat_service.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/usage_tracker.dart';
import 'package:wealthscope_app/features/subscriptions/presentation/widgets/upgrade_prompt_dialog.dart';

class AIChatScreen extends ConsumerStatefulWidget {
  final String? initialPrompt;

  const AIChatScreen({super.key, this.initialPrompt});

  @override
  ConsumerState<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends ConsumerState<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Pre-load the prompt into the text field so the user can review/edit
    // before sending. Does NOT auto-send.
    if (widget.initialPrompt != null && widget.initialPrompt!.isNotEmpty) {
      _messageController.text = widget.initialPrompt!;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Centralised feature gate check
    final gate = ref.read(featureGateProvider);
    final result = gate.canSendAiQuery();
    if (!result.allowed) {
      if (!mounted) return;
      showGatePrompt(context, result);
      return;
    }

    _messageController.clear();

    // Send message via provider
    try {
      await ref.read(aiChatProvider.notifier).sendMessage(message);
      _scrollToBottom();

      // Record AI query usage for ALL plans
      await ref.read(usageTrackerProvider.notifier).recordAiQuery();
    } catch (e) {
      // Show user-friendly error message
      if (mounted) {
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage.contains('overloaded')
                  ? 'AI service is temporarily busy. Please try again in a moment.'
                  : errorMessage,
            ),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _sendMessage(),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(aiChatProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Advisor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(aiChatProvider.notifier).newConversation(),
            tooltip: 'New conversation',
          ),
        ],
      ),
      body: Column(
        children: [
          // Scout query limit banner
          _AiQueryLimitBanner(),

          // Messages list
          Expanded(
            child: chatState.when(
              data: (messages) => messages.isEmpty
                  ? const _EmptyChat()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return ChatBubble(
                          message: message,
                          isLast: index == messages.length - 1,
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 16),
                    Text('Error: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(aiChatProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Typing indicator
          if (ref.watch(aiIsTypingProvider))
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TypingIndicator(),
            ),

          // Input field
          _MessageInput(
            controller: _messageController,
            focusNode: _focusNode,
            onSend: _sendMessage,
            isLoading: ref.watch(aiIsTypingProvider),
          ),
        ],
      ),
    );
  }
}

class _EmptyChat extends ConsumerWidget {
  const _EmptyChat();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final sampleQuestions = [
      'How is my portfolio performing?',
      'What are my top holdings?',
      'Should I rebalance my portfolio?',
      'What is my asset allocation?',
    ];

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.psychology_outlined,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'AI Financial Advisor',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'How can I help you today?',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Text(
              'Sample Questions',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...sampleQuestions.map((question) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(aiChatProvider.notifier).sendMessage(question);
                    },
                    style: OutlinedButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: Text(question),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _MessageInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final bool isLoading;

  const _MessageInput({
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.isLoading,
  });

  @override
  State<_MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<_MessageInput> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canSend = _hasText && !widget.isLoading;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => canSend ? widget.onSend() : null,
                enabled: !widget.isLoading,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: canSend ? widget.onSend : null,
              icon: Icon(
                Icons.send,
                color: canSend
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.3),
              ),
              style: IconButton.styleFrom(
                backgroundColor: canSend
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surfaceContainerHighest,
                padding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Banner shown to ALL users indicating remaining daily AI queries.
/// Sentinel users see "Pro - Thinking Mode" indicator with their 50/day limit.
/// Scout users see their 3/day limit with upgrade CTA when at limit.
class _AiQueryLimitBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gate = ref.watch(featureGateProvider);
    final remaining = gate.aiQueriesRemaining;
    final max = gate.maxAiQueries;
    final isAtLimit = remaining <= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isAtLimit
            ? Colors.amber.withValues(alpha: 0.12)
            : AppTheme.electricBlue.withValues(alpha: 0.08),
        border: Border(
          bottom: BorderSide(
            color: isAtLimit
                ? Colors.amber.withValues(alpha: 0.2)
                : AppTheme.electricBlue.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isAtLimit ? Icons.warning_amber_rounded : Icons.auto_awesome,
            size: 14,
            color: isAtLimit ? Colors.amber : AppTheme.electricBlue,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  if (gate.isPremium && !isAtLimit) ...[
                    TextSpan(
                      text: gate.aiModelLabel,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.electricBlue,
                      ),
                    ),
                    TextSpan(
                      text: ' \u2022 ',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textGrey,
                      ),
                    ),
                  ],
                  TextSpan(
                    text: isAtLimit
                        ? 'Daily limit reached \u2022 Resets at midnight'
                        : '$remaining/$max queries today',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isAtLimit ? Colors.amber : AppTheme.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isAtLimit && !gate.isPremium)
            GestureDetector(
              onTap: () {
                final result = gate.canSendAiQuery();
                showGatePrompt(context, result);
              },
              child: Text(
                'Upgrade',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.electricBlue,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
