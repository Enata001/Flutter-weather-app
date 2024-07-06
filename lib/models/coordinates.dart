import 'dart:convert';

class Coordinates {
  final String name;
  final double latitude;
  final double longitude;

  Coordinates(
      {required this.name, required this.latitude, required this.longitude});

  @override
  String toString() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Coordinates.fromMap(Map<String, dynamic> map) {
    return Coordinates(
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
