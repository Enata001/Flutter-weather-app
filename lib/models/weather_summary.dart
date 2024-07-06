import 'dart:convert';

class WeatherSummary {
  final String time;
  final double temperature;
  final String icon;

  const WeatherSummary({
    required this.time,
    required this.temperature,
    required this.icon,
  });

  @override
  String toString() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'temperature': temperature,
      'icon': icon,
    };
  }

  factory WeatherSummary.fromMap(Map<String, dynamic> map) {
    return WeatherSummary(
      time: map['dt_txt'],
      temperature: (map['main']['temp']).toDouble(),
      icon: map['weather'][0]['icon'],
    );
  }
}
