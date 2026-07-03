class PostModel {
  const PostModel({
    required this.author,
    required this.handle,
    required this.timeAgo,
    required this.content,
    required this.tags,
    required this.likes,
    required this.comments,
    this.commentSamples = const [],
  });

  final String author;
  final String handle;
  final String timeAgo;
  final String content;
  final List<String> tags;
  final int likes;
  final int comments;
  final List<String> commentSamples;
}

class DiscoverProfileModel {
  const DiscoverProfileModel({
    required this.name,
    required this.handle,
    required this.streakDays,
  });

  final String name;
  final String handle;
  final int streakDays;
}
