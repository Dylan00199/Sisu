import '../models/gym_room_model.dart';

class GymRoomRepository {
  const GymRoomRepository();

  List<GymRoomModel> getNearbyGyms() {
    return const [
      GymRoomModel(
        name: 'Sisu Strength Lab',
        address: 'District 1, Ho Chi Minh City',
        district: 'District 1',
        distanceKm: 1.2,
        openUntil: '22:00',
        priceLabel: '80k/day',
        phone: '0901 222 333',
        rating: 4.8,
        isActive: true,
      ),
      GymRoomModel(
        name: 'Iron Base Fitness',
        address: 'Binh Thanh, Ho Chi Minh City',
        district: 'Binh Thanh',
        distanceKm: 2.8,
        openUntil: '23:00',
        priceLabel: '60k/day',
        phone: '0902 333 444',
        rating: 4.6,
        isActive: true,
      ),
      GymRoomModel(
        name: 'GreenFit Studio',
        address: 'District 3, Ho Chi Minh City',
        district: 'District 3',
        distanceKm: 3.4,
        openUntil: '21:30',
        priceLabel: '120k/day',
        phone: '0903 444 555',
        rating: 4.7,
        isActive: true,
      ),
      GymRoomModel(
        name: 'Closed Demo Gym',
        address: 'District 7, Ho Chi Minh City',
        district: 'District 7',
        distanceKm: 8.2,
        openUntil: 'Closed',
        priceLabel: 'N/A',
        phone: 'N/A',
        rating: 3.9,
        isActive: false,
      ),
    ];
  }
}
