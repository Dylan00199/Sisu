import 'package:flutter/foundation.dart';

import '../models/exercise_model.dart';

class RoutineBuilderViewModel extends ChangeNotifier {
  String title = '';
  final List<ExerciseModel> exercises = [];

  bool get canSave => title.trim().isNotEmpty && exercises.isNotEmpty;

  int get totalSets => exercises.fold<int>(0, (sum, item) => sum + item.sets);

  int get durationMinutes => 35 + exercises.length * 10;

  void setTitle(String value) {
    title = value;
    notifyListeners();
  }

  void addExercise(ExerciseModel exercise) {
    exercises.add(exercise);
    notifyListeners();
  }

  void removeExercise(ExerciseModel exercise) {
    exercises.remove(exercise);
    notifyListeners();
  }
}
