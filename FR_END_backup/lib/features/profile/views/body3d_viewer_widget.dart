import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/sisu_widgets.dart';

class Body3DViewerWidget extends StatelessWidget {
  const Body3DViewerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return SisuCard(
      child: Row(
        children: [
          Container(
            width: 108,
            height: 168,
            decoration: BoxDecoration(
              color: colors.successSoft,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: colors.neon.withOpacity(.28)),
            ),
            child: Icon(Icons.accessibility_new, size: 78, color: colors.neon),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Body focus', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  'Muscle groups targeted by your recent workouts. Replace this widget with a 3D model package if time allows.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    SisuChip(label: 'Chest', selected: true),
                    SisuChip(label: 'Shoulders'),
                    SisuChip(label: 'Legs'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
