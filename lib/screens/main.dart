import 'package:flutter/material.dart';
import 'speak.dart'; // Assuming your SpeechScreen class is in a separate file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Voice',
      home: SpeechScreen(),
    );
  }
}
