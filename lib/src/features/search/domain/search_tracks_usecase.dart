import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/search_repository.dart';
import '../../../core/models/track.dart';

final searchTracksUseCaseProvider = Provider<SearchTracksUseCase>((ref) {
  return SearchTracksUseCase(ref.watch(searchRepositoryProvider));
});

class SearchTracksUseCase {
  final SearchRepository _repository;
  
  SearchTracksUseCase(this._repository);

  Future<List<Track>> call(String query) async {
    return _repository.searchTracks(query);
  }
}
