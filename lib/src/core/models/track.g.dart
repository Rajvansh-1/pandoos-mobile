// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrackImpl _$$TrackImplFromJson(Map<String, dynamic> json) => _$TrackImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      albumArt: json['albumArt'] as String,
      duration: (json['duration'] as num).toInt(),
      videoId: json['videoId'] as String,
      channelTitle: json['channelTitle'] as String?,
      artistId: json['artistId'] as String?,
      albumId: json['albumId'] as String?,
      streamUrl: json['streamUrl'] as String?,
    );

Map<String, dynamic> _$$TrackImplToJson(_$TrackImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'artist': instance.artist,
      'albumArt': instance.albumArt,
      'duration': instance.duration,
      'videoId': instance.videoId,
      'channelTitle': instance.channelTitle,
      'artistId': instance.artistId,
      'albumId': instance.albumId,
      'streamUrl': instance.streamUrl,
    };
