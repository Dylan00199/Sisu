import 'package:flutter/foundation.dart';

import '../models/gym_room_model.dart';
import '../repositories/gym_room_repository.dart';

class GymMapViewModel extends ChangeNotifier {
  GymMapViewModel({GymRoomRepository repository = const GymRoomRepository()}) : _repository = repository {
    gyms = _repository.getNearbyGyms();
  }

  final GymRoomRepository _repository;
  List<GymRoomModel> gyms = [];
  String filter = 'Nearest';
  String district = 'All districts';

  List<String> get districts {
    final values = gyms.where((gym) => gym.isActive).map((gym) => gym.district).toSet().toList()..sort();
    return ['All districts', ...values];
  }

  List<GymRoomModel> get visibleGyms {
    final active = gyms.where((gym) => gym.isActive);
    final filtered = district == 'All districts' ? active : active.where((gym) => gym.district == district);
    final list = filtered.toList();
    if (filter == 'Cheapest') {
      list.sort((a, b) => a.priceLabel.compareTo(b.priceLabel));
    } else {
      list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    }
    return list;
  }

  void setFilter(String value) {
    filter = value;
    notifyListeners();
  }

  void setDistrict(String value) {
    district = value;
    notifyListeners();
  }
}
