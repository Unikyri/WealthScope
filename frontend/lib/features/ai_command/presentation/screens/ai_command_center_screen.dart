import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/core/theme/custom_icons.dart';
import 'package:fl_chart/fl_chart.dart'; // For embedded charts

enum AgentState { idle, reasoning, executing }

class AiCommandCenterScreen extends ConsumerStatefulWidget {
  const AiCommandCenterScreen({super.key});

  @override
  ConsumerState<AiCommandCenterScreen> createState() => _AiCommandCenterScreenState();
}

class _AiCommandCenterScreenState extends ConsumerState<AiCommandCenterScreen> {
  AgentState _agentState = AgentState.idle;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<AiMessage> _messages = [];
  bool _showReasoning = false;

  @override
  void initState() {
    super.initState();
    // Initial greeting
    _messages.add(AiMessage(
      role: 'ai',
      text: 'Good evening. I am ready to analyze your portfolio or run simulations.',
      timestamp: DateTime.now(),
    ));
  }

  void _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(AiMessage(
        role: 'user',
        text: text,
        timestamp: DateTime.now(),
      ));
      _controller.clear();
      _agentState = AgentState.reasoning;
      _showReasoning = true;
    });

    // Scroll to bottom
    _scrollToBottom();

    // Simulate Agent Thinking
    await Future.delayed(2.seconds);
    if (!mounted) return;
    
    setState(() => _agentState = AgentState.executing);
    await Future.delayed(1.5.seconds);
    if (!mounted) return;

    // Simulate Response with Widget
    setState(() {
      _showReasoning = false;
      _agentState = AgentState.idle;
      _messages.add(AiMessage(
        role: 'ai',
        text: 'Based on your request, I simulated a 2008-style market crash (-20%). Here is the projected impact on your portfolio.',
        timestamp: DateTime.now(),
        widget: const _EmbeddedChartWidget(), // Rich widget
      ));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(theme),
            Expanded(
              child: Stack(
                children: [
                  // Chat Stream
                  ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), // Space for trace
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(_messages[index]);
                    },
                  ),
                  
                  // Reasoning Trace Overlay (Bottom)
                  if (_showReasoning)
                    Positioned(
                      bottom: 0,
                      left: 16,
                      right: 16,
                      child: _buildReasoningTrace(),
                    ),
                ],
              ),
            ),
            _buildInputArea(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardGrey,
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.electricBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(CustomIcons.ai, color: AppTheme.electricBlue, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('WealthScope AI', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
                  Text('Financial Analyst', style: theme.textTheme.labelSmall?.copyWith(color: AppTheme.textGrey)),
                ],
              ),
            ],
          ),
          _buildStatusIndicator(theme),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(ThemeData theme) {
    Color color;
    String text;
    switch (_agentState) {
      case AgentState.idle:
        color = AppTheme.emeraldAccent;
        text = 'IDLE';
        break;
      case AgentState.reasoning:
        color = Colors.amber;
        text = 'REASONING';
        break;
      case AgentState.executing:
        color = AppTheme.electricBlue;
        text = 'EXECUTING';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [BoxShadow(color: color.withOpacity(0.6), blurRadius: 6)]),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(duration: 1.seconds),
          const SizedBox(width: 8),
          Text(text, style: theme.textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.bold, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(AiMessage message) {
    final isAi = message.role == 'ai';
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isAi) ...[
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.indigo, Colors.purple]),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.3), blurRadius: 8)],
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isAi ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isAi ? AppTheme.cardGrey : AppTheme.electricBlue,
                    borderRadius: BorderRadius.only(
                      topLeft: isAi ? Radius.zero : const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: const Radius.circular(16),
                      bottomRight: isAi ? const Radius.circular(16) : Radius.zero,
                    ),
                    border: isAi ? Border.all(color: Colors.white.withOpacity(0.05)) : null,
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isAi ? Colors.white.withOpacity(0.9) : Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
                if (message.widget != null) ...[
                  const SizedBox(height: 12),
                  message.widget!,
                ]
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildReasoningTrace() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.midnightBlue.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTraceStep('Fetching market data for AAPL...', isDone: true),
          const SizedBox(height: 8),
          _buildTraceStep('Calculating volatility risk...', isDone: false, isActive: true),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2, end: 0);
  }

  Widget _buildTraceStep(String text, {bool isDone = false, bool isActive = false}) {
    return Row(
      children: [
        if (isDone)
          const Icon(Icons.check_circle, color: AppTheme.emeraldAccent, size: 14)
        else if (isActive)
          const SizedBox(
            width: 14, height: 14,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.electricBlue),
          )
        else
          Container(width: 14, height: 14, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppTheme.textGrey))),
        
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: isActive ? AppTheme.electricBlue : AppTheme.textGrey, fontSize: 12, fontFamily: 'monospace')),
      ],
    );
  }

  Widget _buildInputArea(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.midnightBlue,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Column(
        children: [
          // Prompt Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChip('Simulate Inflation'),
                const SizedBox(width: 8),
                _buildChip('Analyze Diversification'),
                const SizedBox(width: 8),
                _buildChip('Predict 2026'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Input Field
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardGrey,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Ask about your portfolio...',
                      hintStyle: TextStyle(color: AppTheme.textGrey.withOpacity(0.5)),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.attach_file, color: AppTheme.textGrey),
                        onPressed: () {},
                      ),
                    ),
                    onSubmitted: (_) => _handleSend(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _handleSend,
                child: Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.electricBlue,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: AppTheme.electricBlue.withOpacity(0.4), blurRadius: 10)],
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return ActionChip(
      label: Text(label),
      backgroundColor: AppTheme.cardGrey,
      labelStyle: const TextStyle(color: AppTheme.textGrey, fontSize: 12),
      side: BorderSide(color: Colors.white.withOpacity(0.1)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () {
        _controller.text = label;
      },
    );
  }
}

class AiMessage {
  final String role;
  final String text;
  final DateTime timestamp;
  final Widget? widget;

  AiMessage({required this.role, required this.text, required this.timestamp, this.widget});
}

class _EmbeddedChartWidget extends StatelessWidget {
  const _EmbeddedChartWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151B24),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.trending_down, color: AppTheme.alertRed, size: 16),
              SizedBox(width: 8),
              Text('MARKET CRASH (-20%)', style: TextStyle(color: AppTheme.alertRed, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('-\$42,350', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const Text('Projected Loss', style: TextStyle(color: AppTheme.textGrey, fontSize: 12)),
          const Spacer(),
          // Simple Bar Chart Mock
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar('Tech', 0.8, 0.6),
              const SizedBox(width: 12),
              _buildBar('Energy', 0.5, 0.4),
              const SizedBox(width: 12),
              _buildBar('Bonds', 0.3, 0.35), // Bonds go up slightly or stay flat
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double before, double after) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 12, height: 60 * before, color: Colors.grey.withOpacity(0.3)),
              const SizedBox(width: 4),
              Container(width: 12, height: 60 * after, color: after < before ? AppTheme.alertRed : AppTheme.emeraldAccent),
            ],
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppTheme.textGrey, fontSize: 10)),
        ],
      ),
    );
  }
}
