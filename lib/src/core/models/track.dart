import 'package:freezed_annotation/freezed_annotation.dart';

part 'track.freezed.dart';
part 'track.g.dart';

@freezed
class Track with _$Track {
  const factory Track({
    required String id,           // equals videoId for YouTube
    required String title,
    required String artist,
    required String albumArt,     // thumbnail URL
    required int duration,        // seconds
    required String videoId,      // YouTube video ID — universal key
    String? channelTitle,
    String? artistId,             // YTM browseId
    String? albumId,              // YTM browseId
    String? streamUrl,            // resolved at runtime, never stored in DB
  }) = _Track;

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);
}
