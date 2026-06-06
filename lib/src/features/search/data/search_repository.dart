import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../domain/search_result.dart';
import '../../../core/models/track.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(Dio());
});

class SearchRepository {
  final Dio _dio;
  
  SearchRepository(this._dio);

  Future<List<Track>> searchTracks(String query) async {
    try {
      final response = await _dio.get('https://pandoos.vercel.app/api/search', queryParameters: {
        'q': query,
        'type': 'song',
      });

      List<dynamic> items = [];
      final raw = response.data;
      
      if (raw is Map && raw['items'] is List) {
        items = raw['items'];
      } else if (raw is List) {
        items = raw;
      }

      return items.map((json) {
        if (json is! Map) return null;
        
        final snippet = json['snippet'] ?? {};
        final idMap = json['id'] ?? {};
        
        // Handle nested artist name formats
        String artist = 'Unknown Artist';
        if (snippet['channelTitle'] is String) {
          artist = snippet['channelTitle'];
        } else if (json['artists'] is List && (json['artists'] as List).isNotEmpty) {
          artist = (json['artists'] as List).map((a) => a is Map ? a['name'] ?? '' : a.toString()).join(', ');
        } else if (json['artist'] is String) {
          artist = json['artist'];
        }

        // Handle nested thumbnail formats
        String albumArt = '';
        if (snippet['thumbnails'] is Map && snippet['thumbnails']['high'] is Map) {
          albumArt = snippet['thumbnails']['high']['url'] ?? '';
        } else if (json['thumbnails'] is List && (json['thumbnails'] as List).isNotEmpty) {
          albumArt = ((json['thumbnails'] as List).last)['url'] ?? '';
        } else if (json['thumbnail'] is String) {
          albumArt = json['thumbnail'];
        }

        final videoId = idMap['videoId'] ?? json['videoId'] ?? '';
        if (videoId.isEmpty) return null;

        return Track(
          id: videoId,
          videoId: videoId,
          title: snippet['title'] ?? json['title'] ?? 'Unknown',
          artist: artist,
          albumArt: albumArt,
          duration: 0, // YouTube search API format often omits duration, fallback to 0
        );
      }).whereType<Track>().toList();
    } catch (e) {
      throw Exception('Failed to search tracks: $e');
    }
  }
}
