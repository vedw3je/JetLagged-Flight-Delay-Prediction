import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jetlagged/api/fetchweather.dart';
import 'package:jetlagged/models/AirlineRating.dart';
import 'package:jetlagged/models/AirportRating.dart';
import 'package:jetlagged/models/Airportdistance.dart';
import 'package:jetlagged/models/Airporttocode.dart';

import 'flight_delay_api.dart';

class FlightService {
  final String _baseUrl = 'https://api.aviationstack.com/v1/flights';

  final String _accessKey = 'b5073505445b539d7af74f234672a013';

  Future<Map<String, double>?> fetchLatLong(String flightIata) async {
    try {
      final Uri url =
          Uri.parse('$_baseUrl?access_key=$_accessKey&flight_iata=$flightIata');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['data'] != null && data['data'].isNotEmpty) {
          final flightData = data['data'][0];
          final liveData = flightData['live'];

          if (liveData != null) {
            return {
              'latitude': liveData['latitude'],
              'longitude': liveData['longitude'],
            };
          } else {
            print('Live flight data not available.');
            return null;
          }
        } else {
          print('Flight data not found.');
          return null;
        }
      } else {
        print(
            'Failed to fetch flight data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching flight data: $e');
      return null;
    }
  }

  Future<double> getFinalPrediction(String flightIata) async {
    double predictedDelay = 0;

    try {
      final Uri url =
          Uri.parse('$_baseUrl?access_key=$_accessKey&flight_iata=$flightIata');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['data'] != null && data['data'].isNotEmpty) {
          final flightData = data['data'][0];
          final liveData = flightData['live'];
          final String airline = flightData['airline']['name'] ?? 'N/A';
          String weather = '';
          int departuredelay = flightData['departure']['delay'] ?? 0;

          String departure = flightData['departure']['airport'] ?? 'N/A';
          String from = getAirportCode(departure) ?? 'MUM';
          String arrival = flightData['arrival']['airport'] ?? 'N/A';
          String to = getAirportCode(arrival) ?? 'DEL';
          if (liveData != null) {
            weather = await fetchWeatherConditionByLatLon(
                    liveData['latitude'], liveData['longitude']) ??
                'Cloudy';
          }

          int distance = getDistanceBetweenAirports(from, to) ?? 1000;
          double airportRating = getAirportRating(to) ?? 0.5;
          double airlineRating = getAirlineRating(airline) ?? 0.5;

          if (liveData == null) {
            departuredelay = 0;
            weather = (await fetchWeatherCondition(from)) ?? 'Cloudy';
          }

          Map<String, dynamic> predictionFlightData = {
            'From': from,
            'To': to,
            'Departure Delay': departuredelay,
            'Airline': airline,
            'Simplified_Weather': weather,
            'Distance': distance,
            'Airline Rating': airlineRating,
            'Airport Rating': airportRating,
          };

          double delay = await predictFlightDelay(predictionFlightData);
          predictedDelay = delay;
        }
      }
    } catch (e) {
      print('Error occurred while fetching flight data: $e');
    }

    return predictedDelay;
  }
}
