import '../models/statistic_model.dart';
import '../models/user_model.dart';

class ProfileRepository {
  const ProfileRepository();

  UserModel getUser() {
    return const UserModel(
      name: 'Alex Nguyen',
      handle: '@alexfit',
      location: 'Ho Chi Minh City',
      workouts: 134,
      friends: 47,
      streak: 17,
    );
  }

  List<int> getCompletedDays(DateTime month) {
    return const [1, 2, 4, 5, 7, 8, 9, 11, 13, 14, 15, 16, 18, 19, 21, 22, 23];
  }

  List<StatisticModel> getStatistics() {
    return const [
      StatisticModel(label: 'Volume', value: '18.6t', caption: 'This month'),
      StatisticModel(label: 'Top muscle', value: 'Chest', caption: '28% focus'),
      StatisticModel(label: 'Best lift', value: '120kg', caption: 'Bench press'),
    ];
  }

  List<StatisticModel> getMeasures() {
    return const [
      StatisticModel(label: 'Weight', value: '72.4kg', caption: '-1.2kg this month'),
      StatisticModel(label: 'Body fat', value: '15.8%', caption: 'Estimated'),
      StatisticModel(label: 'Chest', value: '98cm', caption: '+2cm in 8 weeks'),
      StatisticModel(label: 'Waist', value: '78cm', caption: 'Stable'),
    ];
  }

  List<StatisticModel> getExerciseRecords() {
    return const [
      StatisticModel(label: 'Bench Press', value: '120kg x 5', caption: 'Chest'),
      StatisticModel(label: 'Squat', value: '110kg x 3', caption: 'Legs'),
      StatisticModel(label: 'Deadlift', value: '150kg x 2', caption: 'Back'),
      StatisticModel(label: 'Shoulder Press', value: '42kg x 8', caption: 'Shoulders'),
    ];
  }

  List<String> getMyWorkoutPosts() {
    return const [
      'Today - Push Day A - Chest and shoulders',
      'Yesterday - Pull Day B - Back and biceps',
      '2 days ago - Leg Day C - Squat focus',
    ];
  }

  List<String> getFriends() {
    return const ['Kim Anh', 'Duc Pham', 'Linh Tran', 'Bao Nguyen'];
  }
}
