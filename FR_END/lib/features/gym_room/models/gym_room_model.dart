class GymRoomModel {
  const GymRoomModel({
    required this.name,
    required this.address,
    required this.district,
    required this.distanceKm,
    required this.openUntil,
    required this.priceLabel,
    required this.phone,
    required this.rating,
    required this.isActive,
  });

  final String name;
  final String address;
  final String district;
  final double distanceKm;
  final String openUntil;
  final String priceLabel;
  final String phone;
  final double rating;
  final bool isActive;
}
