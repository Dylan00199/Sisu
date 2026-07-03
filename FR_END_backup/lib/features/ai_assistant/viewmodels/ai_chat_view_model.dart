import 'package:flutter/foundation.dart';

import '../models/chat_message_model.dart';
import '../repositories/ai_repository.dart';

class AiChatViewModel extends ChangeNotifier {
  AiChatViewModel({AiRepository repository = const AiRepository()}) : _repository = repository {
    messages = const [
      ChatMessageModel(
        text: 'Chào Trọng, mình là Sisu Coach. Hỏi mình về lịch tập, kỹ thuật, hoặc cách tăng tạ nhé.',
        isUser: false,
      ),
    ];
  }

  final AiRepository _repository;
  List<ChatMessageModel> messages = [];
  bool loading = false;

  Future<void> send(String text) async {
    final clean = text.trim();
    if (clean.isEmpty) return;

    messages = [...messages, ChatMessageModel(text: clean, isUser: true)];
    loading = true;
    notifyListeners();

    final answer = await _repository.ask(clean);
    messages = [...messages, ChatMessageModel(text: answer, isUser: false)];
    loading = false;
    notifyListeners();
  }
}
