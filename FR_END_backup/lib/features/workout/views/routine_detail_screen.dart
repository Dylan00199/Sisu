import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/sisu_widgets.dart';
import '../models/routine_model.dart';

class RoutineDetailScreen extends StatelessWidget {
  const RoutineDetailScreen({super.key, required this.routine});

  final RoutineModel routine;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(routine.name),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SisuScreen(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SisuCard(
              color: colors.limeSoft.withOpacity(Theme.of(context).brightness == Brightness.dark ? .65 : 1),
              borderColor: colors.neon.withOpacity(.35),
              child: Row(
                children: [
                  const SisuRoundIcon(icon: Icons.play_arrow_rounded, size: 64),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${routine.durationMinutes} min - ${routine.totalSets} sets',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text('Tap each exercise to mark it complete during demo.',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Exercises', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            for (final exercise in routine.exercises) ...[
              SisuCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: colors.neon),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(exercise.name, style: Theme.of(context).textTheme.titleMedium),
                          Text(exercise.muscleGroup, style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    Text(
                      '${exercise.sets}x${exercise.reps}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colors.neon),
                    ),
                    const SizedBox(width: 8),
                    Text('${exercise.weightKg}kg', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add exercise'),
            ),
          ],
        ),
      ),
    );
  }
}
