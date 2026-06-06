import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/models/track.dart';
import '../domain/album.dart';

final albumRepositoryProvider = Provider<AlbumRepository>((ref) {
  return AlbumRepository(Dio());
});

class AlbumRepository {
  final Dio _dio;
  AlbumRepository(this._dio);

  Future<(Album, List<Track>)> getAlbumPage(String browseId) async {
    final response = await _dio.get(ApiEndpoints.album(browseId));
    final data = response.data as Map<String, dynamic>;
    
    final album = Album(
      id: browseId,
      title: data['title'] as String? ?? 'Unknown Album',
    );
    
    final songs = data['songs'] as List<dynamic>? ?? [];
    final tracks = songs.map((s) => Track(
      id: s['videoId'] as String,
      videoId: s['videoId'] as String,
      title: s['title'] as String? ?? '',
      artist: s['artist'] as String? ?? '',
      albumArt: data['thumbnail'] as String? ?? '',
      duration: s['duration'] as int? ?? 0,
    )).toList();

    return (album, tracks);
  }
}
