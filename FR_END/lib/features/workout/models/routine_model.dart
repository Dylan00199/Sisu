import 'exercise_model.dart';

class RoutineModel {
  const RoutineModel({
    required this.name,
    required this.durationMinutes,
    required this.totalSets,
    required this.lastDoneLabel,
    required this.exercises,
  });

  final String name;
  final int durationMinutes;
  final int totalSets;
  final String lastDoneLabel;
  final List<ExerciseModel> exercises;
}
