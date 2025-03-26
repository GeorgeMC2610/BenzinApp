class Service {

  static Service fromJson(Map<String, dynamic> object) {
    return Service(
      id: object["id"],
      dateHappened: DateTime.parse(object["date_happened"]),
      description: object["description"],
      cost: object["cost_eur"],
      kilometersDone: object["at_km"],
      nextServiceKilometers: object["next_km"],
      location: object["location"],
    );
  }

  const Service({
    required this.id,
    required this.kilometersDone,
    required this.description,
    required this.dateHappened,

    this.nextServiceKilometers,
    this.cost,
    this.location
  });

  final int id;
  final int kilometersDone;
  final String description;
  final DateTime dateHappened;

  final int? nextServiceKilometers;
  final double? cost;
  final String? location;

}