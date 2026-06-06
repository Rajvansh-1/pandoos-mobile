import 'package:flutter_riverpod/flutter_riverpod.dart';

final addToPlaylistUseCaseProvider = Provider<AddToPlaylistUseCase>((ref) {
  return AddToPlaylistUseCase();
});

class AddToPlaylistUseCase {
  Future<void> call(String playlistId, String trackId) async {
    // Stub
  }
}
