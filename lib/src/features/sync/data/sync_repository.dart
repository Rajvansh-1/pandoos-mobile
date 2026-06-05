import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/supabase/supabase_client.dart';
import '../domain/now_playing_state.dart';

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  return SyncRepository(SupabaseClientService());
});

class SyncRepository {
  final SupabaseClientService _supabaseService;

  SyncRepository(this._supabaseService);

  Stream<NowPlayingState?> subscribeToNowPlaying() {
    final client = _supabaseService.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) return Stream.value(null);

    return client
        .from('now_playing')
        .stream(primaryKey: ['user_id'])
        .eq('user_id', userId)
        .map((events) {
          if (events.isEmpty) return null;
          
          final data = events.first;
          return NowPlayingState(
            userId: data['user_id'],
            videoId: data['video_id'],
            title: data['title'],
            artist: data['artist'],
            albumArt: data['album_art'],
            isPlaying: data['is_playing'],
            progress: (data['progress'] as num).toDouble(),
            deviceName: data['device_name'],
            updatedAt: data['updated_at'],
          );
        });
  }
}
