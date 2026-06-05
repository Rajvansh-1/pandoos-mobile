// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'now_playing_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NowPlayingStateImpl _$$NowPlayingStateImplFromJson(
        Map<String, dynamic> json) =>
    _$NowPlayingStateImpl(
      userId: json['userId'] as String,
      videoId: json['videoId'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      albumArt: json['albumArt'] as String,
      isPlaying: json['isPlaying'] as bool,
      progress: (json['progress'] as num).toDouble(),
      deviceName: json['deviceName'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$$NowPlayingStateImplToJson(
        _$NowPlayingStateImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'videoId': instance.videoId,
      'title': instance.title,
      'artist': instance.artist,
      'albumArt': instance.albumArt,
      'isPlaying': instance.isPlaying,
      'progress': instance.progress,
      'deviceName': instance.deviceName,
      'updatedAt': instance.updatedAt,
    };
