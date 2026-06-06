// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lyrics_line.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LyricsLine {
  Duration get time => throw _privateConstructorUsedError;
  String get words => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LyricsLineCopyWith<LyricsLine> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LyricsLineCopyWith<$Res> {
  factory $LyricsLineCopyWith(
          LyricsLine value, $Res Function(LyricsLine) then) =
      _$LyricsLineCopyWithImpl<$Res, LyricsLine>;
  @useResult
  $Res call({Duration time, String words});
}

/// @nodoc
class _$LyricsLineCopyWithImpl<$Res, $Val extends LyricsLine>
    implements $LyricsLineCopyWith<$Res> {
  _$LyricsLineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? words = null,
  }) {
    return _then(_value.copyWith(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as Duration,
      words: null == words
          ? _value.words
          : words // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LyricsLineImplCopyWith<$Res>
    implements $LyricsLineCopyWith<$Res> {
  factory _$$LyricsLineImplCopyWith(
          _$LyricsLineImpl value, $Res Function(_$LyricsLineImpl) then) =
      __$$LyricsLineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Duration time, String words});
}

/// @nodoc
class __$$LyricsLineImplCopyWithImpl<$Res>
    extends _$LyricsLineCopyWithImpl<$Res, _$LyricsLineImpl>
    implements _$$LyricsLineImplCopyWith<$Res> {
  __$$LyricsLineImplCopyWithImpl(
      _$LyricsLineImpl _value, $Res Function(_$LyricsLineImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? words = null,
  }) {
    return _then(_$LyricsLineImpl(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as Duration,
      words: null == words
          ? _value.words
          : words // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LyricsLineImpl implements _LyricsLine {
  const _$LyricsLineImpl({required this.time, required this.words});

  @override
  final Duration time;
  @override
  final String words;

  @override
  String toString() {
    return 'LyricsLine(time: $time, words: $words)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LyricsLineImpl &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.words, words) || other.words == words));
  }

  @override
  int get hashCode => Object.hash(runtimeType, time, words);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LyricsLineImplCopyWith<_$LyricsLineImpl> get copyWith =>
      __$$LyricsLineImplCopyWithImpl<_$LyricsLineImpl>(this, _$identity);
}

abstract class _LyricsLine implements LyricsLine {
  const factory _LyricsLine(
      {required final Duration time,
      required final String words}) = _$LyricsLineImpl;

  @override
  Duration get time;
  @override
  String get words;
  @override
  @JsonKey(ignore: true)
  _$$LyricsLineImplCopyWith<_$LyricsLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
