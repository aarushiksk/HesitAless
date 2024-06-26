import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_generative_ai/google_generative_ai.dart';

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
      home: Speech2Screen(),
    );
  }
}

class Speech2Screen extends StatefulWidget {
  @override
  _Speech2ScreenState createState() => _Speech2ScreenState();
}

class _Speech2ScreenState extends State<Speech2Screen> {
  final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'voice': HighlightedWord(
      onTap: () => print('voice'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'subscribe': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'comment': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  late stt.SpeechToText _speech;
  bool _isListening = false;
  int _breakCount = 0;
  DateTime? _lastRecognitionTime;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        duration: const Duration(milliseconds: 2000),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: TextHighlight(
            text: _text,
            words: _highlights,
            textStyle: const TextStyle(
              fontSize: 32.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _lastRecognitionTime = DateTime.now();
        _speech.listen(
          onResult: (val) => setState(() {
            DateTime currentTime = DateTime.now();
            Duration breakDuration =
                currentTime.difference(_lastRecognitionTime!);
            // If break duration is greater than a certain threshold (e.g., 1 second), consider it a break
            if (breakDuration.inSeconds > 1) {
              _breakCount++;
            }
            print('Break count: $_breakCount');
            _lastRecognitionTime = currentTime;
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      DateTime endTime = DateTime.now();
      // Calculate break count
      if (_lastRecognitionTime != null) {
        Duration breakDuration = endTime.difference(_lastRecognitionTime!);
        // If break duration is greater than a certain threshold (e.g., 1 second), consider it a break
        if (breakDuration.inSeconds > 1) {
          _breakCount++;
        }
      }
      // Call Gemini content generation after speech session ends
      _generateGeminiContent(_text);
    }
  }

  void _generateGeminiContent(String text) async {
    const apiKey = 'your_api_key_here';
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    final prompt = text;
    final content = [Content.text(prompt)];
    try {
      final response = await model.generateContent(content);
      print(response.text);
      // Do whatever you want with the generated content
    } catch (e) {
      print('Failed to generate content: $e');
    }
  }
}
