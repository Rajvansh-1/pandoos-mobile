import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../../core/panda/panda_state.dart';
import '../../panda_mood/presentation/mood_notifier.dart';

class MoodRailWidget extends ConsumerWidget {
  const MoodRailWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodState = ref.watch(moodNotifierProvider);

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: PandaMood.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final mood = PandaMood.values[index];
          final isSelected = moodState.currentMood == mood;

          return GestureDetector(
            onTap: () {
              if (isSelected && moodState.isManualOverride) {
                ref.read(moodNotifierProvider.notifier).clearManualMood();
              } else {
                ref.read(moodNotifierProvider.notifier).setManualMood(mood);
              }
            },
            child: AnimatedContainer(
              duration: 300.ms,
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? PandoosColors.primary : PandoosColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? PandoosColors.primaryGlow : PandoosColors.surfaceHigh,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: PandoosColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8, offset: const Offset(0, 2),
                  )
                ] : null,
              ),
              child: Text(
                mood.name.toUpperCase(),
                style: PandoosTypography.labelLarge.copyWith(
                  color: isSelected ? Colors.white : PandoosColors.textMuted,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ).animate(delay: (index * 50).ms).fadeIn().slideX(begin: 0.2);
        },
      ),
    );
  }
}
