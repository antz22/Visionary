import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTS {
  static void speak(String speechText) {
    final FlutterTts tts = FlutterTts();
    final TextEditingController controller =
        TextEditingController(text: speechText);
    tts.setLanguage('en');
    tts.setSpeechRate(0.4);
    tts.speak(controller.text);
  }
}
