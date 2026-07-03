import '../models/exercise_model.dart';
import '../models/plan_model.dart';
import '../models/routine_model.dart';

class WorkoutRepository {
  const WorkoutRepository();

  List<RoutineModel> getRoutines() {
    return const [
      RoutineModel(
        name: 'Push Day A',
        durationMinutes: 60,
        totalSets: 20,
        lastDoneLabel: 'Yesterday',
        exercises: [
          ExerciseModel(name: 'Bench Press', muscleGroup: 'Chest', sets: 4, reps: 5, weightKg: 120),
          ExerciseModel(name: 'Shoulder Press', muscleGroup: 'Shoulders', sets: 4, reps: 8, weightKg: 42),
          ExerciseModel(name: 'Triceps Pushdown', muscleGroup: 'Arms', sets: 3, reps: 12, weightKg: 35),
        ],
      ),
      RoutineModel(
        name: 'Pull Day B',
        durationMinutes: 65,
        totalSets: 22,
        lastDoneLabel: '2 days ago',
        exercises: [
          ExerciseModel(name: 'Lat Pulldown', muscleGroup: 'Back', sets: 4, reps: 10, weightKg: 65),
          ExerciseModel(name: 'Seated Row', muscleGroup: 'Back', sets: 4, reps: 10, weightKg: 58),
          ExerciseModel(name: 'Dumbbell Curl', muscleGroup: 'Arms', sets: 3, reps: 12, weightKg: 14),
        ],
      ),
      RoutineModel(
        name: 'Leg Day C',
        durationMinutes: 70,
        totalSets: 25,
        lastDoneLabel: '3 days ago',
        exercises: [
          ExerciseModel(name: 'Squat', muscleGroup: 'Legs', sets: 4, reps: 6, weightKg: 110),
          ExerciseModel(name: 'Romanian Deadlift', muscleGroup: 'Hamstrings', sets: 4, reps: 8, weightKg: 95),
          ExerciseModel(name: 'Leg Press', muscleGroup: 'Legs', sets: 4, reps: 12, weightKg: 180),
        ],
      ),
    ];
  }

  List<PlanModel> getPlans() {
    return const [
      PlanModel(
        name: 'Push Pull Legs',
        description: 'Classic hypertrophy split for consistent 5-6 day training.',
        daysPerWeek: 6,
        level: 'Intermediate',
      ),
      PlanModel(
        name: 'Upper Lower',
        description: 'Balanced strength and muscle growth with enough recovery.',
        daysPerWeek: 4,
        level: 'Beginner+',
      ),
      PlanModel(
        name: 'Full Body',
        description: 'Simple weekly routine for new lifters and busy students.',
        daysPerWeek: 3,
        level: 'Beginner',
      ),
    ];
  }
}
