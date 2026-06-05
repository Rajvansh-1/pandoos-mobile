// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'now_playing_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NowPlayingState _$NowPlayingStateFromJson(Map<String, dynamic> json) {
  return _NowPlayingState.fromJson(json);
}

/// @nodoc
mixin _$NowPlayingState {
  String get userId => throw _privateConstructorUsedError;
  String get videoId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get artist => throw _privateConstructorUsedError;
  String get albumArt => throw _privateConstructorUsedError;
  bool get isPlaying => throw _privateConstructorUsedError;
  double get progress => throw _privateConstructorUsedError;
  String get deviceName => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NowPlayingStateCopyWith<NowPlayingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NowPlayingStateCopyWith<$Res> {
  factory $NowPlayingStateCopyWith(
          NowPlayingState value, $Res Function(NowPlayingState) then) =
      _$NowPlayingStateCopyWithImpl<$Res, NowPlayingState>;
  @useResult
  $Res call(
      {String userId,
      String videoId,
      String title,
      String artist,
      String albumArt,
      bool isPlaying,
      double progress,
      String deviceName,
      String updatedAt});
}

/// @nodoc
class _$NowPlayingStateCopyWithImpl<$Res, $Val extends NowPlayingState>
    implements $NowPlayingStateCopyWith<$Res> {
  _$NowPlayingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? videoId = null,
    Object? title = null,
    Object? artist = null,
    Object? albumArt = null,
    Object? isPlaying = null,
    Object? progress = null,
    Object? deviceName = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      videoId: null == videoId
          ? _value.videoId
          : videoId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      artist: null == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as String,
      albumArt: null == albumArt
          ? _value.albumArt
          : albumArt // ignore: cast_nullable_to_non_nullable
              as String,
      isPlaying: null == isPlaying
          ? _value.isPlaying
          : isPlaying // ignore: cast_nullable_to_non_nullable
              as bool,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      deviceName: null == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NowPlayingStateImplCopyWith<$Res>
    implements $NowPlayingStateCopyWith<$Res> {
  factory _$$NowPlayingStateImplCopyWith(_$NowPlayingStateImpl value,
          $Res Function(_$NowPlayingStateImpl) then) =
      __$$NowPlayingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String videoId,
      String title,
      String artist,
      String albumArt,
      bool isPlaying,
      double progress,
      String deviceName,
      String updatedAt});
}

/// @nodoc
class __$$NowPlayingStateImplCopyWithImpl<$Res>
    extends _$NowPlayingStateCopyWithImpl<$Res, _$NowPlayingStateImpl>
    implements _$$NowPlayingStateImplCopyWith<$Res> {
  __$$NowPlayingStateImplCopyWithImpl(
      _$NowPlayingStateImpl _value, $Res Function(_$NowPlayingStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? videoId = null,
    Object? title = null,
    Object? artist = null,
    Object? albumArt = null,
    Object? isPlaying = null,
    Object? progress = null,
    Object? deviceName = null,
    Object? updatedAt = null,
  }) {
    return _then(_$NowPlayingStateImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      videoId: null == videoId
          ? _value.videoId
          : videoId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      artist: null == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as String,
      albumArt: null == albumArt
          ? _value.albumArt
          : albumArt // ignore: cast_nullable_to_non_nullable
              as String,
      isPlaying: null == isPlaying
          ? _value.isPlaying
          : isPlaying // ignore: cast_nullable_to_non_nullable
              as bool,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      deviceName: null == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NowPlayingStateImpl implements _NowPlayingState {
  const _$NowPlayingStateImpl(
      {required this.userId,
      required this.videoId,
      required this.title,
      required this.artist,
      required this.albumArt,
      required this.isPlaying,
      required this.progress,
      required this.deviceName,
      required this.updatedAt});

  factory _$NowPlayingStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$NowPlayingStateImplFromJson(json);

  @override
  final String userId;
  @override
  final String videoId;
  @override
  final String title;
  @override
  final String artist;
  @override
  final String albumArt;
  @override
  final bool isPlaying;
  @override
  final double progress;
  @override
  final String deviceName;
  @override
  final String updatedAt;

  @override
  String toString() {
    return 'NowPlayingState(userId: $userId, videoId: $videoId, title: $title, artist: $artist, albumArt: $albumArt, isPlaying: $isPlaying, progress: $progress, deviceName: $deviceName, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NowPlayingStateImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.videoId, videoId) || other.videoId == videoId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.artist, artist) || other.artist == artist) &&
            (identical(other.albumArt, albumArt) ||
                other.albumArt == albumArt) &&
            (identical(other.isPlaying, isPlaying) ||
                other.isPlaying == isPlaying) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.deviceName, deviceName) ||
                other.deviceName == deviceName) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId, videoId, title, artist,
      albumArt, isPlaying, progress, deviceName, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NowPlayingStateImplCopyWith<_$NowPlayingStateImpl> get copyWith =>
      __$$NowPlayingStateImplCopyWithImpl<_$NowPlayingStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NowPlayingStateImplToJson(
      this,
    );
  }
}

abstract class _NowPlayingState implements NowPlayingState {
  const factory _NowPlayingState(
      {required final String userId,
      required final String videoId,
      required final String title,
      required final String artist,
      required final String albumArt,
      required final bool isPlaying,
      required final double progress,
      required final String deviceName,
      required final String updatedAt}) = _$NowPlayingStateImpl;

  factory _NowPlayingState.fromJson(Map<String, dynamic> json) =
      _$NowPlayingStateImpl.fromJson;

  @override
  String get userId;
  @override
  String get videoId;
  @override
  String get title;
  @override
  String get artist;
  @override
  String get albumArt;
  @override
  bool get isPlaying;
  @override
  double get progress;
  @override
  String get deviceName;
  @override
  String get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$NowPlayingStateImplCopyWith<_$NowPlayingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
