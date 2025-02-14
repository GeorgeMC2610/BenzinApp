class Service {

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