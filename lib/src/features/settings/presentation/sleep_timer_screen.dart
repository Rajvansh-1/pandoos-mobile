import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/audio/audio_service_provider.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/neon_button.dart';

final _sleepTimerProvider = StateNotifierProvider<SleepTimerNotifier, SleepTimerState>((ref) {
  return SleepTimerNotifier(ref);
});

class SleepTimerState {
  final bool isActive;
  final Duration remaining;
  final Duration selected;
  SleepTimerState({required this.isActive, required this.remaining, required this.selected});
  SleepTimerState copyWith({bool? isActive, Duration? remaining, Duration? selected}) =>
      SleepTimerState(isActive: isActive ?? this.isActive, remaining: remaining ?? this.remaining, selected: selected ?? this.selected);
}

class SleepTimerNotifier extends StateNotifier<SleepTimerState> {
  final Ref _ref;
  Timer? _timer;

  SleepTimerNotifier(this._ref) : super(SleepTimerState(isActive: false, remaining: Duration.zero, selected: const Duration(minutes: 30)));

  void setDuration(Duration d) => state = state.copyWith(selected: d, remaining: d);

  void start() {
    _timer?.cancel();
    state = state.copyWith(isActive: true, remaining: state.selected);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remaining.inSeconds <= 1) {
        _ref.read(audioHandlerProvider).pause();
        cancel();
      } else {
        state = state.copyWith(remaining: state.remaining - const Duration(seconds: 1));
      }
    });
  }

  void cancel() {
    _timer?.cancel();
    state = state.copyWith(isActive: false, remaining: Duration.zero);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class SleepTimerScreen extends ConsumerWidget {
  const SleepTimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_sleepTimerProvider);
    final notifier = ref.read(_sleepTimerProvider.notifier);

    final presets = [
      const Duration(minutes: 10),
      const Duration(minutes: 20),
      const Duration(minutes: 30),
      const Duration(minutes: 45),
      const Duration(minutes: 60),
      const Duration(minutes: 90),
    ];

    String fmtDuration(Duration d) {
      final m = d.inMinutes;
      final s = d.inSeconds % 60;
      return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }

    return Scaffold(
      backgroundColor: PandoosColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.white), onPressed: () => context.pop()),
        title: Text('Sleep Timer', style: PandoosTypography.h2),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Countdown display
            GlassCard(
              borderRadius: 28,
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(Icons.nightlight_round, size: 48, color: state.isActive ? PandoosColors.accent : Colors.white24),
                  const SizedBox(height: 16),
                  Text(
                    state.isActive ? fmtDuration(state.remaining) : fmtDuration(state.selected),
                    style: PandoosTypography.display2.copyWith(fontSize: 56, letterSpacing: 4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.isActive ? 'Music stops in...' : 'Select a duration',
                    style: PandoosTypography.bodyMedium.copyWith(color: Colors.white54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            if (!state.isActive) ...[
              Text('Quick select', style: PandoosTypography.labelLarge.copyWith(color: Colors.white54)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: presets.map((d) {
                  final isSelected = d == state.selected;
                  return GestureDetector(
                    onTap: () => notifier.setDuration(d),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: isSelected ? PandoosColors.primary.withValues(alpha: 0.2) : PandoosColors.surfaceHigh,
                        border: Border.all(
                          color: isSelected ? PandoosColors.primary : Colors.white12,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Text(
                        '${d.inMinutes}m',
                        style: PandoosTypography.labelLarge.copyWith(
                          color: isSelected ? PandoosColors.primary : Colors.white,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              NeonButton(label: 'Start Timer', icon: Icons.play_arrow_rounded, onPressed: notifier.start),
            ] else ...[
              const Spacer(),
              OutlinedButton.icon(
                icon: const Icon(Icons.cancel_outlined, color: PandoosColors.error),
                label: Text('Cancel Timer', style: PandoosTypography.labelLarge.copyWith(color: PandoosColors.error)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: PandoosColors.error),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: notifier.cancel,
              ),
              const Spacer(),
            ],
          ],
        ),
      ),
    );
  }
}
