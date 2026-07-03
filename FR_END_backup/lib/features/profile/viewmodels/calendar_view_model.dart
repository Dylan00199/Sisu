import 'package:flutter/foundation.dart';

import '../repositories/profile_repository.dart';

class CalendarViewModel extends ChangeNotifier {
  CalendarViewModel({ProfileRepository repository = const ProfileRepository()}) : _repository = repository {
    completedDays = _repository.getCompletedDays(month);
  }

  final ProfileRepository _repository;
  DateTime month = DateTime(DateTime.now().year, DateTime.now().month);
  List<int> completedDays = [];

  void nextMonth() {
    month = DateTime(month.year, month.month + 1);
    completedDays = _repository.getCompletedDays(month);
    notifyListeners();
  }

  void previousMonth() {
    month = DateTime(month.year, month.month - 1);
    completedDays = _repository.getCompletedDays(month);
    notifyListeners();
  }
}
