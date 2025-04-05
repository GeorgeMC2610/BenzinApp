class Car {

  static Car fromJson(Map<String, dynamic> object) {
    return Car(
      id: object["id"],
      username: object["username"],
      manufacturer: object["manufacturer"],
      model: object["model"],
      year: object["year"]
    );
  }

  Car({
    required this.id,
    required this.username,
    required this.manufacturer,
    required this.model,
    required this.year
  });

  final int id;
  final String username;
  final String manufacturer;
  final String model;
  final int year;
}