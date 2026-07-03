import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/sisu_logo.dart';
import '../../../core/widgets/sisu_widgets.dart';
import '../models/chat_message_model.dart';
import '../viewmodels/ai_chat_view_model.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  late final AiChatViewModel _viewModel;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = AiChatViewModel();
  }

  @override
  void dispose() {
    _controller.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            SisuLogo(compact: true),
            SizedBox(width: 12),
            Text('Sisu AI Coach'),
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, _) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                  itemCount: _viewModel.messages.length + (_viewModel.loading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= _viewModel.messages.length) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: SisuCard(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Text('Sisu is analyzing...', style: Theme.of(context).textTheme.bodyMedium),
                        ),
                      );
                    }
                    return _MessageBubble(message: _viewModel.messages[index]);
                  },
                ),
              ),
              SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          minLines: 1,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'VD: Tôi nên tập gì hôm nay?',
                            filled: true,
                            fillColor: colors.card,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton.filled(
                        onPressed: () {
                          _viewModel.send(_controller.text);
                          _controller.clear();
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: colors.neon,
                          foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 310),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: message.isUser ? colors.neon : colors.card,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(message.isUser ? 20 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 20),
          ),
        ),
        child: Text(
          message.text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: message.isUser ? Theme.of(context).scaffoldBackgroundColor : null,
              ),
        ),
      ),
    );
  }
}
