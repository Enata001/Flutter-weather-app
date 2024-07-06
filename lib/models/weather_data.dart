import 'dart:convert';

class WeatherData {
  final String name;
  final String country;
  final double temperature;
  final String condition;
  final double windSpeed;
  final double humidity;
  final double latitude;
  final double longitude;
  final double pressure;
  final String icon;


  const WeatherData({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.country,
    required this.temperature,
    required this.condition,
    required this.windSpeed,
    required this.humidity,
    required this.pressure,
    required this.icon,
  });

  @override
  String toString() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'country' : country,
      'temperature': temperature,
      'condition': condition,
      'windSpeed': windSpeed,
      'humidity': humidity,
      'latitude': latitude,
      'pressure': pressure,
      'longitude': longitude,
      'icon':icon,
    };
  }

  factory WeatherData.fromMap(Map<String, dynamic> map) {
    return WeatherData(
      name: map['name'],
      country: map['sys']['country'],
      temperature: map['main']['temp'],
      pressure: (map['main']['pressure']).toDouble(),
      condition: map['weather'][0]['description'],
      windSpeed: map['wind']['speed'],
      humidity: (map['main']['humidity']).toDouble(),
      latitude: map['coord']['lat'],
      longitude: map['coord']['lon'],
      icon: map['weather'][0]['icon'],
    );
  }
}
