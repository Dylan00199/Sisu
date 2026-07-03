import 'package:flutter/foundation.dart';

import '../models/post_model.dart';
import '../models/streak_model.dart';
import '../repositories/home_repository.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({HomeRepository repository = const HomeRepository()}) : _repository = repository {
    load();
  }

  final HomeRepository _repository;

  late StreakModel streak;
  List<DiscoverProfileModel> discoverProfiles = [];
  List<PostModel> feed = [];

  void load() {
    streak = _repository.getStreak();
    discoverProfiles = _repository.getDiscoverProfiles();
    feed = _repository.getFeed();
  }
}
