class ChatMessageModel {
  const ChatMessageModel({
    required this.text,
    required this.isUser,
  });

  final String text;
  final bool isUser;
}
