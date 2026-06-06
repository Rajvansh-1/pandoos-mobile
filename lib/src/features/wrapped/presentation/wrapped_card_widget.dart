import 'package:flutter/material.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../../core/widgets/glass_card.dart';

class WrappedCardWidget extends StatelessWidget {
  final String topArtist;
  final String topSong;
  final int minutesListened;
  final String dominantMood;

  const WrappedCardWidget({
    super.key,
    required this.topArtist,
    required this.topSong,
    required this.minutesListened,
    required this.dominantMood,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [Color(0xFF9856E3), PandoosColors.pink],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: PandoosColors.pink.withValues(alpha: 0.4),
            blurRadius: 40,
            spreadRadius: 10,
          )
        ],
      ),
      child: GlassCard(
        borderRadius: 32,
        blur: 10,
        fillColor: Colors.black.withValues(alpha: 0.2),
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/images/logo.png', width: 40, height: 40, errorBuilder: (_,__,___) => const Icon(Icons.music_note, color: Colors.white, size: 40)),
                Text('Pandoos Wrapped', style: PandoosTypography.labelLarge.copyWith(color: Colors.white70)),
              ],
            ),
            const SizedBox(height: 40),
            Text('Top Artist', style: PandoosTypography.labelSmall.copyWith(color: Colors.white54)),
            Text(topArtist, style: PandoosTypography.display2),
            const SizedBox(height: 24),
            Text('Top Song', style: PandoosTypography.labelSmall.copyWith(color: Colors.white54)),
            Text(topSong, style: PandoosTypography.h1),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Minutes', style: PandoosTypography.labelSmall.copyWith(color: Colors.white54)),
                    Text(minutesListened.toString(), style: PandoosTypography.h2),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Your Vibe', style: PandoosTypography.labelSmall.copyWith(color: Colors.white54)),
                    Text(dominantMood, style: PandoosTypography.h2.copyWith(color: PandoosColors.accent)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
