import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/panda/panda_state.dart';
import '../../../core/models/track.dart';
import '../../search/data/search_repository.dart';

final moodPlaylistUseCaseProvider = Provider<MoodPlaylistUseCase>((ref) {
  return MoodPlaylistUseCase(ref.watch(searchRepositoryProvider));
});

class MoodPlaylistUseCase {
  final SearchRepository _searchRepository;

  MoodPlaylistUseCase(this._searchRepository);

  Future<List<Track>> execute(PandaMood mood) async {
    String query;
    switch (mood) {
      case PandaMood.happy:
        query = 'happy feel good music';
        break;
      case PandaMood.melancholy:
        query = 'sad melancholy songs';
        break;
      case PandaMood.hype:
        query = 'hype gym workout music';
        break;
      case PandaMood.focused:
        query = 'lofi focus beats';
        break;
      case PandaMood.sleepy:
        query = 'sleep ambient music';
        break;
      case PandaMood.heartbreak:
        query = 'heartbreak sad songs';
        break;
      case PandaMood.curious:
        query = 'indie experimental obscure music';
        break;
      case PandaMood.neutral:
      default:
        query = 'popular trending songs';
        break;
    }

    return _searchRepository.searchTracks(query);
  }
}
