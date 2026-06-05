import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/neon_button.dart';
import '../../sync/presentation/continue_listening_notifier.dart';
import '../../../core/audio/audio_service_provider.dart';
import '../../../core/models/track.dart';

class ContinueListeningBanner extends ConsumerWidget {
  const ContinueListeningBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(continueListeningProvider);

    return syncState.when(
      data: (nowPlaying) {
        if (nowPlaying == null) {
          return _buildFallbackBanner();
        }

        return GlassCard(
          borderRadius: 20,
          padding: const EdgeInsets.all(20),
          fillColor: PandoosColors.primaryGlow,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: PandoosColors.primary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.devices_rounded, size: 12, color: PandoosColors.primary),
                          const SizedBox(width: 4),
                          Text('CONTINUE ON ${nowPlaying.deviceName.toUpperCase()}', 
                            style: PandoosTypography.labelSmall.copyWith(color: PandoosColors.primary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(nowPlaying.title, style: PandoosTypography.h2, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(nowPlaying.artist, style: PandoosTypography.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 16),
                    NeonButton(
                      label: 'Resume',
                      icon: Icons.play_arrow_rounded,
                      onPressed: () {
                        final track = Track(
                          id: nowPlaying.videoId,
                          videoId: nowPlaying.videoId,
                          title: nowPlaying.title,
                          artist: nowPlaying.artist,
                          albumArt: nowPlaying.albumArt,
                          duration: 0,
                        );
                        ref.read(audioHandlerProvider).playTrack(track);
                      },
                      width: 110,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: nowPlaying.albumArt,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    width: 90, height: 90,
                    color: PandoosColors.surfaceHigh,
                    child: const Icon(Icons.music_note_rounded, color: PandoosColors.textMuted),
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
      },
      loading: () => const SizedBox(height: 140, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => _buildFallbackBanner(),
    );
  }

  Widget _buildFallbackBanner() {
    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(20),
      fillColor: PandoosColors.primaryGlow,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: PandoosColors.primary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('FEATURED', style: PandoosTypography.labelSmall.copyWith(
                    color: PandoosColors.primary,
                  )),
                ),
                const SizedBox(height: 10),
                Text('Your Daily Mix', style: PandoosTypography.h2),
                const SizedBox(height: 4),
                Text('32 songs curated just for you',
                    style: PandoosTypography.bodyMedium),
                const SizedBox(height: 16),
                NeonButton(
                  label: 'Play All',
                  onPressed: () {},
                  width: 110,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [PandoosColors.primary, PandoosColors.pink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(
                color: PandoosColors.primary.withValues(alpha: 0.5),
                blurRadius: 20, offset: const Offset(0, 8),
              )],
            ),
            child: const Icon(Icons.queue_music_rounded, color: Colors.white, size: 40),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }
}
