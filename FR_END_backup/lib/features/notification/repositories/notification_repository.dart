import '../models/notification_model.dart';

class NotificationRepository {
  const NotificationRepository();

  List<SisuNotificationModel> getNotifications() {
    return const [
      SisuNotificationModel(
        title: 'New Personal Record!',
        body: 'You hit 120 kg x 5 on Bench Press: your best ever.',
        timeAgo: 'Just now',
        type: SisuNotificationType.record,
        unread: true,
      ),
      SisuNotificationModel(
        title: 'Linh Tran posted a new workout',
        body: 'Leg Day PR: Squat 110kg x 3. She is on a 22-day streak.',
        timeAgo: '1h ago',
        type: SisuNotificationType.friend,
        unread: true,
      ),
      SisuNotificationModel(
        title: 'Time to train!',
        body: 'You have not logged a workout today. Keep your 17-day streak alive.',
        timeAgo: '2h ago',
        type: SisuNotificationType.reminder,
        unread: true,
      ),
      SisuNotificationModel(
        title: 'Minh Hoang liked your post',
        body: 'Your Push Day A session got 3 new reactions.',
        timeAgo: '3h ago',
        type: SisuNotificationType.friend,
      ),
      SisuNotificationModel(
        title: 'Weekly Goal Reached!',
        body: 'You completed 5 workouts this week. That is 100% of your target.',
        timeAgo: 'Yesterday',
        type: SisuNotificationType.goal,
      ),
    ];
  }
}
