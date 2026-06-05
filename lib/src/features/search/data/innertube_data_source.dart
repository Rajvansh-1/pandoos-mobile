import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/models/track.dart';

final innertubeDataSourceProvider = Provider<InnertubeDataSource>((ref) {
  return InnertubeDataSource(ref.watch(dioProvider));
});

class InnertubeDataSource {
  final Dio _dio;

  InnertubeDataSource(this._dio);

  Future<List<Track>> searchTracks(String query) async {
    try {
      final response = await _dio.get(ApiEndpoints.search(query, 'song'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final List<dynamic> items = data['items'] ?? [];
        
        return items.map((item) {
          final id = item['id'];
          final snippet = item['snippet'];
          
          String videoId = id is Map ? id['videoId'] : id;
          
          // Try to get best thumbnail
          String thumbnail = '';
          if (snippet['thumbnails'] != null && snippet['thumbnails'] is List && snippet['thumbnails'].isNotEmpty) {
            thumbnail = snippet['thumbnails'].last['url'] ?? '';
          } else if (snippet['thumbnails'] != null && snippet['thumbnails'] is Map) {
             // Fallback if thumbnails is a map (like YouTube Data API)
             final thumbs = snippet['thumbnails'];
             thumbnail = thumbs['high']?['url'] ?? thumbs['medium']?['url'] ?? thumbs['default']?['url'] ?? '';
          }

          return Track(
            id: videoId,
            videoId: videoId,
            title: snippet['title'] ?? 'Unknown Title',
            artist: snippet['channelTitle'] ?? 'Unknown Artist',
            albumArt: thumbnail,
            duration: snippet['duration'] != null ? _parseDuration(snippet['duration']) : 0,
            channelTitle: snippet['channelTitle'],
            artistId: snippet['artistId'],
            albumId: snippet['albumId'],
          );
        }).toList();
      }
      throw Exception('Failed to search tracks');
    } catch (e) {
      throw Exception('Error searching tracks: $e');
    }
  }

  int _parseDuration(String durationText) {
    // "3:45" or "1:02:30"
    final parts = durationText.split(':');
    if (parts.length == 2) {
      return int.parse(parts[0]) * 60 + int.parse(parts[1]);
    } else if (parts.length == 3) {
      return int.parse(parts[0]) * 3600 + int.parse(parts[1]) * 60 + int.parse(parts[2]);
    }
    return 0;
  }
}
