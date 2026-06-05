import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/library_repository.dart';

final unlikeTrackUseCaseProvider = Provider<UnlikeTrackUseCase>((ref) {
  return UnlikeTrackUseCase(ref.watch(libraryRepositoryProvider));
});

class UnlikeTrackUseCase {
  final LibraryRepository _repository;

  UnlikeTrackUseCase(this._repository);

  Future<void> execute(String videoId) async {
    await _repository.unlikeTrack(videoId);
  }
}
