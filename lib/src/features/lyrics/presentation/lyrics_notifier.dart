import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/lyrics_line.dart';
import '../domain/get_lyrics_usecase.dart';
import '../../../core/models/track.dart';

final lyricsNotifierProvider = StateNotifierProvider<LyricsNotifier, AsyncValue<List<LyricsLine>>>((ref) {
  return LyricsNotifier(ref.watch(getLyricsUseCaseProvider));
});

class LyricsNotifier extends StateNotifier<AsyncValue<List<LyricsLine>>> {
  final GetLyricsUseCase _getLyricsUseCase;

  LyricsNotifier(this._getLyricsUseCase) : super(const AsyncData([]));

  Future<void> fetchLyrics(Track track) async {
    state = const AsyncLoading();
    try {
      final lines = await _getLyricsUseCase(track);
      state = AsyncData(lines);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void clear() {
    state = const AsyncData([]);
  }
}
