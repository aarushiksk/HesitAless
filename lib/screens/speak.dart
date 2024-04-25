import 'package:flutter/material.dart';
import 'dart:async';

import 'timer_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  String _topic = ''; // Variable to hold the entered topic
  bool _showTopic = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Enter Idea:', style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _topic =
                        value; // Update the topic variable with entered text
                  });
                },
                onSubmitted: (value) {
                  setState(() {
                    _showTopic = true; // Show the entered topic
                  });
                  // Redirect to the timer screen after 3 seconds
                  Timer(Duration(seconds: 3), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => TimerScreen()),
                    );
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter your idea here',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Visibility(
                visible: _showTopic && _topic.isNotEmpty,
                child: Text(
                  'Idea: $_topic',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
