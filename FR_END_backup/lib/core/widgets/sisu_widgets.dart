import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SisuScreen extends StatelessWidget {
  const SisuScreen({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(24, 22, 24, 22),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: padding,
        child: child,
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return Row(
      children: [
        Expanded(
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.muted,
                  letterSpacing: 2.4,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              action!,
              style: TextStyle(color: colors.neon, fontWeight: FontWeight.w900),
            ),
          ),
      ],
    );
  }
}

class SisuCard extends StatelessWidget {
  const SisuCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.color,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return Container(
      decoration: BoxDecoration(
        color: color ?? colors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor ?? Theme.of(context).dividerColor),
      ),
      padding: padding,
      child: child,
    );
  }
}

class SisuChip extends StatelessWidget {
  const SisuChip({
    super.key,
    required this.label,
    this.selected = false,
    this.icon,
    this.onTap,
  });

  final String label;
  final bool selected;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? colors.neon : colors.cardAlt,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: selected ? Theme.of(context).scaffoldBackgroundColor : colors.muted,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: selected ? Theme.of(context).scaffoldBackgroundColor : colors.muted,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class SisuAvatar extends StatelessWidget {
  const SisuAvatar({
    super.key,
    required this.name,
    this.size = 58,
  });

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;
    final initials = name
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => part.substring(0, 1))
        .take(2)
        .join()
        .toUpperCase();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colors.neon, width: 3),
        gradient: const LinearGradient(
          colors: [Color(0xFF9DB7FF), Color(0xFF1B2A5A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * .28,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class SisuMetric extends StatelessWidget {
  const SisuMetric({
    super.key,
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: colors.neon),
        ),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class SisuRoundIcon extends StatelessWidget {
  const SisuRoundIcon({
    super.key,
    required this.icon,
    this.size = 58,
    this.color,
  });

  final IconData icon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color ?? colors.neon.withOpacity(.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: colors.neon, size: size * .48),
    );
  }
}
