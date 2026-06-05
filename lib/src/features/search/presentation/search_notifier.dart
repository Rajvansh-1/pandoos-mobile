import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/track.dart';
import '../data/search_repository.dart';

final searchNotifierProvider = StateNotifierProvider<SearchNotifier, AsyncValue<List<Track>>>((ref) {
  return SearchNotifier(ref.watch(searchRepositoryProvider));
});

class SearchNotifier extends StateNotifier<AsyncValue<List<Track>>> {
  final SearchRepository _repository;

  SearchNotifier(this._repository) : super(const AsyncData([]));

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncData([]);
      return;
    }

    state = const AsyncLoading();
    try {
      final tracks = await _repository.searchTracks(query);
      state = AsyncData(tracks);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void clear() {
    state = const AsyncData([]);
  }
}
