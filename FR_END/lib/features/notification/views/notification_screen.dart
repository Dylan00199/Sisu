import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/sisu_widgets.dart';
import '../models/notification_model.dart';
import '../viewmodels/notification_view_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final NotificationViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = NotificationViewModel();
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
                    child: Text(l10n.t('notifications'), style: Theme.of(context).textTheme.headlineLarge),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colors.alert,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${_viewModel.unreadCount}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(label: l10n.t('all'), selected: _viewModel.filter == null, onTap: () => _viewModel.setFilter(null)),
                    _FilterChip(
                      label: l10n.t('friends'),
                      selected: _viewModel.filter == SisuNotificationType.friend,
                      onTap: () => _viewModel.setFilter(SisuNotificationType.friend),
                    ),
                    _FilterChip(
                      label: l10n.t('records'),
                      selected: _viewModel.filter == SisuNotificationType.record,
                      onTap: () => _viewModel.setFilter(SisuNotificationType.record),
                    ),
                    _FilterChip(
                      label: l10n.t('reminders'),
                      selected: _viewModel.filter == SisuNotificationType.reminder,
                      onTap: () => _viewModel.setFilter(SisuNotificationType.reminder),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              for (final item in _viewModel.visibleNotifications) ...[
                _NotificationCard(item: item),
                const SizedBox(height: 14),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SisuChip(label: label, selected: selected, onTap: onTap),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item});

  final SisuNotificationModel item;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;
    final icon = switch (item.type) {
      SisuNotificationType.record => Icons.emoji_events_outlined,
      SisuNotificationType.friend => Icons.monitor_heart_outlined,
      SisuNotificationType.reminder => Icons.notifications_active_outlined,
      SisuNotificationType.goal => Icons.star_border,
    };
    final iconColor = switch (item.type) {
      SisuNotificationType.record => const Color(0xFFFFB84D),
      SisuNotificationType.friend => colors.neon,
      SisuNotificationType.reminder => const Color(0xFF5AD6FF),
      SisuNotificationType.goal => const Color(0xFFD45BFF),
    };

    return SisuCard(
      color: item.unread ? colors.successSoft : colors.card,
      borderColor: item.unread ? colors.neon.withOpacity(.25) : Theme.of(context).dividerColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(.14),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(item.body, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 12),
                Text(
                  item.timeAgo,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colors.neon),
                ),
              ],
            ),
          ),
          if (item.unread)
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: colors.neon, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}
