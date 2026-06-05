import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'panda_state.dart';

final pandaEmotionEngineProvider = Provider<PandaEmotionEngine>((ref) {
  return PandaEmotionEngine();
});

class PandaEmotionEngine {
  // Session State
  final List<DateTime> _recentSkips = [];
  int _currentSongRepeats = 0;
  final List<double> _recentBpms = [];
  final List<DateTime> _recentLikes = [];
  
  PandaMood _inferFromTime(DateTime now) {
    final hour = now.hour;
    if (hour >= 6 && hour < 9) return PandaMood.focused;    // Morning
    if (hour >= 9 && hour < 17) return PandaMood.focused;   // Daytime
    if (hour >= 17 && hour < 20) return PandaMood.happy;    // Evening
    if (hour >= 20 && hour < 24) return PandaMood.melancholy; // Night
    return PandaMood.sleepy;                                  // Late night
  }

  void recordSkip() {
    final now = DateTime.now();
    _recentSkips.add(now);
    _recentSkips.removeWhere((t) => now.difference(t).inSeconds > 10);
  }

  void recordRepeat() {
    _currentSongRepeats++;
  }

  void resetRepeat() {
    _currentSongRepeats = 0;
  }

  void recordBpm(double bpm) {
    _recentBpms.add(bpm);
    if (_recentBpms.length > 5) {
      _recentBpms.removeAt(0);
    }
  }

  void recordLike() {
    final now = DateTime.now();
    _recentLikes.add(now);
    _recentLikes.removeWhere((t) => now.difference(t).inMinutes > 10);
  }

  PandaMood inferMood() {
    // 1. Skip behavior (>3 skips in 10 seconds -> curious)
    if (_recentSkips.length >= 3) {
      return PandaMood.curious;
    }

    // 2. Repeat behavior (>2x -> melancholy)
    if (_currentSongRepeats >= 2) {
      return PandaMood.melancholy;
    }

    // 3. Like velocity (>5 likes in 10 mins -> happy)
    if (_recentLikes.length >= 5) {
      return PandaMood.happy;
    }

    // 4. Session energy (average BPM of last 5 songs)
    if (_recentBpms.isNotEmpty) {
      final avgBpm = _recentBpms.reduce((a, b) => a + b) / _recentBpms.length;
      if (avgBpm > 110) {
        return PandaMood.hype;
      } else if (avgBpm >= 80 && avgBpm <= 110) {
        // Fallback to time-of-day for neutral/happy/focused
        final timeMood = _inferFromTime(DateTime.now());
        if (timeMood == PandaMood.sleepy || timeMood == PandaMood.melancholy) {
          return PandaMood.happy; // 80-110 is too energetic for sleepy
        }
        return timeMood;
      } else {
        return PandaMood.melancholy; // < 80 BPM
      }
    }

    // 5. Default: Time of day
    return _inferFromTime(DateTime.now());
  }

  PandaState inferCurrentState({
    required PlaybackMood playback,
    required double energyLevel,
    required double bpm,
    required double amplitude,
  }) {
    return PandaState(
      mood: inferMood(),
      playback: playback,
      energyLevel: energyLevel,
      bpm: bpm,
      amplitude: amplitude,
    );
  }
}
