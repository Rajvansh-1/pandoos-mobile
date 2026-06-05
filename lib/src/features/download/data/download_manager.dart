import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/audio/stream_resolver.dart';
import '../../../core/models/track.dart';
import 'download_repository.dart';

final downloadManagerProvider = Provider<DownloadManager>((ref) {
  return DownloadManager(
    ref.read(dioProvider),
    ref.read(downloadRepositoryProvider),
    ref.read(streamResolverProvider),
  );
});

class DownloadManager {
  final Dio _dio;
  final DownloadRepository _repository;
  final StreamResolver _streamResolver;

  DownloadManager(this._dio, this._repository, this._streamResolver);

  Future<void> downloadTrack(Track track, {Function(double)? onProgress}) async {
    try {
      // 1. Get stream URL
      final streamUrl = await _streamResolver.resolveStreamUrl(track);
      if (streamUrl == null) throw Exception("Could not resolve stream URL");

      // 2. Get local path
      final dir = await getApplicationDocumentsDirectory();
      final downloadsDir = Directory('${dir.path}/downloads');
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }
      final filePath = '${downloadsDir.path}/${track.videoId}.m4a';

      // 3. Download file
      await _dio.download(
        streamUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            onProgress(received / total);
          }
        },
      );

      // 4. Save to repository
      final downloadTrack = DownloadTrack(
        videoId: track.videoId,
        title: track.title,
        artist: track.artist,
        localFilePath: filePath,
        albumArt: track.albumArt,
      );
      await _repository.saveTrack(downloadTrack);

    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeDownload(String videoId) async {
    final track = _repository.getTrack(videoId);
    if (track != null) {
      final file = File(track.localFilePath);
      if (await file.exists()) {
        await file.delete();
      }
      await _repository.deleteTrack(videoId);
    }
  }
}
