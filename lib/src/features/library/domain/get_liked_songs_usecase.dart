import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/track.dart';
import '../data/library_repository.dart';

final getLikedSongsUseCaseProvider = Provider<GetLikedSongsUseCase>((ref) {
  return GetLikedSongsUseCase(ref.watch(libraryRepositoryProvider));
});

class GetLikedSongsUseCase {
  final LibraryRepository _repository;

  GetLikedSongsUseCase(this._repository);

  Future<List<Track>> execute() async {
    return await _repository.getLikedSongs();
  }
}
