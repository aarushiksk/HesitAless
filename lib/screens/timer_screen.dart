import 'package:flutter/material.dart';
import 'dart:async';
import 'speak2.dart'; // Import the Speak2Screen

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _redirectTimer;

  @override
  void initState() {
    super.initState();
    // Start the timer when the screen initializes
    _startTimer();
  }

  // Method to start the timer
  void _startTimer() {
    // Redirect user to Speak2Screen after 3 seconds
    _redirectTimer = Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    });
  }

  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks when the screen is disposed
    _redirectTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Timer Page',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(), // Placeholder for timer
          ],
        ),
      ),
    );
  }
}
