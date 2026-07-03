import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/sisu_widgets.dart';
import '../models/post_model.dart';

class PublicProfileScreen extends StatelessWidget {
  const PublicProfileScreen({super.key, required this.profile});

  final DiscoverProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(profile.name),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SisuScreen(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SisuCard(
              child: Row(
                children: [
                  SisuAvatar(name: profile.name, size: 86),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile.name, style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 4),
                        Text(profile.handle, style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            SisuMetric(value: '${profile.streakDays}', label: 'Streak'),
                            const SizedBox(width: 22),
                            const SisuMetric(value: '36', label: 'Workouts'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.neon,
                      foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: const Text('Follow'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Text('Recent workouts', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            for (final item in const [
              'Upper body volume session',
              'Leg day with squat focus',
              'Morning mobility and cardio',
            ]) ...[
              SisuCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const SisuRoundIcon(icon: Icons.fitness_center, size: 52),
                    const SizedBox(width: 14),
                    Expanded(child: Text(item, style: Theme.of(context).textTheme.titleMedium)),
                    Icon(Icons.chevron_right, color: colors.muted),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}
