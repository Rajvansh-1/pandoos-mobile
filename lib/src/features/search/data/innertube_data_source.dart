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
        final List<dynamic> data = response.data;
        return data.map((json) {
          return Track(
            id: json['videoId'] as String,
            videoId: json['videoId'] as String,
            title: json['title'] as String,
            artist: (json['artists'] as List).isNotEmpty ? json['artists'][0]['name'] : 'Unknown Artist',
            albumArt: (json['thumbnails'] as List).last['url'] as String,
            duration: json['duration'] != null ? _parseDuration(json['duration']['text']) : 0,
            channelTitle: (json['artists'] as List).isNotEmpty ? json['artists'][0]['name'] : null,
            artistId: (json['artists'] as List).isNotEmpty ? json['artists'][0]['id'] : null,
            albumId: json['album'] != null ? json['album']['id'] : null,
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
