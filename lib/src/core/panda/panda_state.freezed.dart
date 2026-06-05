// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'panda_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PandaState {
  PandaMood get mood => throw _privateConstructorUsedError;
  PlaybackMood get playback => throw _privateConstructorUsedError;
  double get energyLevel => throw _privateConstructorUsedError;
  double get bpm => throw _privateConstructorUsedError;
  double get amplitude => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PandaStateCopyWith<PandaState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PandaStateCopyWith<$Res> {
  factory $PandaStateCopyWith(
          PandaState value, $Res Function(PandaState) then) =
      _$PandaStateCopyWithImpl<$Res, PandaState>;
  @useResult
  $Res call(
      {PandaMood mood,
      PlaybackMood playback,
      double energyLevel,
      double bpm,
      double amplitude});
}

/// @nodoc
class _$PandaStateCopyWithImpl<$Res, $Val extends PandaState>
    implements $PandaStateCopyWith<$Res> {
  _$PandaStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mood = null,
    Object? playback = null,
    Object? energyLevel = null,
    Object? bpm = null,
    Object? amplitude = null,
  }) {
    return _then(_value.copyWith(
      mood: null == mood
          ? _value.mood
          : mood // ignore: cast_nullable_to_non_nullable
              as PandaMood,
      playback: null == playback
          ? _value.playback
          : playback // ignore: cast_nullable_to_non_nullable
              as PlaybackMood,
      energyLevel: null == energyLevel
          ? _value.energyLevel
          : energyLevel // ignore: cast_nullable_to_non_nullable
              as double,
      bpm: null == bpm
          ? _value.bpm
          : bpm // ignore: cast_nullable_to_non_nullable
              as double,
      amplitude: null == amplitude
          ? _value.amplitude
          : amplitude // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PandaStateImplCopyWith<$Res>
    implements $PandaStateCopyWith<$Res> {
  factory _$$PandaStateImplCopyWith(
          _$PandaStateImpl value, $Res Function(_$PandaStateImpl) then) =
      __$$PandaStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PandaMood mood,
      PlaybackMood playback,
      double energyLevel,
      double bpm,
      double amplitude});
}

/// @nodoc
class __$$PandaStateImplCopyWithImpl<$Res>
    extends _$PandaStateCopyWithImpl<$Res, _$PandaStateImpl>
    implements _$$PandaStateImplCopyWith<$Res> {
  __$$PandaStateImplCopyWithImpl(
      _$PandaStateImpl _value, $Res Function(_$PandaStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mood = null,
    Object? playback = null,
    Object? energyLevel = null,
    Object? bpm = null,
    Object? amplitude = null,
  }) {
    return _then(_$PandaStateImpl(
      mood: null == mood
          ? _value.mood
          : mood // ignore: cast_nullable_to_non_nullable
              as PandaMood,
      playback: null == playback
          ? _value.playback
          : playback // ignore: cast_nullable_to_non_nullable
              as PlaybackMood,
      energyLevel: null == energyLevel
          ? _value.energyLevel
          : energyLevel // ignore: cast_nullable_to_non_nullable
              as double,
      bpm: null == bpm
          ? _value.bpm
          : bpm // ignore: cast_nullable_to_non_nullable
              as double,
      amplitude: null == amplitude
          ? _value.amplitude
          : amplitude // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$PandaStateImpl implements _PandaState {
  const _$PandaStateImpl(
      {required this.mood,
      required this.playback,
      required this.energyLevel,
      required this.bpm,
      required this.amplitude});

  @override
  final PandaMood mood;
  @override
  final PlaybackMood playback;
  @override
  final double energyLevel;
  @override
  final double bpm;
  @override
  final double amplitude;

  @override
  String toString() {
    return 'PandaState(mood: $mood, playback: $playback, energyLevel: $energyLevel, bpm: $bpm, amplitude: $amplitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PandaStateImpl &&
            (identical(other.mood, mood) || other.mood == mood) &&
            (identical(other.playback, playback) ||
                other.playback == playback) &&
            (identical(other.energyLevel, energyLevel) ||
                other.energyLevel == energyLevel) &&
            (identical(other.bpm, bpm) || other.bpm == bpm) &&
            (identical(other.amplitude, amplitude) ||
                other.amplitude == amplitude));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, mood, playback, energyLevel, bpm, amplitude);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PandaStateImplCopyWith<_$PandaStateImpl> get copyWith =>
      __$$PandaStateImplCopyWithImpl<_$PandaStateImpl>(this, _$identity);
}

abstract class _PandaState implements PandaState {
  const factory _PandaState(
      {required final PandaMood mood,
      required final PlaybackMood playback,
      required final double energyLevel,
      required final double bpm,
      required final double amplitude}) = _$PandaStateImpl;

  @override
  PandaMood get mood;
  @override
  PlaybackMood get playback;
  @override
  double get energyLevel;
  @override
  double get bpm;
  @override
  double get amplitude;
  @override
  @JsonKey(ignore: true)
  _$$PandaStateImplCopyWith<_$PandaStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
