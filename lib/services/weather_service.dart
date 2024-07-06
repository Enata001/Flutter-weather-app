import 'package:weather_app/models/coordinates.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:dio/dio.dart';

import '../models/weather_summary.dart';

class WeatherService {
  final dio = Dio();

  //Methods to return weather details


  Future<Map<String, dynamic>?> fetchCurrentWeather(
      {Function? onError, required String city}) async {
    try {
      final url =
          "${Constants.weatherBaseUrl}?q=$city&appid=${Constants.apiKey}&units=metric";

      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        onError?.call();
        throw Exception();
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        return null;
      } else {
        onError?.call();
        throw Exception(e.type);
      }
    }
  }

  Future<List<WeatherSummary>?> fetchForecastDetails(Coordinates coord, {Function? onError}) async {
    try {
      final url =
          "${Constants.forecastBaseUrl}?lat=${coord.latitude}&lon=${coord.longitude}&cnt=8&appid=${Constants.apiKey}&units=metric";

      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final result= response.data as Map<String, dynamic>;
        final list = result['list'];
        final List<WeatherSummary> summary = [];
        for (int i = 0; i < list.length; i++) {
          summary.add(WeatherSummary.fromMap(list[i]));
        }
        return summary;

      } else {
        onError?.call();
        throw Exception();
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        return null;
      } else {
        onError?.call();
        throw Exception(e.type);
      }
    }
  }}
