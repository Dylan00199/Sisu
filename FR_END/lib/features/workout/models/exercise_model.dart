class ExerciseModel {
  const ExerciseModel({
    required this.name,
    required this.muscleGroup,
    required this.sets,
    required this.reps,
    required this.weightKg,
  });

  final String name;
  final String muscleGroup;
  final int sets;
  final int reps;
  final int weightKg;
}
