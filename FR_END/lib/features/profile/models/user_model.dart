class UserModel {
  const UserModel({
    required this.name,
    required this.handle,
    required this.location,
    required this.workouts,
    required this.friends,
    required this.streak,
  });

  final String name;
  final String handle;
  final String location;
  final int workouts;
  final int friends;
  final int streak;
}
