import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';

class TTSManager {
  FlutterTts flutterTts = FlutterTts();
  bool _isSpeaking = false;
  VoidCallback? _onStart;
  VoidCallback? _onComplete;
  VoidCallback? _onError;

  TTSManager() {
    // Set event handlers
    flutterTts.setStartHandler(() {
      _isSpeaking = true;
      _notifyStateChange();
    });
    flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
      _notifyStateChange();
    });
    flutterTts.setErrorHandler((message) {
      _isSpeaking = false;
      _notifyStateChange();
    });
  }

  // Callback for state change
  void _notifyStateChange() {
    _onStart?.call();
    _onComplete?.call();
    _onError?.call();
  }

  // Set callback for start event
  void setOnStartCallback(VoidCallback onStart) {
    _onStart = onStart;
  }

  // Set callback for completion event
  void setOnCompleteCallback(VoidCallback onComplete) {
    _onComplete = onComplete;
  }

  // Set callback for error event
  void setOnErrorCallback(VoidCallback onError) {
    _onError = onError;
  }

  Future<void> speak(String text) async {
    if (isSpeaking()) {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setVoice({
        "name": "en-US-default",
        "locale": "eng-default",
      });
      await flutterTts.speak(text);
    }
  }

  // Toggle mute function
  void toggleSpeak() {
    _isSpeaking = !_isSpeaking;
    if (!_isSpeaking) {
      flutterTts.stop();
    }
  }

  bool isSpeaking() {
    return _isSpeaking;
  }

  void setIsSpeaking(bool value) {
    _isSpeaking = value;
    if (!_isSpeaking) {
      flutterTts.stop();
    }
  }
}
