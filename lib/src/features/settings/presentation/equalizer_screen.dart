import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/neon_button.dart';

final _eqProvider = StateNotifierProvider<EqNotifier, EqState>((ref) => EqNotifier());

class EqState {
  final List<double> bands; // 5 bands: 60Hz 230Hz 910Hz 4kHz 14kHz
  final int presetIndex;
  EqState({required this.bands, required this.presetIndex});
  EqState copyWith({List<double>? bands, int? presetIndex}) =>
      EqState(bands: bands ?? this.bands, presetIndex: presetIndex ?? this.presetIndex);
}

class EqNotifier extends StateNotifier<EqState> {
  static const presets = {
    'Flat':      [0.0, 0.0, 0.0, 0.0, 0.0],
    'Bass Boost':[6.0, 4.0, 0.0, -2.0, -4.0],
    'Treble':    [-4.0, -2.0, 0.0, 4.0, 6.0],
    'Vocal':     [-2.0, 0.0, 4.0, 4.0, -2.0],
    'Rock':      [4.0, 2.0, -2.0, 2.0, 4.0],
    'Jazz':      [3.0, 0.0, 2.0, 3.0, 2.0],
  };

  EqNotifier() : super(EqState(bands: List.filled(5, 0.0), presetIndex: 0)) {
    final box = Hive.box('settings');
    final saved = box.get('eq_bands');
    if (saved != null) {
      state = state.copyWith(bands: List<double>.from(saved));
    }
  }

  void setBand(int index, double value) {
    final newBands = List<double>.from(state.bands)..[index] = value;
    Hive.box('settings').put('eq_bands', newBands);
    state = state.copyWith(bands: newBands, presetIndex: -1);
  }

  void applyPreset(int index) {
    final bands = presets.values.elementAt(index);
    Hive.box('settings').put('eq_bands', bands);
    state = state.copyWith(bands: List<double>.from(bands), presetIndex: index);
  }

  void reset() => applyPreset(0);
}

class EqualizerScreen extends ConsumerWidget {
  const EqualizerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eqState = ref.watch(_eqProvider);
    final notifier = ref.read(_eqProvider.notifier);
    final bandLabels = ['60Hz', '230Hz', '910Hz', '4kHz', '14kHz'];
    final presetNames = EqNotifier.presets.keys.toList();

    return Scaffold(
      backgroundColor: PandoosColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.white), onPressed: () => context.pop()),
        title: Text('Equalizer', style: PandoosTypography.h2),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: notifier.reset,
            child: Text('Reset', style: PandoosTypography.labelLarge.copyWith(color: PandoosColors.accent)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // EQ Sliders
            GlassCard(
              borderRadius: 24,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(5, (i) {
                  return Column(
                    children: [
                      Text(
                        '${eqState.bands[i] >= 0 ? '+' : ''}${eqState.bands[i].toStringAsFixed(0)}',
                        style: PandoosTypography.caption.copyWith(color: PandoosColors.primary),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 200,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                              activeTrackColor: PandoosColors.primary,
                              inactiveTrackColor: Colors.white12,
                              thumbColor: Colors.white,
                              overlayColor: PandoosColors.primary.withValues(alpha: 0.2),
                            ),
                            child: Slider(
                              min: -10,
                              max: 10,
                              value: eqState.bands[i],
                              onChanged: (v) => notifier.setBand(i, v),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(bandLabels[i], style: PandoosTypography.caption.copyWith(color: Colors.white54)),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 32),

            Text('Presets', style: PandoosTypography.h3),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(presetNames.length, (i) {
                final isSelected = eqState.presetIndex == i;
                return GestureDetector(
                  onTap: () => notifier.applyPreset(i),
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
                      presetNames[i],
                      style: PandoosTypography.labelLarge.copyWith(
                        color: isSelected ? PandoosColors.primary : Colors.white,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
