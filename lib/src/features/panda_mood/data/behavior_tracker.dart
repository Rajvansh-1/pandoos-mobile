import 'package:flutter_riverpod/flutter_riverpod.dart';

final behaviorTrackerProvider = Provider<BehaviorTracker>((ref) {
  return BehaviorTracker();
});

class BehaviorTracker {
  int _skipCount = 0;
  int _repeatCount = 0;
  DateTime? _sessionStartTime;

  BehaviorTracker() {
    _sessionStartTime = DateTime.now();
  }

  void recordSkip() {
    _skipCount++;
  }

  void recordRepeat() {
    _repeatCount++;
  }

  void resetSession() {
    _skipCount = 0;
    _repeatCount = 0;
    _sessionStartTime = DateTime.now();
  }

  int get skipCount => _skipCount;
  int get repeatCount => _repeatCount;
  Duration get sessionDuration => DateTime.now().difference(_sessionStartTime!);
}
