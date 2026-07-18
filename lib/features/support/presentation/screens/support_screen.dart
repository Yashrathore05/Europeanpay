import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text: "Hello! I am your EU Pay AI Assistant. How can I help you with your payments, loyalty points, or bank connections today?",
      isMe: false,
    ),
  ];

  final List<String> _quickReplies = [
    "How to connect bank?",
    "How to earn loyalty points?",
    "What is MOD-97 check?",
    "Is EU Pay secure?",
  ];

  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
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

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isMe: true));
      _isTyping = true;
    });
    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      
      String response = "I'm here to help, but I didn't quite catch that. Could you please rephrase?";
      final lowerText = text.toLowerCase();

      if (lowerText.contains("connect bank") || lowerText.contains("powens") || lowerText.contains("link bank")) {
        response = "To connect a bank account, go to 'Bank Accounts' and tap 'Connect New Bank'. We use Powens, a secure AISP/PISP licensed open banking gateway. You will be redirected to authenticate securely with your bank, after which we will sync your balances and transaction history.";
      } else if (lowerText.contains("points") || lowerText.contains("loyalty") || lowerText.contains("cashback")) {
        response = "You earn EU Pay Points on all QR payments (standard 3% cashback, up to 10% at partner merchants). You also earn points for referring friends (100 pts), achieving milestones, or matching bank transactions. 100 points = €1.00!";
      } else if (lowerText.contains("mod-97") || lowerText.contains("iban") || lowerText.contains("checksum")) {
        response = "We validate all IBANs using the standard ISO 7064 Mod-97-10 checksum algorithm. This ensures that any bank account you link has a mathematically valid IBAN before we initiate any Open Banking API requests to Powens.";
      } else if (lowerText.contains("secure") || lowerText.contains("security") || lowerText.contains("data")) {
        response = "EU Pay is extremely secure. We protect sensitive pages with your transaction PIN or biometric lock, require 2FA for logins, and encrypt all data in transit and at rest. We never store your raw banking credentials; all open banking is handled via secure Powens tokens.";
      } else if (lowerText.contains("invoice") || lowerText.contains("pdf")) {
        response = "For invoice payments, we support scanning standard European EN16931-compliant invoice QR codes. Once paid, the corresponding EN16931 PDF receipt is generated and can be downloaded or shared directly from the transaction details screen.";
      }

      setState(() {
        _isTyping = false;
        _messages.add(_ChatMessage(text: response, isMe: false));
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Help & Support'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textTertiary,
          labelStyle: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'AI Assistant'),
            Tab(text: 'FAQs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChatTab(),
          _buildFaqTab(),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        // Chat history
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: _messages.length + (_isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length) {
                return _buildTypingIndicator();
              }
              final msg = _messages[index];
              return _buildChatBubble(msg);
            },
          ),
        ),

        // Quick replies
        if (!_isTyping)
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: _quickReplies.length,
              itemBuilder: (context, index) {
                final reply = _quickReplies[index];
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: ActionChip(
                    label: Text(reply, style: AppTypography.labelSmall),
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.borderLight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    onPressed: () => _sendMessage(reply),
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: AppSpacing.sm),

        // Text input bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: const Border(top: BorderSide(color: AppColors.borderLight)),
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: AppTypography.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                  onPressed: () => _sendMessage(_messageController.text),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChatBubble(_ChatMessage msg) {
    final alignment = msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = msg.isMe ? AppColors.primary : AppColors.surface;
    final textColor = msg.isMe ? Colors.white : AppColors.textPrimary;
    final borderRadius = msg.isMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(AppSpacing.radiusMd),
            topRight: Radius.circular(AppSpacing.radiusMd),
            bottomLeft: Radius.circular(AppSpacing.radiusMd),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(AppSpacing.radiusMd),
            topRight: Radius.circular(AppSpacing.radiusMd),
            bottomRight: Radius.circular(AppSpacing.radiusMd),
          );

    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: borderRadius,
              border: msg.isMe ? null : Border.all(color: AppColors.borderLight),
            ),
            child: Text(
              msg.text,
              style: AppTypography.bodyMedium.copyWith(color: textColor, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppSpacing.radiusMd),
            topRight: Radius.circular(AppSpacing.radiusMd),
            bottomRight: Radius.circular(AppSpacing.radiusMd),
          ),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "AI is thinking",
              style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
            ),
            const SizedBox(width: 8),
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqTab() {
    final faqs = [
      _FaqItem(
        "What is EU Pay?",
        "EU Pay is a next-generation European fintech application offering private payments, real-time loyalty cashback rewards, open banking integration, and seamless invoice payments.",
      ),
      _FaqItem(
        "How do I link a bank account?",
        "Navigate to Bank Accounts, click 'Connect New Bank', and choose your financial institution. You will securely log into your bank using our regulated open banking provider (Powens) to authorize the read-only connection.",
      ),
      _FaqItem(
        "What are EU Pay Points?",
        "Points are loyalty rewards earned by using EU Pay. You can withdraw your eligible points directly as cash (€) to your linked primary bank account once you meet the program criteria.",
      ),
      _FaqItem(
        "What is the EN16931 standard?",
        "EN16931 is the European standard for electronic invoicing. EU Pay dynamically parses EN16931-compliant invoice QR codes and generates matching digital PDF receipts upon successful payment.",
      ),
      _FaqItem(
        "Is my financial data secure?",
        "Yes, EU Pay complies with PSD2 open banking regulations and GDPR. All sensitive pages require PIN or biometric authentication. No credentials are stored on our servers.",
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        final faq = faqs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: ExpansionTile(
            title: Text(faq.question, style: AppTypography.titleSmall),
            childrenPadding: const EdgeInsets.all(AppSpacing.md),
            expandedAlignment: Alignment.topLeft,
            collapsedIconColor: AppColors.textSecondary,
            iconColor: AppColors.primary,
            shape: const RoundedRectangleBorder(side: BorderSide.none),
            children: [
              Text(
                faq.answer,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.4),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChatMessage {
  const _ChatMessage({required this.text, required this.isMe});
  final String text;
  final bool isMe;
}

class _FaqItem {
  const _FaqItem(this.question, this.answer);
  final String question;
  final String answer;
}
