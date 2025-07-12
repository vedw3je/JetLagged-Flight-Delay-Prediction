import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class JetPalScreen extends StatefulWidget {
  static Future<void> clearMessagesOnRestart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_messages');
  }

  @override
  _JetPalScreenState createState() => _JetPalScreenState();
}

class _JetPalScreenState extends State<JetPalScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<String> messages = ['', 'Hi I am JetPal, how can I help you today?'];
  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final storedMessages = prefs.getStringList('chat_messages');
    if (storedMessages != null) {
      setState(() {
        messages = storedMessages;
      });
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('chat_messages', messages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'JetPal Assistant',
          style: TextStyle(fontWeight: FontWeight.w900),
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
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Logo and initial prompt
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Image.asset(
                  'assets/jetlaggedlogo.png',
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const Divider(thickness: 1, color: Colors.blueGrey),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: index % 2 == 0
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: index % 2 == 0
                            ? Color.fromARGB(116, 0, 44, 65).withOpacity(0.8)
                            : const Color.fromARGB(110, 33, 149, 243),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        messages[index],
                        style: TextStyle(
                          fontSize: 16,
                          color: index % 2 == 0 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const Divider(thickness: 1, color: Colors.blueGrey),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      autocorrect: true,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(color: Colors.blue[700]),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 174, 229, 255),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide.none, // Removes the underline border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.blue[900], // Input text color
                        fontWeight: FontWeight
                            .w500, // Optional: Add font weight for better contrast
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FloatingActionButton(
                    onPressed: _sendMessage,
                    backgroundColor: Colors.lightBlueAccent,
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      messages.add(message);
      messages.add('.....'); // Placeholder
    });

    _messageController.clear();

    try {
      final uri = Uri.parse('http://192.168.0.117:5002/query');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botResponse = data["answer"] ?? 'No response received';

        setState(() {
          messages[messages.length - 1] = botResponse;
        });
        _saveMessages();
      } else {
        setState(() {
          messages[messages.length - 1] =
              'Error: Server returned status code ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        messages[messages.length - 1] = 'Error: Unable to connect to server.';
      });
      print('Error: $e'); // Log error to debug
    }
  }
}
