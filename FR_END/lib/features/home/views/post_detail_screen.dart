import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/sisu_widgets.dart';
import '../models/post_model.dart';
import 'post_card_widget.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key, required this.post});

  final PostModel post;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late int likes = widget.post.likes;
  bool liked = false;
  final TextEditingController _commentController = TextEditingController();
  late final List<String> comments = [...widget.post.commentSamples];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SisuPalette>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post detail'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SisuScreen(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostCardWidget(post: widget.post),
            const SizedBox(height: 16),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: () {
                    setState(() {
                      liked = !liked;
                      likes += liked ? 1 : -1;
                    });
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: liked ? colors.neon : colors.cardAlt,
                    foregroundColor: liked ? Theme.of(context).scaffoldBackgroundColor : colors.muted,
                  ),
                  icon: Icon(liked ? Icons.favorite : Icons.favorite_border),
                  label: Text('$likes likes'),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: Text('${comments.length} comments'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Comments', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            for (final comment in comments) ...[
              SisuCard(
                padding: const EdgeInsets.all(14),
                child: Text(comment, style: Theme.of(context).textTheme.bodyLarge),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a comment',
                      filled: true,
                      fillColor: colors.card,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  onPressed: () {
                    final value = _commentController.text.trim();
                    if (value.isEmpty) return;
                    setState(() {
                      comments.add('You: $value');
                      _commentController.clear();
                    });
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: colors.neon,
                    foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
