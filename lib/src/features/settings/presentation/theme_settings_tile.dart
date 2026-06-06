import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';

final _themeOptions = [
  {'name': 'Deep Space', 'primary': const Color(0xFF8B5CF6), 'accent': const Color(0xFFE535AB)},
  {'name': 'Ocean Pulse', 'primary': const Color(0xFF06B6D4), 'accent': const Color(0xFF6366F1)},
  {'name': 'Neon Ember', 'primary': const Color(0xFFEF4444), 'accent': const Color(0xFFF97316)},
  {'name': 'Forest Glow', 'primary': const Color(0xFF22C55E), 'accent': const Color(0xFF06B6D4)},
];

class ThemeSettingsTile extends ConsumerWidget {
  const ThemeSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final box = Hive.box('settings');
    final selectedThemeIndex = box.get('theme_index', defaultValue: 0) as int;
    final selectedTheme = _themeOptions[selectedThemeIndex.clamp(0, _themeOptions.length - 1)];

    return ListTile(
      leading: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [selectedTheme['primary'] as Color, selectedTheme['accent'] as Color],
          ),
        ),
      ),
      title: Text('Theme', style: PandoosTypography.bodyLarge),
      subtitle: Text(selectedTheme['name'] as String, style: PandoosTypography.caption),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white54),
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: PandoosColors.surface,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          builder: (ctx) => StatefulBuilder(
            builder: (ctx, setSheetState) {
              final currentIdx = box.get('theme_index', defaultValue: 0) as int;
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Choose Theme', style: PandoosTypography.h2),
                    const SizedBox(height: 24),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 2.5,
                      children: List.generate(_themeOptions.length, (i) {
                        final theme = _themeOptions[i];
                        final isSelected = i == currentIdx;
                        return GestureDetector(
                          onTap: () {
                            box.put('theme_index', i);
                            setSheetState(() {});
                            Navigator.pop(ctx);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: LinearGradient(
                                colors: [theme['primary'] as Color, theme['accent'] as Color],
                              ),
                              border: Border.all(
                                color: isSelected ? Colors.white : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              theme['name'] as String,
                              style: PandoosTypography.labelLarge.copyWith(color: Colors.white),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
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
