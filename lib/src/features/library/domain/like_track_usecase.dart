import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/track.dart';
import '../data/library_repository.dart';

final likeTrackUseCaseProvider = Provider<LikeTrackUseCase>((ref) {
  return LikeTrackUseCase(ref.watch(libraryRepositoryProvider));
});

class LikeTrackUseCase {
  final LibraryRepository _repository;

  LikeTrackUseCase(this._repository);

  Future<void> execute(Track track) async {
    await _repository.likeTrack(track);
  }
}
