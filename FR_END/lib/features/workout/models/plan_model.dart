class PlanModel {
  const PlanModel({
    required this.name,
    required this.description,
    required this.daysPerWeek,
    required this.level,
  });

  final String name;
  final String description;
  final int daysPerWeek;
  final String level;
}
