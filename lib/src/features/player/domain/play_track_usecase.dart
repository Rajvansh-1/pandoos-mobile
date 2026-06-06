import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/audio/audio_service_provider.dart';
import '../../../core/models/track.dart';

final playTrackUseCaseProvider = Provider<PlayTrackUseCase>((ref) {
  return PlayTrackUseCase(ref);
});

class PlayTrackUseCase {
  final Ref _ref;
  PlayTrackUseCase(this._ref);

  Future<void> call(Track track) async {
    await _ref.read(audioHandlerProvider).playTrack(track);
  }
}
