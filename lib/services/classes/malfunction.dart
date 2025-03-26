class Malfunction {

  static Malfunction fromJson(Map<String, dynamic> object) {
    return Malfunction(
      id: object["id"],
      dateStarted: DateTime.parse(object["started"]),
      dateEnded: object["ended"] == null ? null : DateTime.parse(object["ended"]),
      title: object["title"],
      description: object["description"],
      cost: object["cost_eur"],
      kilometersDiscovered: object["at_km"],
      location: object["location"],
    );
  }

  const Malfunction({
    required this.id,
    required this.dateStarted,
    required this.description,
    required this.title,
    required this.kilometersDiscovered,

    this.dateEnded,
    this.cost,
    this.location,
  });

  final int id;
  final DateTime dateStarted;
  final String description;
  final String title;
  final int kilometersDiscovered;

  final DateTime? dateEnded;
  final double? cost;
  final String? location;

  bool isFixed () {
    return dateEnded != null;
  }
}