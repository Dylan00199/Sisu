import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/sisu_widgets.dart';
import '../models/plan_model.dart';
import '../models/routine_model.dart';
import '../viewmodels/workout_view_model.dart';
import 'routine_builder_screen.dart';
import 'routine_detail_screen.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late final WorkoutViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = WorkoutViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return SisuScreen(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(l10n.t('workout'), style: Theme.of(context).textTheme.headlineLarge),
                  ),
                  FilledButton.icon(
                    onPressed: _openRoutineBuilder,
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.neon,
                      foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                    ),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.t('new_routine')),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SisuChip(
                        label: l10n.t('my_routines'),
                        selected: !_viewModel.showingPlans,
                        onTap: () => _viewModel.setTab(false),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SisuChip(
                        label: l10n.t('plans'),
                        selected: _viewModel.showingPlans,
                        onTap: () => _viewModel.setTab(true),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (!_viewModel.showingPlans)
                for (final routine in _viewModel.routines) ...[
                  _RoutineCard(
                    routine: routine,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => RoutineDetailScreen(routine: routine)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ]
              else
                for (final plan in _viewModel.plans) ...[
                  _PlanCard(plan: plan),
                  const SizedBox(height: 16),
                ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _openRoutineBuilder() async {
    final routine = await Navigator.of(context).push<RoutineModel>(
      MaterialPageRoute(builder: (_) => const RoutineBuilderScreen()),
    );
    if (routine == null) return;
    _viewModel.addRoutine(routine);
  }
}

class _RoutineCard extends StatelessWidget {
  const _RoutineCard({required this.routine, required this.onTap});

  final RoutineModel routine;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: SisuCard(
        child: Row(
          children: [
            const SisuRoundIcon(icon: Icons.fitness_center, size: 64),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(routine.name, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 14,
                    runSpacing: 8,
                    children: [
                      _Meta(icon: Icons.schedule, label: '${routine.durationMinutes} min'),
                      _Meta(icon: Icons.bolt_outlined, label: '${routine.totalSets} sets'),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(routine.lastDoneLabel, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
                Icon(Icons.chevron_right, color: colors.muted, size: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan});

  final PlanModel plan;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return SisuCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SisuRoundIcon(icon: Icons.view_week_outlined, size: 56),
              const SizedBox(width: 14),
              Expanded(child: Text(plan.name, style: Theme.of(context).textTheme.titleLarge)),
              Text('${plan.daysPerWeek}d/w', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colors.neon)),
            ],
          ),
          const SizedBox(height: 14),
          Text(plan.description, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 14),
          SisuChip(label: plan.level, selected: false),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: colors.muted),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
