import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/models/track.dart';
import '../domain/artist.dart';

final artistRepositoryProvider = Provider<ArtistRepository>((ref) {
  return ArtistRepository(Dio());
});

class ArtistRepository {
  final Dio _dio;
  ArtistRepository(this._dio);

  Future<Map<String, dynamic>> getArtistPage(String browseId) async {
    final response = await _dio.get(ApiEndpoints.artist(browseId));
    return response.data as Map<String, dynamic>;
  }

  Future<Artist> getArtist(String browseId) async {
    final data = await getArtistPage(browseId);
    return Artist(
      id: browseId,
      name: data['name'] as String? ?? 'Unknown Artist',
    );
  }

  Future<List<Track>> getArtistTopTracks(String browseId) async {
    try {
      final data = await getArtistPage(browseId);
      final songs = data['songs'] as List<dynamic>? ?? [];
      return songs.map((s) => Track(
        id: s['videoId'] as String,
        videoId: s['videoId'] as String,
        title: s['title'] as String? ?? '',
        artist: s['artist'] as String? ?? '',
        albumArt: s['thumbnail'] as String? ?? '',
        duration: s['duration'] as int? ?? 0,
      )).toList();
    } catch (_) {
      return [];
    }
  }
}
