import 'dart:convert';
import 'package:http/http.dart' as http;

Future<double> predictFlightDelay(Map<String, dynamic> flightData) async {
  final url = Uri.parse('http://192.168.133.99:5000/predict');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(flightData),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['predicted_delay'];
  } else {
    throw Exception('Failed to load prediction');
  }
}

Future<String> fetchFlightInfo(String userPrompt) async {
  const String baseUrl =
      "https://a83a-2409-40c0-d-9395-1d7b-5e7e-cd66-7b4c.ngrok-free.app/get-flight-info";
  final Uri url = Uri.parse(baseUrl);

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_prompt': userPrompt}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['deepseek_context_response'] ?? "No response available";
    } else {
      return "Failed to fetch flight info";
    }
  } catch (e) {
    return "Failed to fetch flight info: $e";
  }
}
