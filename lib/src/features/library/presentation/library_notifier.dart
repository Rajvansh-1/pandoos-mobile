import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/track.dart';
import '../domain/get_liked_songs_usecase.dart';
import '../domain/like_track_usecase.dart';
import '../domain/unlike_track_usecase.dart';

final libraryNotifierProvider = StateNotifierProvider<LibraryNotifier, AsyncValue<List<Track>>>((ref) {
  return LibraryNotifier(
    ref.watch(getLikedSongsUseCaseProvider),
    ref.watch(likeTrackUseCaseProvider),
    ref.watch(unlikeTrackUseCaseProvider),
  );
});

class LibraryNotifier extends StateNotifier<AsyncValue<List<Track>>> {
  final GetLikedSongsUseCase _getLikedSongsUseCase;
  final LikeTrackUseCase _likeTrackUseCase;
  final UnlikeTrackUseCase _unlikeTrackUseCase;

  LibraryNotifier(
    this._getLikedSongsUseCase,
    this._likeTrackUseCase,
    this._unlikeTrackUseCase,
  ) : super(const AsyncValue.loading()) {
    loadLikedSongs();
  }

  Future<void> loadLikedSongs() async {
    state = const AsyncValue.loading();
    try {
      final tracks = await _getLikedSongsUseCase.execute();
      state = AsyncValue.data(tracks);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> likeTrack(Track track) async {
    try {
      await _likeTrackUseCase.execute(track);
      await loadLikedSongs();
    } catch (e) {
      // Handle error gracefully
    }
  }

  Future<void> unlikeTrack(String videoId) async {
    try {
      await _unlikeTrackUseCase.execute(videoId);
      await loadLikedSongs();
    } catch (e) {
      // Handle error gracefully
    }
  }

  bool isLiked(String videoId) {
    if (state is AsyncData) {
      return state.value!.any((track) => track.videoId == videoId);
    }
    return false;
  }
}
