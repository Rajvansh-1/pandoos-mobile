import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/panda/panda_state.dart';

final inferMoodUseCaseProvider = Provider<InferMoodUseCase>((ref) {
  return InferMoodUseCase();
});

class InferMoodUseCase {
  PandaMood execute({
    required double averageEnergy,
    required int skipCount,
    required bool isManualOverride,
    required PandaMood currentMood,
  }) {
    if (isManualOverride) return currentMood;

    final hour = DateTime.now().hour;

    // Time-based baseline
    PandaMood baseMood = PandaMood.neutral;
    if (hour >= 6 && hour < 10) {
      baseMood = PandaMood.focused;
    } else if (hour >= 10 && hour < 16) {
      baseMood = PandaMood.happy;
    } else if (hour >= 16 && hour < 21) {
      baseMood = PandaMood.hype;
    } else {
      baseMood = PandaMood.sleepy;
    }

    // Energy & behavior adjustments
    if (skipCount > 3) {
      return PandaMood.curious; // User is searching for something
    }

    if (averageEnergy > 0.8) {
      return PandaMood.hype;
    } else if (averageEnergy < 0.3) {
      return PandaMood.melancholy;
    }

    return baseMood;
  }
}
