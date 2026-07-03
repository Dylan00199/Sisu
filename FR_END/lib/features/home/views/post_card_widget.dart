import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/sisu_widgets.dart';
import '../models/post_model.dart';

class PostCardWidget extends StatelessWidget {
  const PostCardWidget({
    super.key,
    required this.post,
    this.onTap,
  });

  final PostModel post;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: SisuCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SisuAvatar(name: post.author, size: 56),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.author, style: Theme.of(context).textTheme.titleMedium),
                      Text('${post.handle} - ${post.timeAgo}', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
                Icon(Icons.more_horiz, color: colors.muted),
              ],
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final tag in post.tags)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: colors.cardAlt,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(tag, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: colors.muted)),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            Text(post.content, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 18),
            Container(
              height: 190,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Theme.of(context).dividerColor),
                gradient: LinearGradient(
                  colors: [
                    colors.cardAlt,
                    colors.neon.withOpacity(.12),
                    colors.card,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(Icons.fitness_center, color: colors.neon.withOpacity(.75), size: 58),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(Icons.favorite_border, color: colors.muted),
                const SizedBox(width: 6),
                Text('${post.likes}', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(width: 22),
                Icon(Icons.chat_bubble_outline, color: colors.muted),
                const SizedBox(width: 6),
                Text('${post.comments}', style: Theme.of(context).textTheme.bodyMedium),
                const Spacer(),
                Text('View detail', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colors.neon)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
