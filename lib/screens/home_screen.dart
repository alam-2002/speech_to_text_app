import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpeechToText speechToText = SpeechToText();

  bool speechEnabled = false;
  String spokenWords = "";
  double confidenceLevel = 0;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  void startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {
      confidenceLevel = 0;
    });
  }

  void stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) async {
    setState(() {
      spokenWords = result.recognizedWords;
      confidenceLevel = result.confidence;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Text(
          'Speech Demo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
              child: Text(
                speechToText.isListening
                    ? "Listening..."
                    : speechEnabled
                        ? "Tap the microphone to start listening..."
                        : "Speech not available",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  spokenWords,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            if (speechToText.isNotListening && confidenceLevel > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Text(
                  "Confidence: ${(confidenceLevel * 100).toStringAsFixed(1)}%",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: AvatarGlow(
        animate: speechToText.isListening,
        glowColor: Colors.red,
        glowShape: BoxShape.circle, // Use this if you need a glow effect
        duration: const Duration(milliseconds: 1500),
        repeat: true,
        child: FloatingActionButton(
          onPressed: () {
            speechToText.isListening ? stopListening() : startListening();
          },
          tooltip: 'Speak',
          backgroundColor: Colors.red,
          child: Icon(
            speechToText.isNotListening ? Icons.mic_off : Icons.mic,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
