import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:my_speech_app/controller/speech_controller.dart';

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
