import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/sisu_logo.dart';
import '../../../core/widgets/sisu_widgets.dart';
import '../models/post_model.dart';
import '../viewmodels/home_view_model.dart';
import 'post_card_widget.dart';
import 'post_detail_screen.dart';
import 'public_profile_screen.dart';
import 'streak_banner_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.onOpenAiCoach,
    required this.onOpenGymRooms,
  });

  final VoidCallback onOpenAiCoach;
  final VoidCallback onOpenGymRooms;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();
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
                  const SisuLogo(compact: true),
                  const Spacer(),
                  IconButton.filled(
                    onPressed: _showSearchSheet,
                    style: IconButton.styleFrom(
                      backgroundColor: colors.cardAlt,
                      foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    icon: const Icon(Icons.search, size: 30),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                l10n.t('good_morning'),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      letterSpacing: 2,
                      color: colors.muted,
                    ),
              ),
              const SizedBox(height: 8),
              Text('Alex Nguyen', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 26),
              StreakBannerWidget(streak: _viewModel.streak),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      title: l10n.t('ai_coach'),
                      subtitle: l10n.t('ask_coach'),
                      icon: Icons.auto_awesome,
                      onTap: widget.onOpenAiCoach,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickActionCard(
                      title: l10n.t('gym_rooms'),
                      subtitle: l10n.t('nearby_gyms'),
                      icon: Icons.location_on_outlined,
                      onTap: widget.onOpenGymRooms,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              SectionHeader(title: l10n.t('discover'), action: l10n.t('see_all')),
              const SizedBox(height: 12),
              SizedBox(
                height: 210,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _viewModel.discoverProfiles.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final profile = _viewModel.discoverProfiles[index];
                    return _DiscoverCard(
                      profile: profile,
                      onTap: () => _openPublicProfile(profile),
                    );
                  },
                ),
              ),
              const SizedBox(height: 26),
              SectionHeader(title: l10n.t('feed')),
              const SizedBox(height: 12),
              for (final post in _viewModel.feed) ...[
                PostCardWidget(
                  post: post,
                  onTap: () => _openPostDetail(post),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        );
      },
    );
  }

  void _openPublicProfile(DiscoverProfileModel profile) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PublicProfileScreen(profile: profile)),
    );
  }

  void _openPostDetail(PostModel post) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
    );
  }

  void _showSearchSheet() {
    final colors = Theme.of(context).extension<SisuPalette>()!;
    final profiles = _viewModel.discoverProfiles;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Search', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 14),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search users or posts',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: colors.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text('Suggested profiles', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              for (final profile in profiles)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: SisuAvatar(name: profile.name, size: 44),
                  title: Text(profile.name),
                  subtitle: Text(profile.handle),
                  trailing: Text('${profile.streakDays}d', style: TextStyle(color: colors.neon)),
                  onTap: () {
                    Navigator.pop(context);
                    _openPublicProfile(profile);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: SisuCard(
        padding: const EdgeInsets.all(16),
        color: colors.cardAlt,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colors.neon, size: 28),
            const SizedBox(height: 14),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              subtitle,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscoverCard extends StatelessWidget {
  const _DiscoverCard({
    required this.profile,
    required this.onTap,
  });

  final DiscoverProfileModel profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: SizedBox(
        width: 152,
        child: SisuCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SisuAvatar(name: profile.name, size: 90),
              const SizedBox(height: 14),
              Text(
                profile.name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 2),
              Text(
                profile.handle,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_fire_department_outlined, color: colors.neon, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${profile.streakDays}d',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colors.neon,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
