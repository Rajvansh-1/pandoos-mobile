import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/supabase/supabase_client.dart';
import '../../../core/models/track.dart';

final libraryRepositoryProvider = Provider<LibraryRepository>((ref) {
  return LibraryRepository(SupabaseClientService());
});

class LibraryRepository {
  final SupabaseClientService _supabaseService;

  LibraryRepository(this._supabaseService);

  Future<void> likeTrack(Track track) async {
    final client = _supabaseService.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception("User not signed in");

    await client.from('liked_songs').upsert({
      'user_id': userId,
      'video_id': track.videoId,
      'title': track.title,
      'artist': track.artist,
      'album_art': track.albumArt,
      'duration': track.duration,
      'liked_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> unlikeTrack(String videoId) async {
    final client = _supabaseService.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception("User not signed in");

    await client
        .from('liked_songs')
        .delete()
        .match({'user_id': userId, 'video_id': videoId});
  }

  Future<List<Track>> getLikedSongs() async {
    final client = _supabaseService.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await client
        .from('liked_songs')
        .select()
        .eq('user_id', userId)
        .order('liked_at', ascending: false);

    return (response as List<dynamic>).map((json) => Track(
      id: json['video_id'],
      videoId: json['video_id'],
      title: json['title'],
      artist: json['artist'],
      albumArt: json['album_art'],
      duration: json['duration'],
    )).toList();
  }
}
