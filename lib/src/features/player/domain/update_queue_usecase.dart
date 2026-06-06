import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/audio/audio_service_provider.dart';
import '../../../core/models/track.dart';

final updateQueueUseCaseProvider = Provider<UpdateQueueUseCase>((ref) {
  return UpdateQueueUseCase(ref);
});

class UpdateQueueUseCase {
  final Ref _ref;
  UpdateQueueUseCase(this._ref);

  Future<void> call(List<Track> queue) async {
    // Stub
  }
}
