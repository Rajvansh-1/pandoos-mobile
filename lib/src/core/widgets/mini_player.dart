import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../theme/pandoos_colors.dart';
import '../theme/pandoos_typography.dart';
import '../router/route_names.dart';

/// Persistent mini player shown at the bottom above the nav bar
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({
    super.key,
    required this.title,
    required this.artist,
    required this.albumArt,
    required this.isPlaying,
    required this.onPlayPause,
    this.progress = 0.0,
  });

  final String title;
  final String artist;
  final String albumArt;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(RouteNames.nowPlaying),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 68,
            decoration: const BoxDecoration(
              color: PandoosColors.glassLight,
              border: Border(
                top: BorderSide(color: PandoosColors.glassBorder, width: 0.5),
              ),
            ),
            child: Stack(
              children: [
                // Progress bar at top
                Positioned(
                  top: 0, left: 0, right: 0,
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation(PandoosColors.primary),
                    minHeight: 2,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      // Album art
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: albumArt,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          placeholder: (_, _) => Container(
                            color: PandoosColors.surfaceHigh,
                            child: const Icon(
                              Icons.music_note_rounded,
                              color: PandoosColors.textMuted, size: 20,
                            ),
                          ),
                          errorWidget: (_, _, _) => Container(
                            color: PandoosColors.surfaceHigh,
                            child: const Icon(
                              Icons.music_note_rounded,
                              color: PandoosColors.textMuted, size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Title + artist
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                              style: PandoosTypography.labelLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(artist,
                              style: PandoosTypography.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Play/pause
                      GestureDetector(
                        onTap: onPlayPause,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: PandoosColors.primary.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                            color: PandoosColors.primary,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Skip next
                      IconButton(
                        icon: const Icon(Icons.skip_next_rounded, size: 26),
                        color: PandoosColors.textSecondary,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

