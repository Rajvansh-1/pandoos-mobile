import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_client.dart';
import '../network/api_endpoints.dart';
import '../models/track.dart';

final streamResolverProvider = Provider<StreamResolver>((ref) {
  return StreamResolver(ref.watch(dioProvider));
});

class StreamResolver {
  final Dio _dio;
  StreamResolver(this._dio);

  Future<String?> resolveStreamUrl(Track track, {int quality = 128}) async {
    // 1. Check Isar offline DB (placeholder)
    final localUri = await _checkOffline(track.videoId);
    if (localUri != null) return localUri;

    // 2 & 3. Check Vercel Edge Cache & Call /api/stream
    try {
      final response = await _dio.get(
        ApiEndpoints.stream(track.videoId, quality)
      );
      
      if (response.statusCode == 200 && response.data != null) {
        // Assume API returns { "url": "..." }
        return response.data['url'] as String?;
      }
    } catch (e) {
      debugPrint("Error resolving stream URL: $e");
    }

    return null;
  }

  Future<String?> _checkOffline(String videoId) async {
    // TODO: query Isar to find downloaded file URI
    return null;
  }
}
