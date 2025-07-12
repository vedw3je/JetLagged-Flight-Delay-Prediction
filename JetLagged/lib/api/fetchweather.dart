import 'dart:convert';
import 'package:http/http.dart' as http;

// Function to fetch the weather condition text
Future<String?> fetchWeatherCondition(String location) async {
  const String apiKey = '008409ae4d2f40c395b165938242110';
  final String url =
      'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$location';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Extracting the condition text
      final String conditionText =
          data['current']['condition']['text'] as String;

      return conditionText;
    } else {
      print('Failed to load weather data');
      return "Sunny";
    }
  } catch (e) {
    print('Error fetching weather data: $e');
    return "Cloudy";
  }
}

Future<String?> fetchWeatherConditionByLatLon(
    double latitude, double longitude) async {
  const String apiKey = '008409ae4d2f40c395b165938242110';
  final String url =
      'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$latitude,$longitude';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Extracting the condition text
      final String conditionText =
          data['current']['condition']['text'] as String;

      return conditionText;
    } else {
      print('Failed to load weather data');
      return "Sunny";
    }
  } catch (e) {
    print('Error fetching weather data: $e');
    return "Cloudy";
  }
}
