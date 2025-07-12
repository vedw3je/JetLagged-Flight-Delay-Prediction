import 'package:flutter/material.dart';
import 'package:jetlagged/api/flightprice.dart';
import 'package:jetlagged/widgets/flightcard.dart';

class FlightSearchPage extends StatefulWidget {
  @override
  _FlightSearchPageState createState() => _FlightSearchPageState();
}

class _FlightSearchPageState extends State<FlightSearchPage> {
  final List<String> airports = ['DEL', 'BOM', 'COK', 'BLR', 'HYD', 'CCU'];

  String? fromAirport;
  String? toAirport;
  DateTime? selectedDate;

  bool isLoading = false;
  List<Map<String, dynamic>> flights = [];

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _searchFlights() async {
    if (fromAirport == null || toAirport == null || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select all fields')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await fetchFlightprice(
        from: fromAirport!,
        to: toAirport!,
        date:
            "${selectedDate!.day.toString().padLeft(2, '0')}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.year}",
      );
      print(selectedDate);

      setState(() {
        flights = result;
        print(flights);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 217, 241, 255),
      appBar: AppBar(
        title: const Text(
          'Flight Search',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              style: const TextStyle(color: Colors.blue),
              dropdownColor: Color.fromARGB(255, 217, 241, 255),
              value: fromAirport,
              decoration: InputDecoration(
                labelText: 'From',
                filled: true,
                fillColor:
                    Color.fromARGB(255, 217, 241, 255), // Light blue theme
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded border
                  borderSide: BorderSide(
                    color: Colors.blue, // Blue border
                    width: 1.5, // Border width
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.blueAccent, // Change focus border color
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.blue
                        .withOpacity(0.7), // Light blue color for border
                    width: 1.5,
                  ),
                ),
              ),
              items: airports.map((airport) {
                return DropdownMenuItem(
                  value: airport,
                  child: Text(airport),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  fromAirport = value;
                });
              },
            ),
            const SizedBox(height: 4),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 217, 241, 255), // Light blue color
                foregroundColor: Colors.blue, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4, // Optional: adds a subtle shadow
              ),
              onPressed: () {
                setState(() {
                  final temp = fromAirport;
                  fromAirport = toAirport;
                  toAirport = temp;
                });
              },
              child: const Icon(
                Icons.swap_vert,
                size: 30,
              ),
            ),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              style: const TextStyle(color: Colors.blue),
              value: toAirport,
              dropdownColor: Color.fromARGB(255, 217, 241, 255),
              decoration: InputDecoration(
                labelText: 'To',

                filled: true,
                fillColor:
                    Color.fromARGB(255, 217, 241, 255), // Light blue theme
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded border
                  borderSide: BorderSide(
                    color: Colors.blue, // Blue border
                    width: 1.5, // Border width
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.blueAccent, // Focused border color
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.blue
                        .withOpacity(0.7), // Light blue color for border
                    width: 1.5,
                  ),
                ),
              ),
              items: airports.map((airport) {
                return DropdownMenuItem(
                  value: airport,
                  child: Text(airport),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  toAirport = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              style: const TextStyle(color: Colors.blue),
              readOnly: true,
              onTap: _pickDate,
              decoration: InputDecoration(
                labelText: 'Date',
                hintText: selectedDate == null
                    ? 'dd-mm-yyyy'
                    : "${selectedDate!.day.toString().padLeft(2, '0')}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.year}",
                hintStyle: TextStyle(
                  color: Colors.lightBlue[300],
                  fontSize: 16,
                ),
                filled: true,
                fillColor: Color.fromARGB(255, 217, 241, 255),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: Colors.lightBlue.shade100, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Colors.lightBlue, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                ),
                backgroundColor:
                    MaterialStateProperty.all(Colors.lightBlue[400]),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30.0), // Rounded corners
                  ),
                ),
                elevation: MaterialStateProperty.all(10), // Shadow elevation
                shadowColor: MaterialStateProperty.all(
                    Colors.blueAccent), // Shadow color
              ),
              onPressed:
                  isLoading ? null : _searchFlights, // Disabled when loading
              child: Text(
                isLoading ? 'Searching...' : 'Search Flights',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: flights == []
                  ? const Center(child: Text('No flights found'))
                  : ListView.builder(
                      itemCount: flights.length,
                      itemBuilder: (context, index) {
                        final flight = flights[index];
                        // return Card(
                        //   color: const Color.fromARGB(255, 0, 59, 81),
                        //   child: ListTile(
                        //     title: Text(flight['airline']),
                        //     subtitle: Text(
                        //         'From: ${flight['from']} To: ${flight['to']}\nPrice: ₹${flight['price']}\nDelay: ${flight['Total Delay']} min'),
                        //   ),
                        // );
                        return FlightCard(flight: flight);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
