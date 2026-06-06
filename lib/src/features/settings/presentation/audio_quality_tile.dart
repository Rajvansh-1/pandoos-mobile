import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';

enum AudioQuality { low, medium, high, lossless }

extension AudioQualityExt on AudioQuality {
  String get label {
    switch (this) {
      case AudioQuality.low: return 'Low (64 kbps)';
      case AudioQuality.medium: return 'Medium (128 kbps)';
      case AudioQuality.high: return 'High (256 kbps)';
      case AudioQuality.lossless: return 'Lossless (320 kbps)';
    }
  }
  String get subtitle {
    switch (this) {
      case AudioQuality.low: return 'Saves data';
      case AudioQuality.medium: return 'Balanced';
      case AudioQuality.high: return 'Recommended';
      case AudioQuality.lossless: return 'Best quality, uses more data';
    }
  }
}

class AudioQualityTile extends ConsumerWidget {
  const AudioQualityTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final box = Hive.box('settings');
    final savedIndex = box.get('audio_quality', defaultValue: AudioQuality.high.index) as int;
    final currentQuality = AudioQuality.values[savedIndex.clamp(0, AudioQuality.values.length - 1)];

    return ListTile(
      leading: const Icon(Icons.high_quality_rounded, color: PandoosColors.primary),
      title: Text('Audio Quality', style: PandoosTypography.bodyLarge),
      subtitle: Text(currentQuality.label, style: PandoosTypography.caption),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white54),
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: PandoosColors.surface,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          builder: (ctx) => StatefulBuilder(
            builder: (ctx, setSheetState) {
              final currentIdx = box.get('audio_quality', defaultValue: AudioQuality.high.index) as int;
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Audio Quality', style: PandoosTypography.h2),
                    const SizedBox(height: 8),
                    Text('Higher quality uses more data and storage.', style: PandoosTypography.caption),
                    const SizedBox(height: 24),
                    ...AudioQuality.values.map((q) {
                      final isSelected = q.index == currentIdx;
                      return RadioListTile<int>(
                        value: q.index,
                        groupValue: currentIdx,
                        activeColor: PandoosColors.primary,
                        title: Text(q.label, style: PandoosTypography.bodyLarge),
                        subtitle: Text(q.subtitle, style: PandoosTypography.caption),
                        onChanged: (val) {
                          if (val != null) {
                            box.put('audio_quality', val);
                            setSheetState(() {});
                            Navigator.pop(ctx);
                          }
                        },
                      );
                    }),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
