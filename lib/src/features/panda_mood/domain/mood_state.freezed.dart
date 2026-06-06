// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mood_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MoodState {
  PandaMood get currentMood => throw _privateConstructorUsedError;
  bool get isManualOverride => throw _privateConstructorUsedError;
  double get energyLevel => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MoodStateCopyWith<MoodState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoodStateCopyWith<$Res> {
  factory $MoodStateCopyWith(MoodState value, $Res Function(MoodState) then) =
      _$MoodStateCopyWithImpl<$Res, MoodState>;
  @useResult
  $Res call({PandaMood currentMood, bool isManualOverride, double energyLevel});
}

/// @nodoc
class _$MoodStateCopyWithImpl<$Res, $Val extends MoodState>
    implements $MoodStateCopyWith<$Res> {
  _$MoodStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentMood = null,
    Object? isManualOverride = null,
    Object? energyLevel = null,
  }) {
    return _then(_value.copyWith(
      currentMood: null == currentMood
          ? _value.currentMood
          : currentMood // ignore: cast_nullable_to_non_nullable
              as PandaMood,
      isManualOverride: null == isManualOverride
          ? _value.isManualOverride
          : isManualOverride // ignore: cast_nullable_to_non_nullable
              as bool,
      energyLevel: null == energyLevel
          ? _value.energyLevel
          : energyLevel // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MoodStateImplCopyWith<$Res>
    implements $MoodStateCopyWith<$Res> {
  factory _$$MoodStateImplCopyWith(
          _$MoodStateImpl value, $Res Function(_$MoodStateImpl) then) =
      __$$MoodStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PandaMood currentMood, bool isManualOverride, double energyLevel});
}

/// @nodoc
class __$$MoodStateImplCopyWithImpl<$Res>
    extends _$MoodStateCopyWithImpl<$Res, _$MoodStateImpl>
    implements _$$MoodStateImplCopyWith<$Res> {
  __$$MoodStateImplCopyWithImpl(
      _$MoodStateImpl _value, $Res Function(_$MoodStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentMood = null,
    Object? isManualOverride = null,
    Object? energyLevel = null,
  }) {
    return _then(_$MoodStateImpl(
      currentMood: null == currentMood
          ? _value.currentMood
          : currentMood // ignore: cast_nullable_to_non_nullable
              as PandaMood,
      isManualOverride: null == isManualOverride
          ? _value.isManualOverride
          : isManualOverride // ignore: cast_nullable_to_non_nullable
              as bool,
      energyLevel: null == energyLevel
          ? _value.energyLevel
          : energyLevel // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$MoodStateImpl implements _MoodState {
  const _$MoodStateImpl(
      {this.currentMood = PandaMood.neutral,
      this.isManualOverride = false,
      this.energyLevel = 0.5});

  @override
  @JsonKey()
  final PandaMood currentMood;
  @override
  @JsonKey()
  final bool isManualOverride;
  @override
  @JsonKey()
  final double energyLevel;

  @override
  String toString() {
    return 'MoodState(currentMood: $currentMood, isManualOverride: $isManualOverride, energyLevel: $energyLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoodStateImpl &&
            (identical(other.currentMood, currentMood) ||
                other.currentMood == currentMood) &&
            (identical(other.isManualOverride, isManualOverride) ||
                other.isManualOverride == isManualOverride) &&
            (identical(other.energyLevel, energyLevel) ||
                other.energyLevel == energyLevel));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, currentMood, isManualOverride, energyLevel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MoodStateImplCopyWith<_$MoodStateImpl> get copyWith =>
      __$$MoodStateImplCopyWithImpl<_$MoodStateImpl>(this, _$identity);
}

abstract class _MoodState implements MoodState {
  const factory _MoodState(
      {final PandaMood currentMood,
      final bool isManualOverride,
      final double energyLevel}) = _$MoodStateImpl;

  @override
  PandaMood get currentMood;
  @override
  bool get isManualOverride;
  @override
  double get energyLevel;
  @override
  @JsonKey(ignore: true)
  _$$MoodStateImplCopyWith<_$MoodStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
