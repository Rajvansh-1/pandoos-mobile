import 'package:flutter/material.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../../core/widgets/glass_card.dart';

class TrendingChips extends StatelessWidget {
  const TrendingChips({super.key});

  @override
  Widget build(BuildContext context) {
    final trends = ['Lo-Fi Beats', 'The Weeknd', 'Workout Mix', 'Acoustic Covers', 'Trending Now', 'Focus'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text('Trending', style: PandoosTypography.h3),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: trends.map((trend) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GlassCard(
                borderRadius: 20,
                blur: 10,
                fillColor: PandoosColors.surfaceHigh.withValues(alpha: 0.5),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text(trend, style: PandoosTypography.bodyMedium),
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }
}
