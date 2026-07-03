import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/sisu_widgets.dart';
import '../models/streak_model.dart';

class StreakBannerWidget extends StatelessWidget {
  const StreakBannerWidget({super.key, required this.streak});

  final StreakModel streak;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return SisuCard(
      color: colors.limeSoft.withOpacity(Theme.of(context).brightness == Brightness.dark ? .7 : 1),
      borderColor: colors.neon.withOpacity(.35),
      padding: const EdgeInsets.all(22),
      child: Row(
        children: [
          const SisuRoundIcon(icon: Icons.local_fire_department_outlined, size: 62),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.t('current_streak'),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(letterSpacing: 2),
                ),
                const SizedBox(height: 6),
                Text(
                  '${streak.currentDays} Days',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: colors.neon),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                l10n.t('this_month'),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(letterSpacing: 2),
              ),
              const SizedBox(height: 6),
              Text(
                '${streak.monthCompleted} / ${streak.monthTarget}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Row(
                children: List.generate(7, (index) {
                  final active = index < 5;
                  return Container(
                    width: 16,
                    height: 16,
                    margin: const EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      color: active ? colors.neon : colors.neon.withOpacity(.14),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
