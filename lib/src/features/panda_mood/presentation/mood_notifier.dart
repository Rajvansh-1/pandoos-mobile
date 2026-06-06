import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/mood_state.dart';
import '../domain/infer_mood_usecase.dart';
import '../data/behavior_tracker.dart';
import '../data/mood_repository.dart';
import '../../../core/panda/panda_state.dart';

final moodNotifierProvider = StateNotifierProvider<MoodNotifier, MoodState>((ref) {
  return MoodNotifier(
    ref.watch(inferMoodUseCaseProvider),
    ref.watch(behaviorTrackerProvider),
    ref.watch(moodRepositoryProvider),
  );
});

class MoodNotifier extends StateNotifier<MoodState> {
  final InferMoodUseCase _inferMoodUseCase;
  final BehaviorTracker _behaviorTracker;
  final MoodRepository _moodRepository;

  MoodNotifier(this._inferMoodUseCase, this._behaviorTracker, this._moodRepository)
      : super(const MoodState()) {
    _init();
  }

  void _init() {
    final savedMood = _moodRepository.getManualMood();
    if (savedMood != null) {
      state = state.copyWith(currentMood: savedMood, isManualOverride: true);
    } else {
      recalculateMood();
    }
  }

  void recalculateMood({double currentEnergy = 0.5}) {
    if (state.isManualOverride) return;

    final inferred = _inferMoodUseCase.execute(
      averageEnergy: currentEnergy,
      skipCount: _behaviorTracker.skipCount,
      isManualOverride: state.isManualOverride,
      currentMood: state.currentMood,
    );

    if (inferred != state.currentMood) {
      state = state.copyWith(currentMood: inferred, energyLevel: currentEnergy);
    }
  }

  void setManualMood(PandaMood mood) {
    state = state.copyWith(currentMood: mood, isManualOverride: true);
    _moodRepository.saveManualMood(mood);
  }

  void clearManualMood() {
    state = state.copyWith(isManualOverride: false);
    _moodRepository.clearManualMood();
    recalculateMood();
  }
}
