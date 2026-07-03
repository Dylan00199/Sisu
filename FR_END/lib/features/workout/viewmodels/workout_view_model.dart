import 'package:flutter/foundation.dart';

import '../models/plan_model.dart';
import '../models/routine_model.dart';
import '../repositories/workout_repository.dart';

class WorkoutViewModel extends ChangeNotifier {
  WorkoutViewModel({WorkoutRepository repository = const WorkoutRepository()}) : _repository = repository {
    load();
  }

  final WorkoutRepository _repository;
  List<RoutineModel> routines = [];
  List<PlanModel> plans = [];
  bool showingPlans = false;

  void load() {
    routines = _repository.getRoutines();
    plans = _repository.getPlans();
  }

  void setTab(bool plansSelected) {
    showingPlans = plansSelected;
    notifyListeners();
  }

  void addRoutine(RoutineModel routine) {
    routines = [routine, ...routines];
    showingPlans = false;
    notifyListeners();
  }

  bool canCreateRoutine(String title, int exerciseCount) {
    return title.trim().isNotEmpty && exerciseCount > 0;
  }
}
