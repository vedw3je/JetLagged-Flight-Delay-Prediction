import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jetlagged/api/flightlivelocation.dart';
import 'package:jetlagged/pages/flightnews.dart';
import 'package:jetlagged/pages/flightsearchpage.dart';
import 'package:jetlagged/pages/jetpal.dart';
import 'package:jetlagged/pages/mapscreen.dart';
import 'package:video_player/video_player.dart';
import 'package:lottie/lottie.dart';
import '../api/flight_delay_api.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _flightNumberController = TextEditingController();
  bool isLoading = false;
  double? predictedDelay;
  String? flightInfo;
  bool isDelayInfoLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _flightNumberController.dispose();

    super.dispose();
  }

  int _selectedIndex = 0;

  void fetchPrediction() async {
    setState(() {
      isLoading = true;
    });

    String flightIata = _flightNumberController.text;
    double delay = await FlightService().getFinalPrediction(flightIata);

    setState(() {
      predictedDelay = delay;
      isLoading = false;
    });
  }

  void getFlightDetails() async {
    setState(() {
      isDelayInfoLoading = true;
    });

    try {
      String flightIata = _flightNumberController.text;
      String result =
          await fetchFlightInfo("is my flight $flightIata delayed?");
      setState(() {
        flightInfo = result;
      });
    } catch (e) {
      setState(() {
        flightInfo = "Could not fetch flight info at the moment";
      });
    } finally {
      setState(() {
        isDelayInfoLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      // Index of the Live Track item
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                IndiaMapScreen()), // Navigate to IndiaMapScreen
      );
    } else if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FlightSearchPage()));
    } else {
      setState(() {
        _selectedIndex = index; // Set the selected index
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        elevation: 20,
        backgroundColor: const Color.fromARGB(255, 217, 241, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(80),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Center(
              child: Image.asset(
                'assets/jetlaggedlogo.png',
                fit: BoxFit.cover,
                width: 150,
                height: 150,
              ),
            ),

            // Flight News Card
            buildCustomCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlightNews(),
                  ),
                );
              },
              icon: Icons.newspaper,
              title: 'Flight News',
              gradientColors: [
                Color.fromARGB(255, 54, 137, 238),
                Color.fromARGB(255, 124, 190, 255),
              ],
            ),
            // Airports Card
            buildCustomCard(
              onTap: () {},
              icon: Icons.local_airport,
              title: 'Airports',
              gradientColors: [
                Color.fromARGB(255, 10, 116, 206),
                Color.fromARGB(255, 131, 200, 255),
              ],
            ),

            // Airlines Card
            buildCustomCard(
              onTap: () {},
              icon: Icons.flight,
              title: 'Airlines',
              gradientColors: [
                Color.fromARGB(255, 0, 102, 204),
                Color.fromARGB(255, 150, 220, 255),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Predict',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Live Track',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.flight_takeoff_rounded), label: 'Search FLights')

          ///
          ///items
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => JetPalScreen()),
          );
        },
        splashColor: Colors.blue,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Image.asset(
          'assets/jetpal.png',
          fit: BoxFit.cover,
          width: 70,
          height: 70,
        ),
      ),
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.normal),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Lottie.asset(
                'assets/animation.json',
                width: 150,
                height: 150,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12.0),
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
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                  ),
                  backgroundColor:
                      WidgetStateProperty.all(Colors.lightBlueAccent),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  elevation: WidgetStateProperty.all(10),
                  shadowColor: WidgetStateProperty.all(Colors.blueAccent),
                ),
                onPressed: () {
                  fetchPrediction();
                  getFlightDetails();
                },
                child: const Text(
                  'Predict Arrival Delay',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (predictedDelay != null)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blueAccent, Colors.lightBlueAccent],
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
                  child: Text(
                    predictedDelay != 0.00
                        ? 'Predicted Arrival Delay for flight ${_flightNumberController.text}: ${predictedDelay!.toStringAsFixed(2)} minutes'
                        : 'Invalid flight number',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (flightInfo != null)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blueAccent, Colors.lightBlueAccent],
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
                  child: Text(
                    flightInfo != null
                        ? flightInfo!
                        : 'Could not fetch flight number',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCustomCard({
    required IconData icon,
    required String title,
    required List<Color> gradientColors,
    required VoidCallback onTap, // Callback for click action
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent, // Ensures ripple effect matches the gradient
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap, // Function when the card is tapped
          child: ListTile(
            leading: Icon(
              icon,
              size: 35,
              color: Colors.white,
            ),
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
