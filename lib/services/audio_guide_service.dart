import 'dart:async';
import 'package:flutter/foundation.dart';

class AudioGuideService {
  AudioGuideService._();

  static final AudioGuideService instance = AudioGuideService._();

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  String _currentSpeakingText = '';
  String get currentSpeakingText => _currentSpeakingText;

  final _statusController = StreamController<bool>.broadcast();
  Stream<bool> get statusStream => _statusController.stream;

  Future<void> speak(String text, String langCode) async {
    _isPlaying = true;
    _currentSpeakingText = text;
    _statusController.add(true);

    if (kDebugMode) {
      print('[Voice Assistant - $langCode]: "$text"');
    }

    // Simulate duration of speech based on text length
    final durationSecs = (text.length / 15).clamp(2, 6).toInt();
    await Future.delayed(Duration(seconds: durationSecs));

    _isPlaying = false;
    _currentSpeakingText = '';
    _statusController.add(false);
  }

  void stop() {
    _isPlaying = false;
    _currentSpeakingText = '';
    _statusController.add(false);
  }
}
