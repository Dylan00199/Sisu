import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/sisu_widgets.dart';
import '../models/gym_room_model.dart';

class GymRoomDetailScreen extends StatelessWidget {
  const GymRoomDetailScreen({super.key, required this.gym});

  final GymRoomModel gym;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(gym.name),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SisuScreen(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: colors.successSoft,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: colors.neon.withOpacity(.24)),
              ),
              child: Center(child: Icon(Icons.fitness_center, size: 72, color: colors.neon)),
            ),
            const SizedBox(height: 20),
            Text(gym.name, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 6),
            Text(gym.address, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 18),
            SisuCard(
              child: Column(
                children: [
                  _DetailRow(label: 'District', value: gym.district),
                  _DetailRow(label: 'Distance', value: '${gym.distanceKm} km'),
                  _DetailRow(label: 'Open until', value: gym.openUntil),
                  _DetailRow(label: 'Day pass', value: gym.priceLabel),
                  _DetailRow(label: 'Phone', value: gym.phone),
                  _DetailRow(label: 'Rating', value: '${gym.rating}/5'),
                  _DetailRow(label: 'Status', value: gym.isActive ? 'Active' : 'Inactive'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colors.neon)),
        ],
      ),
    );
  }
}
