import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;

class Chatbotpg extends StatefulWidget {
  const Chatbotpg({super.key});

  @override
  State<Chatbotpg> createState() => _ChatbotpgState();
}

class _ChatbotpgState extends State<Chatbotpg> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  Future<void> _sendMessage(String message) async {
    setState(() {
      _messages.add({"sender": "User", "text": message});
    });
    final response = await http.post(
      Uri.parse('http://192.168.1.100:5000/chatbot'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"message": message}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _messages.add({"sender": "Chat Bot", "text": data["response"]});
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.deepPurpleAccent,
                  Colors.pinkAccent,
                ],
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
          ),
          title: Text(
            'AI Chatbot',
          ),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message["text"]!),
                  subtitle: Text(message["sender"]!),
                  tileColor: message["sender"] == "User"
                      ? Colors.blue[50]
                      : Colors.green[50],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Enter your message',
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Iconsax.arrow_right_3),
                    onPressed: () {
                      final message = _controller.text;
                      _controller.clear();
                      _sendMessage(message);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
