import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/track.dart';

final libraryDataSourceProvider = Provider<LibraryDataSource>((ref) {
  return LibraryDataSource();
});

class LibraryDataSource {
  // In production, this binds directly to Isar instances for offline persistence
  // and Supabase for cloud sync.
  
  final List<Track> _likedSongs = [];
  final Map<String, List<Track>> _playlists = {};

  Future<void> likeSong(Track track) async {
    if (!_likedSongs.any((t) => t.id == track.id)) {
      _likedSongs.add(track);
      // await Isar.put(track)
      // await Supabase.from('liked_songs').insert(...)
    }
  }

  Future<void> unlikeSong(String trackId) async {
    _likedSongs.removeWhere((t) => t.id == trackId);
  }

  Future<List<Track>> getLikedSongs() async {
    return _likedSongs;
  }

  Future<void> createPlaylist(String name) async {
    if (!_playlists.containsKey(name)) {
      _playlists[name] = [];
    }
  }

  Future<void> addToPlaylist(String playlistName, Track track) async {
    _playlists[playlistName]?.add(track);
  }

  Future<List<Track>> getPlaylistTracks(String playlistName) async {
    return _playlists[playlistName] ?? [];
  }
}
