import 'dart:async';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

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
