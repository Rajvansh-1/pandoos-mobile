import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_client.dart';
import '../network/api_endpoints.dart';
import '../models/track.dart';
import '../../features/download/data/download_repository.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

final streamResolverProvider = Provider<StreamResolver>((ref) {
  return StreamResolver(
    ref.watch(dioProvider),
    ref.watch(downloadRepositoryProvider),
  );
});

class StreamResolver {
  final Dio _dio;
  final DownloadRepository _downloadRepo;
  final YoutubeExplode _yt = YoutubeExplode();
  
  StreamResolver(this._dio, this._downloadRepo);

  Future<String?> resolveStreamUrl(Track track, {int quality = 128}) async {
    // 1. Check Offline DB (Hive)
    final localUri = await _checkOffline(track.videoId);
    if (localUri != null) return localUri;

    // 2. Resolve directly using youtube_explode_dart (bypasses broken Vercel API)
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(track.videoId);
      final streamInfo = manifest.audioOnly.withHighestBitrate();
      return streamInfo.url.toString();
    } catch (e) {
      debugPrint("Error resolving stream URL via YoutubeExplode: $e");
    }
    
    return null;
  }

  Future<String?> _checkOffline(String videoId) async {
    final track = _downloadRepo.getTrack(videoId);
    if (track != null) {
      return track.localFilePath;
    }
    return null;
  }
}
