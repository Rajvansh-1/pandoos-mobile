import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/track.dart';
import '../domain/get_home_feed_usecase.dart';

final homeNotifierProvider = StateNotifierProvider<HomeNotifier, AsyncValue<List<Track>>>((ref) {
  return HomeNotifier(ref.watch(getHomeFeedUseCaseProvider));
});

class HomeNotifier extends StateNotifier<AsyncValue<List<Track>>> {
  final GetHomeFeedUseCase _getHomeFeedUseCase;

  HomeNotifier(this._getHomeFeedUseCase) : super(const AsyncValue.loading()) {
    loadFeed();
  }

  Future<void> loadFeed() async {
    state = const AsyncValue.loading();
    try {
      final tracks = await _getHomeFeedUseCase.execute();
      state = AsyncValue.data(tracks);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
