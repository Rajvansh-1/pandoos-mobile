import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/artist_repository.dart';
import '../domain/artist.dart';
import '../../../core/models/track.dart';

final getArtistUseCaseProvider = Provider<GetArtistUseCase>((ref) {
  return GetArtistUseCase(ref.watch(artistRepositoryProvider));
});

class GetArtistUseCase {
  final ArtistRepository _repository;
  GetArtistUseCase(this._repository);

  Future<Artist> call(String browseId) => _repository.getArtist(browseId);
  Future<List<Track>> getTopTracks(String browseId) => _repository.getArtistTopTracks(browseId);
}
