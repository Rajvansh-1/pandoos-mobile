import 'package:flutter_riverpod/flutter_riverpod.dart';

final downloadTrackUseCaseProvider = Provider<DownloadTrackUseCase>((ref) {
  return DownloadTrackUseCase();
});

class DownloadTrackUseCase {
  Future<void> call(String trackId) async {
    // Stub
  }
}
