import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart' as sisu_date;
import '../viewmodels/calendar_view_model.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key, required this.viewModel});

  final CalendarViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;
    final days = sisu_date.daysInMonth(viewModel.month);
    final leading = sisu_date.leadingEmptyDays(viewModel.month);
    final totalCells = leading + days;
    const weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Column(
      children: [
        Row(
          children: [
            IconButton(onPressed: viewModel.previousMonth, icon: const Icon(Icons.chevron_left)),
            Expanded(
              child: Text(
                sisu_date.monthYearLabel(viewModel.month, Localizations.localeOf(context).languageCode),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            IconButton(onPressed: viewModel.nextMonth, icon: const Icon(Icons.chevron_right)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekdays.map((day) {
            return Expanded(child: Center(child: Text(day)));
          }).toList(),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: totalCells + ((7 - totalCells % 7) % 7),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 8,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            if (index < leading || index >= leading + days) {
              return const SizedBox.shrink();
            }

            final day = index - leading + 1;
            final done = viewModel.completedDays.contains(day);
            final today = day == DateTime.now().day &&
                viewModel.month.month == DateTime.now().month &&
                viewModel.month.year == DateTime.now().year;

            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: today
                    ? colors.neon
                    : done
                        ? colors.neon.withOpacity(.18)
                        : colors.card,
                borderRadius: BorderRadius.circular(18),
                border: done ? Border.all(color: colors.neon.withOpacity(.38)) : null,
              ),
              child: Text(
                '$day',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: today ? Theme.of(context).scaffoldBackgroundColor : null,
                    ),
              ),
            );
          },
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Icon(Icons.circle, color: colors.neon, size: 18),
            const SizedBox(width: 8),
            Text('Workout done', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(width: 24),
            Icon(Icons.circle, color: colors.cardAlt, size: 18),
            const SizedBox(width: 8),
            Text('Rest day', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ],
    );
  }
}
