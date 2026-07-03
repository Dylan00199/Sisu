enum SisuNotificationType { record, friend, reminder, goal }

class SisuNotificationModel {
  const SisuNotificationModel({
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.type,
    this.unread = false,
  });

  final String title;
  final String body;
  final String timeAgo;
  final SisuNotificationType type;
  final bool unread;
}
