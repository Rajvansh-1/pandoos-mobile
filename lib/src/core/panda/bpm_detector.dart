import 'dart:async';

/// Calculates real-time BPM (Beats Per Minute) from audio amplitudes
class BPMDetector {
  final List<DateTime> _beatTimestamps = [];
  
  /// Call this whenever a sharp spike in amplitude is detected
  void registerBeat() {
    final now = DateTime.now();
    _beatTimestamps.add(now);
    
    // Keep only the last 10 seconds of beats to calculate current rolling BPM
    _beatTimestamps.removeWhere((t) => now.difference(t).inSeconds > 10);
  }

  /// Calculates the rolling BPM based on recent beat timestamps
  double get currentBpm {
    if (_beatTimestamps.length < 2) return 0.0;
    
    final duration = _beatTimestamps.last.difference(_beatTimestamps.first);
    if (duration.inSeconds == 0) return 0.0;
    
    // Extrapolate beats over 1 minute
    final beatsPerSecond = _beatTimestamps.length / duration.inSeconds;
    return beatsPerSecond * 60.0;
  }
}
