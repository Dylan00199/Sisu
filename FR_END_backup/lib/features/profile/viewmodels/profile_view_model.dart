import 'package:flutter/foundation.dart';

import '../models/statistic_model.dart';
import '../models/user_model.dart';
import '../repositories/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({ProfileRepository repository = const ProfileRepository()}) : _repository = repository {
    load();
  }

  final ProfileRepository _repository;
  late UserModel user;
  List<StatisticModel> statistics = [];
  List<StatisticModel> measures = [];
  List<StatisticModel> exerciseRecords = [];
  List<String> myWorkoutPosts = [];
  List<String> friends = [];

  void load() {
    user = _repository.getUser();
    statistics = _repository.getStatistics();
    measures = _repository.getMeasures();
    exerciseRecords = _repository.getExerciseRecords();
    myWorkoutPosts = _repository.getMyWorkoutPosts();
    friends = _repository.getFriends();
  }
}
