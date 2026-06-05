import 'package:freezed_annotation/freezed_annotation.dart';

part 'panda_state.freezed.dart';

enum PandaMood {
  happy,
  melancholy,
  hype,
  focused,
  sleepy,
  heartbreak,
  curious,
  neutral,
}

enum PlaybackMood {
  playing,
  paused,
  buffering,
  error,
  idle,
}

@freezed
class PandaState with _$PandaState {
  const factory PandaState({
    required PandaMood mood,
    required PlaybackMood playback,
    required double energyLevel,
    required double bpm,
    required double amplitude,
  }) = _PandaState;
}
