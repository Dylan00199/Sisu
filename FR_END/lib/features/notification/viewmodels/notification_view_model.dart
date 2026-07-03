import 'package:flutter/foundation.dart';

import '../models/notification_model.dart';
import '../repositories/notification_repository.dart';

class NotificationViewModel extends ChangeNotifier {
  NotificationViewModel({NotificationRepository repository = const NotificationRepository()})
      : _repository = repository {
    notifications = _repository.getNotifications();
  }

  final NotificationRepository _repository;
  List<SisuNotificationModel> notifications = [];
  SisuNotificationType? filter;

  int get unreadCount => notifications.where((item) => item.unread).length;

  List<SisuNotificationModel> get visibleNotifications {
    if (filter == null) return notifications;
    return notifications.where((item) => item.type == filter).toList();
  }

  void setFilter(SisuNotificationType? nextFilter) {
    filter = nextFilter;
    notifyListeners();
  }
}
