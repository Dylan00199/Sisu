import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/settings/app_settings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/sisu_widgets.dart';
import '../models/statistic_model.dart';
import '../viewmodels/calendar_view_model.dart';
import '../viewmodels/profile_view_model.dart';
import 'body3d_viewer_widget.dart';
import 'calendar_widget.dart';

enum _ProfileTab { calendar, stats, measures, exercises, workouts, records, friends }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileViewModel _profile;
  late final CalendarViewModel _calendar;
  _ProfileTab _tab = _ProfileTab.calendar;

  @override
  void initState() {
    super.initState();
    _profile = ProfileViewModel();
    _calendar = CalendarViewModel();
  }

  @override
  void dispose() {
    _profile.dispose();
    _calendar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Theme.of(context).extension<SisuPalette>()!;
    final settings = SettingsScope.of(context);

    return AnimatedBuilder(
      animation: Listenable.merge([_profile, _calendar, settings]),
      builder: (context, _) {
        return SisuScreen(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SisuAvatar(name: _profile.user.name, size: 86),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_profile.user.name, style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 4),
                        Text('${_profile.user.handle} - ${_profile.user.location}',
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(child: SisuMetric(value: '${_profile.user.workouts}', label: 'Workouts')),
                            Expanded(child: SisuMetric(value: '${_profile.user.friends}', label: l10n.t('friends'))),
                            Expanded(child: SisuMetric(value: '${_profile.user.streak}', label: 'Streak')),
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
                    child: const Text('Edit'),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _ProfileTabChip(
                      label: l10n.t('calendar'),
                      icon: Icons.calendar_month_outlined,
                      selected: _tab == _ProfileTab.calendar,
                      onTap: () => setState(() => _tab = _ProfileTab.calendar),
                    ),
                    _ProfileTabChip(
                      label: l10n.t('stats'),
                      icon: Icons.trending_up,
                      selected: _tab == _ProfileTab.stats,
                      onTap: () => setState(() => _tab = _ProfileTab.stats),
                    ),
                    _ProfileTabChip(
                      label: 'Measures',
                      icon: Icons.monitor_weight_outlined,
                      selected: _tab == _ProfileTab.measures,
                      onTap: () => setState(() => _tab = _ProfileTab.measures),
                    ),
                    _ProfileTabChip(
                      label: 'Exercises',
                      icon: Icons.fitness_center,
                      selected: _tab == _ProfileTab.exercises,
                      onTap: () => setState(() => _tab = _ProfileTab.exercises),
                    ),
                    _ProfileTabChip(
                      label: 'My workouts',
                      icon: Icons.article_outlined,
                      selected: _tab == _ProfileTab.workouts,
                      onTap: () => setState(() => _tab = _ProfileTab.workouts),
                    ),
                    _ProfileTabChip(
                      label: l10n.t('records'),
                      icon: Icons.emoji_events_outlined,
                      selected: _tab == _ProfileTab.records,
                      onTap: () => setState(() => _tab = _ProfileTab.records),
                    ),
                    _ProfileTabChip(
                      label: l10n.t('friends'),
                      icon: Icons.groups_2_outlined,
                      selected: _tab == _ProfileTab.friends,
                      onTap: () => setState(() => _tab = _ProfileTab.friends),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              if (_tab == _ProfileTab.calendar)
                CalendarWidget(viewModel: _calendar)
              else if (_tab == _ProfileTab.stats)
                _StatsPanel(profile: _profile)
              else if (_tab == _ProfileTab.measures)
                _MetricListPanel(items: _profile.measures)
              else if (_tab == _ProfileTab.exercises)
                _MetricListPanel(items: _profile.exerciseRecords)
              else if (_tab == _ProfileTab.workouts)
                _MyWorkoutsPanel(posts: _profile.myWorkoutPosts)
              else if (_tab == _ProfileTab.records)
                _RecordsPanel(colors: colors)
              else
                _FriendsPanel(names: _profile.friends),
              const SizedBox(height: 28),
              Text(l10n.t('settings'), style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              SisuCard(
                child: Column(
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.t('dark_mode'), style: Theme.of(context).textTheme.titleMedium),
                      value: settings.themeMode == ThemeMode.dark,
                      activeColor: colors.neon,
                      onChanged: (_) => settings.toggleTheme(),
                    ),
                    const Divider(height: 24),
                    Row(
                      children: [
                        Expanded(child: Text(l10n.t('language'), style: Theme.of(context).textTheme.titleMedium)),
                        SisuChip(
                          label: 'VI',
                          selected: settings.locale.languageCode == 'vi',
                          onTap: () => settings.setLocale(const Locale('vi')),
                        ),
                        const SizedBox(width: 8),
                        SisuChip(
                          label: 'EN',
                          selected: settings.locale.languageCode == 'en',
                          onTap: () => settings.setLocale(const Locale('en')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileTabChip extends StatelessWidget {
  const _ProfileTabChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SisuChip(label: label, icon: icon, selected: selected, onTap: onTap),
    );
  }
}

class _StatsPanel extends StatelessWidget {
  const _StatsPanel({required this.profile});

  final ProfileViewModel profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            for (final stat in profile.statistics) ...[
              Expanded(
                child: SisuCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stat.value, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(stat.label, style: Theme.of(context).textTheme.bodyMedium),
                      Text(stat.caption, style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                ),
              ),
              if (stat != profile.statistics.last) const SizedBox(width: 10),
            ],
          ],
        ),
        const SizedBox(height: 16),
        const Body3DViewerWidget(),
      ],
    );
  }
}

class _MetricListPanel extends StatelessWidget {
  const _MetricListPanel({required this.items});

  final List<StatisticModel> items;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return Column(
      children: [
        for (final item in items) ...[
          SisuCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const SisuRoundIcon(icon: Icons.insights_outlined, size: 52),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.label, style: Theme.of(context).textTheme.titleMedium),
                      Text(item.caption, style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
                Text(item.value, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colors.neon)),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _MyWorkoutsPanel extends StatelessWidget {
  const _MyWorkoutsPanel({required this.posts});

  final List<String> posts;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Newest first', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        for (final post in posts) ...[
          SisuCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const SisuRoundIcon(icon: Icons.article_outlined, size: 52),
                const SizedBox(width: 14),
                Expanded(child: Text(post, style: Theme.of(context).textTheme.titleMedium)),
                Icon(Icons.chevron_right, color: colors.muted),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _RecordsPanel extends StatelessWidget {
  const _RecordsPanel({required this.colors});

  final SisuPalette colors;

  @override
  Widget build(BuildContext context) {
    final records = const [
      ('Bench Press', '120 kg x 5'),
      ('Squat', '110 kg x 3'),
      ('Deadlift', '150 kg x 2'),
    ];

    return Column(
      children: [
        for (final record in records) ...[
          SisuCard(
            child: Row(
              children: [
                const SisuRoundIcon(icon: Icons.emoji_events_outlined, size: 54),
                const SizedBox(width: 14),
                Expanded(child: Text(record.$1, style: Theme.of(context).textTheme.titleMedium)),
                Text(record.$2, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colors.neon)),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _FriendsPanel extends StatelessWidget {
  const _FriendsPanel({required this.names});

  final List<String> names;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final name in names) ...[
          SisuCard(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                SisuAvatar(name: name, size: 52),
                const SizedBox(width: 14),
                Expanded(child: Text(name, style: Theme.of(context).textTheme.titleMedium)),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
