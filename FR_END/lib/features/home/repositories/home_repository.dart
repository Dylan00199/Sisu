import '../models/post_model.dart';
import '../models/streak_model.dart';

class HomeRepository {
  const HomeRepository();

  StreakModel getStreak() {
    return const StreakModel(currentDays: 17, monthCompleted: 22, monthTarget: 30);
  }

  List<DiscoverProfileModel> getDiscoverProfiles() {
    return const [
      DiscoverProfileModel(name: 'Kim Anh', handle: '@kimanh_fit', streakDays: 28),
      DiscoverProfileModel(name: 'Duc Pham', handle: '@ducstrength', streakDays: 14),
      DiscoverProfileModel(name: 'Bao Nguyen', handle: '@baofit99', streakDays: 42),
    ];
  }

  List<PostModel> getFeed() {
    return const [
      PostModel(
        author: 'Alex Nguyen',
        handle: '@alexfit',
        timeAgo: '2h ago',
        tags: ['Chest', 'Shoulders'],
        content: 'Morning chest + shoulders done. Hit a new PR on bench: 120kg x 5 reps. Feel unstoppable.',
        likes: 42,
        comments: 8,
        commentSamples: [
          'Kim Anh: Strong bench. Keep the same tempo next week.',
          'Duc Pham: Huge PR. Remember shoulder warmup.',
        ],
      ),
      PostModel(
        author: 'Linh Tran',
        handle: '@linhstrong',
        timeAgo: '4h ago',
        tags: ['Legs'],
        content: 'Leg day PR. Squat 110kg x 3 and still kept form clean.',
        likes: 31,
        comments: 5,
        commentSamples: [
          'Alex Nguyen: Clean depth.',
          'Bao Nguyen: Leg day energy.',
        ],
      ),
    ];
  }
}
