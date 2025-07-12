import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:jetlagged/api/flightdetails.dart';

import 'package:jetlagged/api/flightlivelocation.dart';
import 'package:latlong2/latlong.dart';

class IndiaMapScreen extends StatefulWidget {
  @override
  State<IndiaMapScreen> createState() => _IndiaMapScreenState();
}

class _IndiaMapScreenState extends State<IndiaMapScreen> {
  LatLng? _flightPosition;
  final TextEditingController _flightNumberController = TextEditingController();
  late final MapController _mapController;
  final FlightService _flightService = FlightService();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _flightNumberController.dispose();
    super.dispose();
  }

  void _trackFlight() async {
    String flightNumber = _flightNumberController.text.trim();

    if (flightNumber.isNotEmpty) {
      Map<String, double>? position =
          await _flightService.fetchLatLong(flightNumber);

      setState(() {
        _flightPosition =
            LatLng(position!['latitude']!, position['longitude']!);
        _mapController.move(_flightPosition!, 10.0);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a flight number.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _showFlightDetails(String flightIata) async {
    final flightDetailsService = FlightDetailsService();

    List<Widget> flightDetails =
        await flightDetailsService.fetchFlightDetails(flightIata);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Flight Details'),
          content: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/airindia.png'),
                    backgroundColor: Colors.blueAccent,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: flightDetails,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
          backgroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          contentTextStyle: const TextStyle(
            color: Colors.blueAccent,
            fontSize: 16,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 217, 241, 255),
      appBar: AppBar(
        title: const Text(
          'JetLagged',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10,
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.lightBlue[50]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _flightNumberController,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.blue,
                ),
                decoration: const InputDecoration(
                  labelText: 'Enter Flight Number',
                  labelStyle: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blueAccent,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                _trackFlight();

                FocusScope.of(context).unfocus();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text(
                'Track Flight',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blueAccent,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: FlutterMap(
                  mapController: _mapController,
                  options: const MapOptions(
                    backgroundColor: Colors.blue,
                    initialCenter: LatLng(20.5937, 78.9629),
                    initialZoom: 5.0,
                    minZoom: 3.0,
                    maxZoom: 18.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    if (_flightPosition != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _flightPosition!,
                            width: 30,
                            height: 30,
                            child: GestureDetector(
                                onTap: () {
                                  _showFlightDetails(
                                      _flightNumberController.text);
                                },
                                child: const Icon(
                                  Icons.flight_rounded,
                                  color: Color.fromARGB(255, 0, 31, 56),
                                  size: 30,
                                )),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
