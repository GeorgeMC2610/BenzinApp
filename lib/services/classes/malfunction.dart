class Malfunction {

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

}