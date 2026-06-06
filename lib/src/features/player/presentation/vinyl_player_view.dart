import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math' as math;
import '../../../core/audio/audio_service_provider.dart';
import '../../../core/theme/pandoos_colors.dart';

class VinylPlayerView extends ConsumerStatefulWidget {
  const VinylPlayerView({Key? key}) : super(key: key);

  @override
  ConsumerState<VinylPlayerView> createState() => _VinylPlayerViewState();
}

class _VinylPlayerViewState extends ConsumerState<VinylPlayerView>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    // Spin the record: 1 full rotation every 8 seconds
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioHandler = ref.watch(audioHandlerProvider);

    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, mediaSnapshot) {
        final mediaItem = mediaSnapshot.data;
        
        return StreamBuilder<PlaybackState>(
          stream: audioHandler.playbackState,
          builder: (context, playbackSnapshot) {
            final isPlaying = playbackSnapshot.data?.playing ?? false;
            
            if (isPlaying) {
              _rotationController.repeat();
            } else {
              _rotationController.stop();
            }

            return SizedBox(
              width: double.infinity,
              height: 350,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Vinyl Glow
                  Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.6),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                  ),

                  // The Vinyl Record (Spinning)
                  AnimatedBuilder(
                    animation: _rotationController,
                    builder: (_, child) {
                      return Transform.rotate(
                        angle: _rotationController.value * 2 * math.pi,
                        child: child,
                      );
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Black Vinyl Disc
                        Container(
                          width: 300,
                          height: 300,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF111111),
                          ),
                        ),
                        // Vinyl Grooves
                        for (int i = 0; i < 5; i++)
                          Container(
                            width: 300 - (i * 24.0),
                            height: 300 - (i * 24.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.03),
                                width: 1,
                              ),
                            ),
                          ),
                        // Inner Label (Album Art)
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 4),
                          ),
                          child: ClipOval(
                            child: mediaItem?.artUri != null
                                ? CachedNetworkImage(
                                    imageUrl: mediaItem!.artUri!.toString(),
                                    fit: BoxFit.cover,
                                    errorWidget: (_, __, ___) => _buildFallbackArt(),
                                  )
                                : _buildFallbackArt(),
                          ),
                        ),
                        // Center Hole
                        Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tonearm Pivot
                  Positioned(
                    top: 10,
                    right: 30,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[800],
                        border: Border.all(color: Colors.grey[600]!, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tonearm
                  Positioned(
                    top: 30,
                    right: 50,
                    child: AnimatedRotation(
                      turns: isPlaying ? 0.08 : 0.0, // Rotates onto the record when playing
                      duration: const Duration(milliseconds: 600),
                      alignment: Alignment.topRight,
                      curve: Curves.easeOutBack,
                      child: Container(
                        width: 8,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 10,
                              offset: const Offset(4, 4),
                            ),
                          ],
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 24,
                            height: 40,
                            margin: const EdgeInsets.only(bottom: 0),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFallbackArt() {
    return Container(
      color: PandoosColors.primary,
      child: const Center(
        child: Icon(Icons.music_note_rounded, color: Colors.white54, size: 40),
      ),
    );
  }
}
