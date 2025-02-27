import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:avatar_glow/avatar_glow.dart';

class SpeechController extends GetxController {
  final SpeechToText speechToText = SpeechToText();
  var speechEnabled = false.obs;
  var spokenWords = "".obs;
  var confidenceLevel = 0.0.obs;
  var isListening = false.obs;

  @override
  void onInit() {
    super.onInit();
    initSpeech();
  }

  void initSpeech() async {
    speechEnabled.value = await speechToText.initialize();
  }

  void startListening() async {
    isListening.value = true;
    confidenceLevel.value = 0;

    await speechToText.listen(
      onResult: onSpeechResult,
      pauseFor: const Duration(seconds: 3),
      onSoundLevelChange: (level) {
        Timer(Duration(seconds: 3), () {
          if (level < -1.5) {
            stopListening();
          }
        });
      },
    );
  }

  void stopListening() async {
    isListening.value = false;
    await speechToText.stop();
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    spokenWords.value = result.recognizedWords;
    confidenceLevel.value = result.confidence;
  }
}

class HomeScreenGetx extends StatelessWidget {
  HomeScreenGetx({super.key});

  final SpeechController speechController = Get.put(SpeechController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text(
          'Speech Demo Getx',
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
              padding: const EdgeInsets.all(20),
              child: Obx(
                () => Text(
                  speechController.isListening.value
                      ? "Listening..."
                      : speechController.speechEnabled.value
                          ? "Tap the microphone to start listening..."
                          : "Speech not available",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Obx(
                  () => Text(
                    speechController.spokenWords.value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ),
            Obx(
              () => speechController.confidenceLevel.value > 0 && !speechController.isListening.value
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Text(
                        "Confidence: ${(speechController.confidenceLevel.value * 100).toStringAsFixed(1)}%",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => AvatarGlow(
          animate: speechController.isListening.value,
          glowColor: Colors.blue,
          glowShape: BoxShape.circle, // Use this if you need a glow effect
          duration: const Duration(milliseconds: 1500),
          repeat: true,
          child: FloatingActionButton(
            onPressed: () {
              speechController.isListening.value ? speechController.stopListening() : speechController.startListening();
            },
            tooltip: 'Speak',
            backgroundColor: Colors.blue,
            child: Icon(
              speechController.isListening.value ? Icons.mic : Icons.mic_off,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
