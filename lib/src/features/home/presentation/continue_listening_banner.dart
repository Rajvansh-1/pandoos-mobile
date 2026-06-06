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

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            image: DecorationImage(
              image: CachedNetworkImageProvider(nowPlaying.albumArt),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.8),
                  Colors.black.withValues(alpha: 0.4),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: GlassCard(
              borderRadius: 24,
              blur: 16,
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: PandoosColors.primary.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: PandoosColors.primary.withValues(alpha: 0.5)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.devices_rounded, size: 14, color: Colors.white),
                              const SizedBox(width: 6),
                              Text('RESUME FROM ${nowPlaying.deviceName.toUpperCase()}', 
                                style: PandoosTypography.labelSmall.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(nowPlaying.title, style: PandoosTypography.h1.copyWith(fontSize: 22), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(nowPlaying.artist, style: PandoosTypography.bodyLarge.copyWith(color: Colors.white70), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 16),
                        NeonButton(
                          label: 'Listen Now',
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
                          width: 140,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Floating Album Art
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: nowPlaying.albumArt,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.05, end: 0);
      },
      loading: () => const SizedBox(height: 180, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => _buildFallbackBanner(),
    );
  }

  Widget _buildFallbackBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [PandoosColors.background, Color(0xFF2A1542)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: GlassCard(
        borderRadius: 24,
        blur: 16,
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: PandoosColors.primary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('FEATURED', style: PandoosTypography.labelSmall.copyWith(
                      color: Colors.white,
                    )),
                  ),
                  const SizedBox(height: 12),
                  Text('Your Daily Mix', style: PandoosTypography.h1.copyWith(fontSize: 22)),
                  const SizedBox(height: 4),
                  Text('32 songs curated just for you',
                      style: PandoosTypography.bodyLarge.copyWith(color: Colors.white70)),
                  const SizedBox(height: 16),
                  NeonButton(
                    label: 'Play All',
                    onPressed: () {},
                    width: 120,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [PandoosColors.primary, PandoosColors.pink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(
                  color: PandoosColors.primary.withValues(alpha: 0.5),
                  blurRadius: 30, offset: const Offset(0, 10),
                )],
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 50),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.05, end: 0);
  }
}
