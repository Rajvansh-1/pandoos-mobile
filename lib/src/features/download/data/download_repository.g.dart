// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_repository.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadTrackAdapter extends TypeAdapter<DownloadTrack> {
  @override
  final int typeId = 1;

  @override
  DownloadTrack read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadTrack(
      videoId: fields[0] as String,
      title: fields[1] as String,
      artist: fields[2] as String,
      localFilePath: fields[3] as String,
      albumArt: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadTrack obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.videoId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.localFilePath)
      ..writeByte(4)
      ..write(obj.albumArt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadTrackAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
