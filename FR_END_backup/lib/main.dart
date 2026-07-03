import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';

import 'core/l10n/app_localizations.dart';
import 'core/settings/app_settings.dart';
import 'core/theme/app_theme.dart';
import 'features/ai_assistant/views/ai_chat_screen.dart';
import 'features/gym_room/views/gym_map_screen.dart';
import 'features/home/views/home_screen.dart';
import 'features/notification/views/notification_screen.dart';
import 'features/profile/views/profile_screen.dart';
import 'features/workout/views/workout_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const SisuApp());
}

class SisuApp extends StatefulWidget {
  const SisuApp({super.key});

  @override
  State<SisuApp> createState() => _SisuAppState();
}

class _SisuAppState extends State<SisuApp> {
  final AppSettings _settings = AppSettings();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _settings,
      builder: (context, _) {
        return SettingsScope(
          settings: _settings,
          child: MaterialApp(
            title: 'Sisu',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _settings.themeMode,
            locale: _settings.locale,
            supportedLocales: const [Locale('en'), Locale('vi')],
            localizationsDelegates: const [
              SisuLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const MainShell(),
          ),
        );
      },
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _openAiCoach() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AiChatScreen()),
    );
  }

  void _openGymRooms() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const GymMapScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onOpenAiCoach: _openAiCoach, onOpenGymRooms: _openGymRooms),
      const WorkoutScreen(),
      const ProfileScreen(),
      const NotificationScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: SisuBottomNav(
        currentIndex: _index,
        onChanged: (value) => setState(() => _index = value),
      ),
    );
  }
}

class SisuBottomNav extends StatelessWidget {
  const SisuBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      _BottomItem(Icons.home_outlined, l10n.t('nav_home')),
      _BottomItem(Icons.fitness_center, l10n.t('nav_workout')),
      _BottomItem(Icons.person_outline, l10n.t('nav_profile')),
      _BottomItem(Icons.notifications_none, l10n.t('nav_alerts')),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 18),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < items.length; i++)
              Expanded(
                child: _BottomNavButton(
                  item: items[i],
                  selected: currentIndex == i,
                  onTap: () => onChanged(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BottomItem {
  const _BottomItem(this.icon, this.label);

  final IconData icon;
  final String label;
}

class _BottomNavButton extends StatelessWidget {
  const _BottomNavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _BottomItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 82,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: selected ? Border.all(color: colors.selectedBorder, width: 2) : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: selected ? colors.neon.withOpacity(.16) : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.icon,
                      color: selected ? colors.neon : colors.muted,
                      size: 30,
                    ),
                  ),
                  if (item.icon == Icons.notifications_none)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: colors.alert,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                item.label,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: selected ? colors.neon : colors.muted,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
