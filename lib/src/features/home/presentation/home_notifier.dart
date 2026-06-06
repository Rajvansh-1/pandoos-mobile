import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/track.dart';
import '../../../core/panda/panda_state.dart';
import '../domain/get_home_feed_usecase.dart';
import '../../panda_mood/presentation/mood_notifier.dart';
import '../../panda_mood/domain/mood_playlist_usecase.dart';

final homeNotifierProvider = StateNotifierProvider<HomeNotifier, AsyncValue<List<Track>>>((ref) {
  final moodState = ref.watch(moodNotifierProvider);
  return HomeNotifier(
    ref.watch(getHomeFeedUseCaseProvider),
    ref.watch(moodPlaylistUseCaseProvider),
    moodState.currentMood,
  );
});

class HomeNotifier extends StateNotifier<AsyncValue<List<Track>>> {
  final GetHomeFeedUseCase _getHomeFeedUseCase;
  final MoodPlaylistUseCase _moodPlaylistUseCase;
  final PandaMood _currentMood;

  HomeNotifier(this._getHomeFeedUseCase, this._moodPlaylistUseCase, this._currentMood) 
      : super(const AsyncValue.loading()) {
    loadFeed();
  }

  Future<void> loadFeed() async {
    state = const AsyncValue.loading();
    try {
      List<Track> tracks;
      if (_currentMood == PandaMood.neutral) {
        tracks = await _getHomeFeedUseCase.execute();
      } else {
        tracks = await _moodPlaylistUseCase.execute(_currentMood);
      }
      state = AsyncValue.data(tracks);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
