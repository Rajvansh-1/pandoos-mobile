import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:palette_generator/palette_generator.dart';
import 'dart:ui' as ui;

import '../../../core/audio/audio_service_provider.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../../core/models/track.dart';
import '../../library/data/library_repository.dart';
import '../../download/data/download_manager.dart';
import 'queue_sheet.dart';
import 'panda_player_view.dart';
import 'vinyl_player_view.dart';

class NowPlayingScreen extends ConsumerStatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  ConsumerState<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends ConsumerState<NowPlayingScreen> {
  bool _isLiked = false;
  bool _showPanda = false; // Toggle state: false = Vinyl, true = Panda
  Color _dominantColor = PandoosColors.primary;
  String? _lastArtUri;

  Future<void> _updatePalette(String? artUri) async {
    if (artUri == null || artUri == _lastArtUri) return;
    _lastArtUri = artUri;
    
    try {
      final palette = await PaletteGenerator.fromImageProvider(
        NetworkImage(artUri),
        maximumColorCount: 10,
      );
      if (mounted && palette.dominantColor != null) {
        setState(() {
          _dominantColor = palette.dominantColor!.color;
        });
      }
    } catch (e) {
      debugPrint('Failed to generate palette: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioHandler = ref.watch(audioHandlerProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
        builder: (context, mediaSnapshot) {
          final mediaItem = mediaSnapshot.data;
          
          if (mediaItem?.artUri?.toString() != null) {
            _updatePalette(mediaItem!.artUri!.toString());
          }
          
          return StreamBuilder<PlaybackState>(
            stream: audioHandler.playbackState,
            builder: (context, playbackSnapshot) {
              final playbackState = playbackSnapshot.data;
              final isPlaying = playbackState?.playing ?? false;
              final position = playbackState?.updatePosition ?? Duration.zero;
              final duration = mediaItem?.duration ?? Duration.zero;
              
              double progress = 0.0;
              if (duration.inMilliseconds > 0) {
                progress = position.inMilliseconds / duration.inMilliseconds;
              }

              return Stack(
                children: [
                  // 1. Solid Dark Base
                  Container(color: const Color(0xFF0F0B15)),

                  // 2. Dynamic Radial Glow from Album Art
                  AnimatedPositioned(
                    duration: const Duration(seconds: 1),
                    top: -150,
                    left: -100,
                    right: -100,
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      height: 600,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _dominantColor.withValues(alpha: 0.35),
                            blurRadius: 150,
                            spreadRadius: 80,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 3. Glass Overlay
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.1),
                      ),
                    ),
                  ),

                  SafeArea(
                    child: Column(
                      children: [
                        _buildTopBar(context),
                        const SizedBox(height: 30),
                        
                        // Dual View System
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          switchInCurve: Curves.easeOutBack,
                          switchOutCurve: Curves.easeInBack,
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: animation,
                                child: child,
                              ),
                            );
                          },
                          child: _showPanda 
                              ? const PandaPlayerView(key: ValueKey('panda'))
                              : const VinylPlayerView(key: ValueKey('vinyl')),
                        ),
                        
                        const Spacer(),
                        _buildTrackInfo(mediaItem),
                        const SizedBox(height: 30),
                        _buildSeekBar(audioHandler, position, duration, progress),
                        const SizedBox(height: 20),
                        _buildControls(audioHandler, isPlaying),
                        const SizedBox(height: 40),
                        _buildBottomActions(context),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          // Down button
          GestureDetector(
            onTap: () => context.pop(),
            child: GlassContainer.clearGlass(
              height: 44, width: 44,
              borderRadius: BorderRadius.circular(14),
              blur: 20,
              borderWidth: 1,
              borderColor: Colors.white.withValues(alpha: 0.1),
              child: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 28),
            ),
          ),
          const Spacer(),
          // Title
          Column(
            children: [
              Text('NOW PLAYING', style: PandoosTypography.labelSmall.copyWith(letterSpacing: 1.2)),
              const SizedBox(height: 2),
              Text('Pandoos Radio', style: PandoosTypography.caption.copyWith(color: Colors.white)),
            ],
          ),
          const Spacer(),
          // Dual View Toggle (🐼 / 💿)
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() => _showPanda = !_showPanda);
            },
            child: GlassContainer.clearGlass(
              height: 44, width: 68,
              borderRadius: BorderRadius.circular(14),
              blur: 20,
              borderWidth: 1,
              borderColor: Colors.white.withValues(alpha: 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('💿', style: TextStyle(fontSize: 16, color: _showPanda ? Colors.white38 : Colors.white)),
                  Text('🐼', style: TextStyle(fontSize: 16, color: !_showPanda ? Colors.white38 : Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackInfo(MediaItem? mediaItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mediaItem?.title ?? 'No Track Selected',
                    style: PandoosTypography.display2.copyWith(fontSize: 24),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text(mediaItem?.artist ?? 'Search to play something',
                    style: PandoosTypography.bodyLarge.copyWith(color: PandoosColors.textSecondary)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              setState(() => _isLiked = !_isLiked);
            },
            child: GlassContainer.clearGlass(
              height: 48, width: 48,
              borderRadius: BorderRadius.circular(24),
              blur: 20,
              borderWidth: 1,
              borderColor: Colors.white.withValues(alpha: 0.1),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  key: ValueKey(_isLiked),
                  color: _isLiked ? PandoosColors.pink : Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeekBar(dynamic audioHandler, Duration position, Duration duration, double progress) {
    String formatDuration(Duration d) {
      final minutes = d.inMinutes;
      final seconds = d.inSeconds % 60;
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
              thumbColor: Colors.white,
            ),
            child: Slider(
              value: progress.clamp(0.0, 1.0),
              onChanged: (v) {
                final newPosition = Duration(milliseconds: (v * duration.inMilliseconds).round());
                audioHandler.seek(newPosition);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatDuration(position), style: PandoosTypography.caption),
                Text(formatDuration(duration), style: PandoosTypography.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(dynamic audioHandler, bool isPlaying) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.shuffle_rounded),
            color: Colors.white.withValues(alpha: 0.5),
            iconSize: 26,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.skip_previous_rounded),
            color: Colors.white,
            iconSize: 42,
            onPressed: () => audioHandler.skipToPrevious(),
          ),

          // Play/pause main neon button
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              if (isPlaying) {
                audioHandler.pause();
              } else {
                audioHandler.play();
              }
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [_dominantColor, PandoosColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _dominantColor.withValues(alpha: 0.5),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  key: ValueKey(isPlaying),
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.skip_next_rounded),
            color: Colors.white,
            iconSize: 42,
            onPressed: () => audioHandler.skipToNext(),
          ),
          IconButton(
            icon: const Icon(Icons.repeat_rounded),
            color: Colors.white.withValues(alpha: 0.5),
            iconSize: 26,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            color: Colors.white.withValues(alpha: 0.6),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.lyrics_outlined),
            color: Colors.white.withValues(alpha: 0.6),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.queue_music_rounded),
            color: Colors.white.withValues(alpha: 0.6),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const QueueSheet(),
              );
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                icon: const Icon(Icons.download_outlined),
                color: Colors.white.withValues(alpha: 0.6),
                onPressed: () async {
                  // Download logic
                },
              );
            }
          ),
        ],
      ),
    );
  }
}
