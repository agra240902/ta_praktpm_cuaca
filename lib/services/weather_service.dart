// weather_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  Future<List<dynamic>> fetchWeatherData() async {
    final response = await http.get(
        Uri.parse('https://ibnux.github.io/BMKG-importer/cuaca/wilayah.json'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
