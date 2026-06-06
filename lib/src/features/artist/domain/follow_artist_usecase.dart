import 'package:flutter_riverpod/flutter_riverpod.dart';

final followArtistUseCaseProvider = Provider<FollowArtistUseCase>((ref) {
  return FollowArtistUseCase();
});

class FollowArtistUseCase {
  Future<void> call(String artistId) async {
    // Stub
  }
}
