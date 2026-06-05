import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/now_playing_state.dart';
import '../data/sync_repository.dart';

final continueListeningProvider = StreamProvider<NowPlayingState?>((ref) {
  final repo = ref.watch(syncRepositoryProvider);
  return repo.subscribeToNowPlaying();
});
