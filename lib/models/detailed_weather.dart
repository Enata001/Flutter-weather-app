import 'dart:convert';

import 'package:weather_app/models/weather_summary.dart';
import 'package:weather_app/services/weather_service.dart';

class DetailedWeatherData {
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
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final List<WeatherSummary> summary;

  const DetailedWeatherData({
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
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.summary,
  });

  @override
  String toString() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'country': country,
      'temperature': temperature,
      'condition': condition,
      'windSpeed': windSpeed,
      'humidity': humidity,
      'latitude': latitude,
      'pressure': pressure,
      'longitude': longitude,
      'icon': icon,
      'feelsLike': feelsLike,
      'tempMin': tempMin,
      'tempMax': tempMax,
      // 'summary': summary,
    };
  }


  factory DetailedWeatherData.fromMap(Map<String, dynamic> map) {
    return DetailedWeatherData(
      name: map['name'],
      country: map['sys']['country'],
      temperature: map['main']['temp'],
      feelsLike: map['main']['feels_like'],
      tempMin: map['main']['temp_min'],
      tempMax: map['main']['temp_max'],
      pressure: (map['main']['pressure']).toDouble(),
      condition: map['weather'][0]['description'],
      windSpeed: map['wind']['speed'],
      humidity: (map['main']['humidity']).toDouble(),
      latitude: map['coord']['lat'],
      longitude: map['coord']['lon'],
      icon: map['weather'][0]['icon'],
      summary: []
    );
  }
}
