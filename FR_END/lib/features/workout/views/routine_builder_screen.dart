import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/sisu_widgets.dart';
import '../models/exercise_model.dart';
import '../models/routine_model.dart';
import '../viewmodels/routine_builder_view_model.dart';

class RoutineBuilderScreen extends StatefulWidget {
  const RoutineBuilderScreen({super.key});

  @override
  State<RoutineBuilderScreen> createState() => _RoutineBuilderScreenState();
}

class _RoutineBuilderScreenState extends State<RoutineBuilderScreen> {
  late final RoutineBuilderViewModel _viewModel;
  final TextEditingController _titleController = TextEditingController();

  final List<ExerciseModel> _availableExercises = const [
    ExerciseModel(name: 'Bench Press', muscleGroup: 'Chest', sets: 4, reps: 5, weightKg: 80),
    ExerciseModel(name: 'Squat', muscleGroup: 'Legs', sets: 4, reps: 6, weightKg: 90),
    ExerciseModel(name: 'Lat Pulldown', muscleGroup: 'Back', sets: 3, reps: 10, weightKg: 55),
    ExerciseModel(name: 'Shoulder Press', muscleGroup: 'Shoulders', sets: 3, reps: 8, weightKg: 35),
  ];

  @override
  void initState() {
    super.initState();
    _viewModel = RoutineBuilderViewModel();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New routine'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          TextButton(
            onPressed: _save,
            child: Text('Save', style: TextStyle(color: colors.neon, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, _) {
          return SisuScreen(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  onChanged: _viewModel.setTitle,
                  decoration: InputDecoration(
                    labelText: 'Routine name',
                    hintText: 'Example: Upper Body A',
                    filled: true,
                    fillColor: colors.card,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(child: Text('Exercises', style: Theme.of(context).textTheme.titleLarge)),
                    FilledButton.icon(
                      onPressed: _showExercisePicker,
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.neon,
                        foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text('Add exercise'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_viewModel.exercises.isEmpty)
                  SisuCard(
                    child: Text(
                      'No exercise yet. Add at least one exercise before saving.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                else
                  for (final exercise in _viewModel.exercises) ...[
                    SisuCard(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          const SisuRoundIcon(icon: Icons.fitness_center, size: 48),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(exercise.name, style: Theme.of(context).textTheme.titleMedium),
                                Text('${exercise.sets} sets x ${exercise.reps} reps - ${exercise.weightKg}kg',
                                    style: Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => _viewModel.removeExercise(exercise),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _save,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: colors.neon,
                    foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: const Text('Save routine'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showExercisePicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add exercise', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              for (final exercise in _availableExercises)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const SisuRoundIcon(icon: Icons.fitness_center, size: 44),
                  title: Text(exercise.name),
                  subtitle: Text(exercise.muscleGroup),
                  trailing: const Icon(Icons.add),
                  onTap: () {
                    _viewModel.addExercise(exercise);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _save() {
    if (!_viewModel.canSave) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Routine name and at least one exercise are required.')),
      );
      return;
    }

    Navigator.of(context).pop(
      RoutineModel(
        name: _viewModel.title.trim(),
        durationMinutes: _viewModel.durationMinutes,
        totalSets: _viewModel.totalSets,
        lastDoneLabel: 'Just now',
        exercises: List.unmodifiable(_viewModel.exercises),
      ),
    );
  }
}
