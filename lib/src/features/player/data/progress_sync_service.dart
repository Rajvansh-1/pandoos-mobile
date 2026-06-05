import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import '../../../core/supabase/supabase_client.dart';
import '../../../core/audio/audio_service_provider.dart';

final progressSyncServiceProvider = Provider<ProgressSyncService>((ref) {
  final service = ProgressSyncService(
    ref.watch(audioHandlerProvider),
    SupabaseClientService(),
  );
  ref.onDispose(() => service.dispose());
  return service;
});

class ProgressSyncService {
  final AudioHandler _audioHandler;
  final SupabaseClientService _supabaseService;
  Timer? _syncTimer;
  bool _isDisposed = false;

  ProgressSyncService(this._audioHandler, this._supabaseService) {
    _init();
  }

  void _init() {
    _syncTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (_isDisposed) return;
      _syncProgress();
    });
  }

  Future<void> _syncProgress() async {
    final client = _supabaseService.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    final mediaItem = _audioHandler.mediaItem.value;
    if (mediaItem == null) return;

    final playbackState = _audioHandler.playbackState.value;
    final isPlaying = playbackState.playing;
    final position = playbackState.position;
    final duration = mediaItem.duration ?? const Duration(minutes: 3);

    double progress = 0.0;
    if (duration.inMilliseconds > 0) {
      progress = position.inMilliseconds / duration.inMilliseconds;
    }

    try {
      await client.from('now_playing').upsert({
        'user_id': userId,
        'video_id': mediaItem.id,
        'title': mediaItem.title,
        'artist': mediaItem.artist ?? 'Unknown Artist',
        'album_art': mediaItem.artUri?.toString() ?? '',
        'is_playing': isPlaying,
        'progress': progress,
        'device_name': 'Mobile',
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Ignore sync errors silently
    }
  }

  void dispose() {
    _isDisposed = true;
    _syncTimer?.cancel();
  }
}
