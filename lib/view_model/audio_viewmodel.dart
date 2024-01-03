import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../helper/convert_duration.dart';

class AudioViewModel with ChangeNotifier {
  AudioPlayer _audioPlayer = AudioPlayer();

  double max = 0.0;
  double sliderValue = 0;
  bool isPlaying = false;
  bool isLoading = false;
  bool isError = false;

  bool get canPlay => !isError && !isLoading;

  String get maxDurationInString {
    final duration = Duration(milliseconds: max.toInt());
    return convertDurationToString(duration);
  }

  String get sliderDurationInString {
    final duration = Duration(milliseconds: sliderValue.toInt());
    return convertDurationToString(duration);
  }

  String get durationLeftInString {
    final duration = Duration(milliseconds: (max - sliderValue).toInt());
    return convertDurationToString(duration);
  }

  PlayerState get playerState => _audioPlayer.state;
  void init() {
    isPlaying = false;
    isLoading = false;
    isError = false;
    if (_audioPlayer.state == PlayerState.disposed) {
      _audioPlayer = AudioPlayer();
      _audioPlayer.onPositionChanged.listen((duration) {
        sliderValue = duration.inMilliseconds.toDouble();
        notifyListeners();
      });
      _audioPlayer.onPlayerComplete.listen((_) {
        sliderValue = 0;
        isPlaying = false;
        notifyListeners();
      });
    }
  }

  Future<void> close() async {
    if (_audioPlayer.state != PlayerState.disposed) {
      await _audioPlayer.dispose();
    }
    max = 0.0;
    sliderValue = 0;
    isPlaying = false;
  }

  Future<void> loadAudioPlayer(String url) async {
    try {
      if (url.isEmpty) {
        return;
      }
      await close();
      init();
      await _audioPlayer.setSourceUrl(url);
      final duration = await _audioPlayer.getDuration();
      max = duration?.inMilliseconds.toDouble() ?? 0.0;
      notifyListeners();
    } catch (ex) {
      isError = true;
    }
  }

  Future togglePlay() async {
    if (isPlaying) {
      await _audioPlayer.pause();
      isPlaying = false;
    } else {
      await _audioPlayer.resume();
      isPlaying = true;
    }
    notifyListeners();
  }

  Future<void> seek(double milliseconds) async {
    await _audioPlayer.seek(Duration(milliseconds: milliseconds.round()));
    sliderValue = milliseconds;
    notifyListeners();
  }
}
