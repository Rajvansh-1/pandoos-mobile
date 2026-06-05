import 'package:freezed_annotation/freezed_annotation.dart';

part 'now_playing_state.freezed.dart';
part 'now_playing_state.g.dart';

@freezed
class NowPlayingState with _$NowPlayingState {
  const factory NowPlayingState({
    required String userId,
    required String videoId,
    required String title,
    required String artist,
    required String albumArt,
    required bool isPlaying,
    required double progress,
    required String deviceName,
    required String updatedAt,
  }) = _NowPlayingState;

  factory NowPlayingState.fromJson(Map<String, dynamic> json) =>
      _$NowPlayingStateFromJson(json);
}
