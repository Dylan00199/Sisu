import 'package:flutter/material.dart';

import '../../../core/widgets/sisu_widgets.dart';
import '../viewmodels/gym_map_view_model.dart';

void showGymFilterBottomSheet(BuildContext context, GymMapViewModel viewModel) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      final filters = ['Nearest', 'Cheapest'];

      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 34),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter gyms', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final filter in filters)
                  SisuChip(
                    label: filter,
                    selected: viewModel.filter == filter,
                    onTap: () {
                      viewModel.setFilter(filter);
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text('District', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final district in viewModel.districts)
                  SisuChip(
                    label: district,
                    selected: viewModel.district == district,
                    onTap: () {
                      viewModel.setDistrict(district);
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
