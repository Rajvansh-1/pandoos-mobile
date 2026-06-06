import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/panda/panda_state.dart';
import 'mood_notifier.dart';

class MoodSelectorScreen extends ConsumerWidget {
  const MoodSelectorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMoodState = ref.watch(moodNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Blur background
          Positioned.fill(
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                color: PandoosColors.background.withValues(alpha: 0.6),
              ),
            ),
          ),
          
          Center(
            child: GlassCard(
              borderRadius: 32,
              padding: const EdgeInsets.all(24),
              fillColor: PandoosColors.surfaceHigh.withValues(alpha: 0.6),
              borderColor: PandoosColors.primary.withValues(alpha: 0.3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('How are you feeling?', style: PandoosTypography.h2),
                  const SizedBox(height: 8),
                  Text('Override the Panda\'s inference.', style: PandoosTypography.bodyMedium),
                  const SizedBox(height: 24),
                  
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: PandaMood.values.map((mood) {
                      final isSelected = currentMoodState.currentMood == mood && currentMoodState.isManualOverride;
                      return _buildMoodChip(context, ref, mood, isSelected);
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  if (currentMoodState.isManualOverride)
                    TextButton(
                      onPressed: () {
                        ref.read(moodNotifierProvider.notifier).clearManualMood();
                        context.pop();
                      },
                      child: Text('Reset to Auto-Detect', style: PandoosTypography.labelLarge.copyWith(color: PandoosColors.textMuted)),
                    ).animate().fadeIn(),
                ],
              ),
            ).animate().scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack, duration: 400.ms).fadeIn(),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodChip(BuildContext context, WidgetRef ref, PandaMood mood, bool isSelected) {
    final name = mood.name.toUpperCase();
    
    return GestureDetector(
      onTap: () {
        ref.read(moodNotifierProvider.notifier).setManualMood(mood);
        context.pop();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? PandoosColors.primary : PandoosColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? PandoosColors.primaryGlow : PandoosColors.surfaceHigh,
            width: 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: PandoosColors.primary.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ] : null,
        ),
        child: Text(
          name,
          style: PandoosTypography.labelLarge.copyWith(
            color: isSelected ? Colors.white : PandoosColors.textMuted,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
