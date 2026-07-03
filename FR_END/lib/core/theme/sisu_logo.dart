import 'package:flutter/material.dart';

import 'app_theme.dart';

class SisuLogo extends StatelessWidget {
  const SisuLogo({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 38 : 48,
          height: compact ? 38 : 48,
          decoration: BoxDecoration(
            color: colors.neon,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colors.neon.withOpacity(.22),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.fitness_center,
            color: Theme.of(context).scaffoldBackgroundColor,
            size: compact ? 22 : 28,
          ),
        ),
        if (!compact) ...[
          const SizedBox(width: 10),
          Text(
            'Sisu',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ],
    );
  }
}
