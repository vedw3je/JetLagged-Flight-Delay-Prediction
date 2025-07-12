import 'package:flutter/material.dart';
import 'package:jetlagged/models/airlinelogos.dart';

class FlightCard extends StatelessWidget {
  final Map<String, dynamic> flight;

  const FlightCard({Key? key, required this.flight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String logoPath = AirlineLogos.getLogo(flight['airline']);
    return Card(
      elevation: 10,
      shadowColor: Colors.blueAccent, // Shadow color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade200,
              Colors.blue.shade400
            ], // Blue gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius:
              BorderRadius.circular(15), // Rounded corners for container
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16), // Padding inside the card
          leading: Image.asset(
            logoPath,
            height: 50,
            width: 50,
          ),
          title: Text(
            flight['airline'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'From: ${flight['from']}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              Text(
                'To: ${flight['to']}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              Text(
                'Price: ₹${flight['price']}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              Text(
                'Average Delay: ${flight['Total Delay']} min',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
