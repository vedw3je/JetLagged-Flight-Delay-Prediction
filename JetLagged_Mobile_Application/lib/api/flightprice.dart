import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchFlightprice({
  required String from,
  required String to,
  required String date,
}) async {
  final Uri url = Uri.parse(
    "http://192.168.172.242:5000/api/flights?from=$from&to=$to&date=$date",
  );

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['success'] == true && data['flights'] != null) {
        List flights = data['flights'];
        return List<Map<String, dynamic>>.from(flights);
      } else {
        throw Exception('No flights found or request failed.');
      }
    } else {
      throw Exception('Failed to fetch flights: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching flights: $e');
  }
}
