import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/sisu_widgets.dart';
import '../models/gym_room_model.dart';
import '../viewmodels/gym_map_view_model.dart';
import 'gym_filter_bottom_sheet.dart';
import 'gym_room_detail_screen.dart';

class GymMapScreen extends StatefulWidget {
  const GymMapScreen({super.key});

  @override
  State<GymMapScreen> createState() => _GymMapScreenState();
}

class _GymMapScreenState extends State<GymMapScreen> {
  late final GymMapViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GymMapViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GymRoom Finder'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            onPressed: () => showGymFilterBottomSheet(context, _viewModel),
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, _) {
          return SisuScreen(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 260,
                  decoration: BoxDecoration(
                    color: colors.successSoft,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: colors.neon.withOpacity(.25)),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(painter: _MapGridPainter(colors.neon.withOpacity(.18))),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on, color: colors.neon, size: 58),
                            const SizedBox(height: 8),
                            Text('Ho Chi Minh City', style: Theme.of(context).textTheme.titleLarge),
                            Text('Mock map until Google Maps API key is connected',
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SisuChip(label: _viewModel.filter, selected: true),
                    SisuChip(label: _viewModel.district),
                    const SisuChip(label: 'Active only'),
                  ],
                ),
                const SizedBox(height: 22),
                Text('Nearby gyms', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                for (final gym in _viewModel.visibleGyms) ...[
                  _GymCard(
                    gym: gym,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => GymRoomDetailScreen(gym: gym)),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GymCard extends StatelessWidget {
  const _GymCard({
    required this.gym,
    required this.onTap,
  });

  final GymRoomModel gym;
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
            const SisuRoundIcon(icon: Icons.fitness_center, size: 58),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(gym.name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(gym.address, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text('${gym.distanceKm} km - Open until ${gym.openUntil}',
                      style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(gym.priceLabel, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colors.neon)),
                const SizedBox(height: 4),
                Text('${gym.rating}/5', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  const _MapGridPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 34) {
      canvas.drawLine(Offset(x, 0), Offset(x + 80, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 34) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 60), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
