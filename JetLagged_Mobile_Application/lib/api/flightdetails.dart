import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FlightDetailsService {
  final String _baseUrl = 'https://api.aviationstack.com/v1/flights';
  final String _accessKey = 'b5073505445b539d7af74f234672a013';

  Future<List<Widget>> fetchFlightDetails(String flightIata) async {
    try {
      final Uri url =
          Uri.parse('$_baseUrl?access_key=$_accessKey&flight_iata=$flightIata');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['data'] != null && data['data'].isNotEmpty) {
          final flightData = data['data'][0];

          final String flightNumber = flightData['flight']['iata'] ?? 'N/A';
          final String airline = flightData['airline']['name'] ?? 'N/A';
          final String flightDate = flightData['flight_date'] ?? 'N/A';

          final String departureAirport =
              flightData['departure']['airport'] ?? 'N/A';
          final String scheduledDeparture =
              flightData['departure']['scheduled'] ?? 'N/A';
          final String estimatedDeparture =
              flightData['departure']['estimated'] ?? 'N/A';
          final String departureTerminal =
              flightData['departure']['terminal'] ?? 'N/A';
          final String departureGate = flightData['departure']['gate'] ?? 'N/A';
          final String departureDelay =
              flightData['departure']['delay']?.toString() ?? 'N/A';

          final String arrivalAirport =
              flightData['arrival']['airport'] ?? 'N/A';
          final String scheduledArrival =
              flightData['arrival']['scheduled'] ?? 'N/A';
          final String estimatedArrival =
              flightData['arrival']['estimated'] ?? 'N/A';
          final String arrivalTerminal =
              flightData['arrival']['terminal'] ?? 'N/A';
          final String arrivalGate = flightData['arrival']['gate'] ?? 'N/A';
          final String baggageClaim = flightData['arrival']['baggage'] ?? 'N/A';
          final String arrivalDelay =
              flightData['arrival']['delay']?.toString() ?? 'N/A';

          final String aircraftRegistration =
              flightData['aircraft']['registration'] ?? 'N/A';
          final String aircraftType = flightData['aircraft']['model'] ?? 'N/A';

          final String liveTracking =
              flightData['live'] != null ? 'Enabled' : 'Disabled';
          final String currentAltitude =
              flightData['live']?['altitude']?.toString() ?? 'N/A';
          final String currentSpeed =
              flightData['live']?['speed_horizontal']?.toString() ?? 'N/A';
          final String currentLocation = flightData['live'] != null
              ? '${flightData['live']['latitude']}° N, ${flightData['live']['longitude']}° E'
              : 'N/A';
          final String direction =
              flightData['live']?['direction']?.toString() ?? 'N/A';

          // Building the list of detail rows
          return [
            _buildDetailRow('Flight Number:', flightNumber),
            _buildDetailRow('Airline:', airline),
            _buildDetailRow('Flight Date:', flightDate),
            const Divider(),
            _buildDetailRow('Departure Airport:', departureAirport),
            _buildDetailRow('Scheduled Departure:', scheduledDeparture),
            _buildDetailRow('Estimated Departure:', estimatedDeparture),
            _buildDetailRow('Terminal:', departureTerminal),
            _buildDetailRow('Gate:', departureGate),
            _buildDetailRow('Departure Delay:', '$departureDelay minutes'),
            const Divider(),
            _buildDetailRow('Arrival Airport:', arrivalAirport),
            _buildDetailRow('Scheduled Arrival:', scheduledArrival),
            _buildDetailRow('Estimated Arrival:', estimatedArrival),
            _buildDetailRow('Terminal:', arrivalTerminal),
            _buildDetailRow('Gate:', arrivalGate),
            _buildDetailRow('Baggage Claim:', baggageClaim),
            _buildDetailRow(
                'Arrival Delay:',
                arrivalDelay == 'N/A' || arrivalDelay == '0'
                    ? 'On Time'
                    : '$arrivalDelay minutes'),
            const Divider(),
            _buildDetailRow('Aircraft Registration:', aircraftRegistration),
            _buildDetailRow('Aircraft Type:', aircraftType),
            const Divider(),
            _buildDetailRow('Live Tracking:', liveTracking),
            _buildDetailRow('Current Altitude:', '$currentAltitude ft'),
            _buildDetailRow('Current Speed:', '$currentSpeed km/h'),
            _buildDetailRow('Current Location:', currentLocation),
            _buildDetailRow('Direction:', 'Heading $direction'),
          ];
        } else {
          print('Flight data not found.');
          return [Text('Flight data not found.')];
        }
      } else {
        print(
            'Failed to fetch flight data. Status code: ${response.statusCode}');
        return [Text('Failed to fetch flight data.')];
      }
    } catch (e) {
      print('Error occurred while fetching flight data: $e');
      return [Text('Error occurred while fetching flight data.')];
    }
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
