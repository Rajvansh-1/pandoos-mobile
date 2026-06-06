import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/panda/panda_state.dart';

part 'mood_state.freezed.dart';

@freezed
class MoodState with _$MoodState {
  const factory MoodState({
    @Default(PandaMood.neutral) PandaMood currentMood,
    @Default(false) bool isManualOverride,
    @Default(0.5) double energyLevel,
  }) = _MoodState;
}
