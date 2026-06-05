import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'download_repository.g.dart';

@HiveType(typeId: 1)
class DownloadTrack extends HiveObject {
  @HiveField(0)
  final String videoId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String artist;

  @HiveField(3)
  final String localFilePath;

  @HiveField(4)
  final String albumArt;

  DownloadTrack({
    required this.videoId,
    required this.title,
    required this.artist,
    required this.localFilePath,
    required this.albumArt,
  });
}

final downloadRepositoryProvider = Provider<DownloadRepository>((ref) {
  return DownloadRepository();
});

class DownloadRepository {
  static const String boxName = 'offline_tracks';

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(DownloadTrackAdapter());
    }
    await Hive.openBox<DownloadTrack>(boxName);
  }

  Box<DownloadTrack> get _box => Hive.box<DownloadTrack>(boxName);

  Future<void> saveTrack(DownloadTrack track) async {
    await _box.put(track.videoId, track);
  }

  Future<void> deleteTrack(String videoId) async {
    await _box.delete(videoId);
  }

  DownloadTrack? getTrack(String videoId) {
    return _box.get(videoId);
  }

  List<DownloadTrack> getAllTracks() {
    return _box.values.toList();
  }

  bool isDownloaded(String videoId) {
    return _box.containsKey(videoId);
  }
}
