class Trip {
  static Trip fromJson(Map<String, dynamic> object) {
    return Trip(
        id: object["id"],
        title: object["title"],
        timesRepeating: object["times_repeating"],
        totalKm: object["total_km"],
        created: DateTime.parse(object["created_at"]),
        updated: DateTime.parse(object["updated_at"]),
        originLatitude: object["origin_latitude"],
        originLongitude: object["origin_longitude"],
        destinationLatitude: object["destination_latitude"],
        destinationLongitude: object["destination_longitude"],
        originAddress: object["origin_address"],
        destinationAddress: object["destination_address"],
        polyline: object["polyline"],
    );
  }

  const Trip({
    required this.id,
    required this.title,
    required this.timesRepeating,
    required this.totalKm,
    required this.created,
    required this.updated,
    required this.originLatitude,
    required this.originLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.originAddress,
    required this.destinationAddress,
    required this.polyline,
  });

  final int id;
  final String title;
  final int timesRepeating;
  final double totalKm;
  final DateTime created;
  final DateTime updated;
  final double originLatitude;
  final double originLongitude;
  final double destinationLatitude;
  final double destinationLongitude;
  final String originAddress;
  final String destinationAddress;
  final String polyline;
}