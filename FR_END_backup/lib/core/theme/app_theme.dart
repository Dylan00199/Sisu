import 'package:flutter/material.dart';

@immutable
class SisuPalette extends ThemeExtension<SisuPalette> {
  const SisuPalette({
    required this.neon,
    required this.limeSoft,
    required this.card,
    required this.cardAlt,
    required this.muted,
    required this.alert,
    required this.selectedBorder,
    required this.successSoft,
  });

  final Color neon;
  final Color limeSoft;
  final Color card;
  final Color cardAlt;
  final Color muted;
  final Color alert;
  final Color selectedBorder;
  final Color successSoft;

  @override
  SisuPalette copyWith({
    Color? neon,
    Color? limeSoft,
    Color? card,
    Color? cardAlt,
    Color? muted,
    Color? alert,
    Color? selectedBorder,
    Color? successSoft,
  }) {
    return SisuPalette(
      neon: neon ?? this.neon,
      limeSoft: limeSoft ?? this.limeSoft,
      card: card ?? this.card,
      cardAlt: cardAlt ?? this.cardAlt,
      muted: muted ?? this.muted,
      alert: alert ?? this.alert,
      selectedBorder: selectedBorder ?? this.selectedBorder,
      successSoft: successSoft ?? this.successSoft,
    );
  }

  @override
  SisuPalette lerp(ThemeExtension<SisuPalette>? other, double t) {
    if (other is! SisuPalette) return this;
    return SisuPalette(
      neon: Color.lerp(neon, other.neon, t)!,
      limeSoft: Color.lerp(limeSoft, other.limeSoft, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardAlt: Color.lerp(cardAlt, other.cardAlt, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      alert: Color.lerp(alert, other.alert, t)!,
      selectedBorder: Color.lerp(selectedBorder, other.selectedBorder, t)!,
      successSoft: Color.lerp(successSoft, other.successSoft, t)!,
    );
  }
}

class AppTheme {
  static const _neon = Color(0xFFB5FF3B);
  static const _alert = Color(0xFFFF4D73);

  static ThemeData get darkTheme {
    const bg = Color(0xFF090910);
    const surface = Color(0xFF111118);
    const card = Color(0xFF181820);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary: _neon,
        secondary: Color(0xFF7EE8FA),
        surface: surface,
        background: bg,
        error: _alert,
      ),
      dividerColor: const Color(0xFF24242F),
      textTheme: _textTheme(Colors.white, const Color(0xFF7E7C99)),
      extensions: const [
        SisuPalette(
          neon: _neon,
          limeSoft: Color(0xFF263F06),
          card: card,
          cardAlt: Color(0xFF20202A),
          muted: Color(0xFF77748F),
          alert: _alert,
          selectedBorder: Colors.white,
          successSoft: Color(0xFF15240F),
        ),
      ],
    );
  }

  static ThemeData get lightTheme {
    const bg = Color(0xFFF8FAF6);
    const surface = Colors.white;
    const card = Color(0xFFF0F3EC);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF78C800),
        secondary: Color(0xFF1388A9),
        surface: surface,
        background: bg,
        error: _alert,
      ),
      dividerColor: const Color(0xFFE4E7DF),
      textTheme: _textTheme(const Color(0xFF11131B), const Color(0xFF777B8E)),
      extensions: const [
        SisuPalette(
          neon: Color(0xFF78C800),
          limeSoft: Color(0xFFE5F8C6),
          card: card,
          cardAlt: Color(0xFFE7EADF),
          muted: Color(0xFF777B8E),
          alert: _alert,
          selectedBorder: Color(0xFF11131B),
          successSoft: Color(0xFFEAF9D6),
        ),
      ],
    );
  }

  static TextTheme _textTheme(Color strong, Color muted) {
    return TextTheme(
      headlineLarge: TextStyle(
        color: strong,
        fontSize: 34,
        fontWeight: FontWeight.w900,
        height: 1.05,
      ),
      headlineMedium: TextStyle(
        color: strong,
        fontSize: 28,
        fontWeight: FontWeight.w900,
        height: 1.08,
      ),
      titleLarge: TextStyle(
        color: strong,
        fontSize: 22,
        fontWeight: FontWeight.w900,
      ),
      titleMedium: TextStyle(
        color: strong,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
      bodyLarge: TextStyle(color: strong, fontSize: 16, height: 1.45),
      bodyMedium: TextStyle(color: muted, fontSize: 14, height: 1.45),
      labelLarge: TextStyle(color: strong, fontWeight: FontWeight.w800),
      labelMedium: TextStyle(
        color: muted,
        fontSize: 13,
        letterSpacing: 0,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
