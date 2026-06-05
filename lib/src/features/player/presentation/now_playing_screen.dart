import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/audio/audio_service_provider.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../../core/models/track.dart';
import '../../library/data/library_repository.dart';
import 'queue_sheet.dart';

class NowPlayingScreen extends ConsumerStatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  ConsumerState<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends ConsumerState<NowPlayingScreen>
    with SingleTickerProviderStateMixin {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    final audioHandler = ref.watch(audioHandlerProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
        builder: (context, mediaSnapshot) {
          final mediaItem = mediaSnapshot.data;
          
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
          // Blurred album art background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1A0B2E),
                    PandoosColors.background,
                  ],
                ),
              ),
            ),
          ),

          // Purple glow blob
          Positioned(
            top: -50, left: 0, right: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.0,
                  colors: [
                    PandoosColors.primary.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),
                const SizedBox(height: 20),
                _buildAlbumArt(mediaItem),
                const SizedBox(height: 28),
                _buildTrackInfo(mediaItem),
                const SizedBox(height: 28),
                _buildSeekBar(audioHandler, position, duration, progress),
                const SizedBox(height: 20),
                _buildControls(audioHandler, isPlaying),
                const SizedBox(height: 20),
                _buildBottomActions(),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: PandoosColors.glassLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PandoosColors.glassBorder),
              ),
              child: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: PandoosColors.textPrimary, size: 26),
            ),
          ),
          const Spacer(),
          Column(
            children: [
              Text('NOW PLAYING', style: PandoosTypography.labelSmall),
              Text('Daily Mix', style: PandoosTypography.caption),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: PandoosColors.glassLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PandoosColors.glassBorder),
              ),
              child: const Icon(Icons.more_horiz_rounded,
                  color: PandoosColors.textPrimary, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumArt(MediaItem? mediaItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [PandoosColors.primary, PandoosColors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: PandoosColors.primary.withValues(alpha: 0.5),
                blurRadius: 60,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: mediaItem?.artUri != null
                ? CachedNetworkImage(
                    imageUrl: mediaItem!.artUri!.toString(),
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => const Center(
                      child: Icon(Icons.music_note_rounded, color: Colors.white54, size: 80),
                    ),
                  )
                : const Center(
                    child: Icon(Icons.music_note_rounded, color: Colors.white54, size: 80),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrackInfo(MediaItem? mediaItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mediaItem?.title ?? 'No Song Playing',
                    style: PandoosTypography.h1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(mediaItem?.artist ?? 'Select a song from Search',
                    style: PandoosTypography.bodyMedium),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              setState(() => _isLiked = !_isLiked);
              if (mediaItem != null) {
                final track = Track(
                  id: mediaItem.id,
                  videoId: mediaItem.id,
                  title: mediaItem.title,
                  artist: mediaItem.artist ?? '',
                  albumArt: mediaItem.artUri?.toString() ?? '',
                  duration: mediaItem.duration?.inSeconds ?? 0,
                );
                if (_isLiked) {
                  ref.read(libraryRepositoryProvider).likeTrack(track);
                } else {
                  ref.read(libraryRepositoryProvider).unlikeTrack(track.videoId);
                }
              }
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                key: ValueKey(_isLiked),
                color: _isLiked ? PandoosColors.pink : PandoosColors.textMuted,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeekBar(dynamic audioHandler, Duration position, Duration duration, double progress) {
    String _formatDuration(Duration d) {
      final minutes = d.inMinutes;
      final seconds = d.inSeconds % 60;
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Slider(
            value: progress.clamp(0.0, 1.0),
            onChanged: (v) {
              final newPosition = Duration(milliseconds: (v * duration.inMilliseconds).round());
              audioHandler.seek(newPosition);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(position), style: PandoosTypography.bodySmall),
                Text(_formatDuration(duration), style: PandoosTypography.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(dynamic audioHandler, bool isPlaying) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.shuffle_rounded),
            color: PandoosColors.textMuted,
            iconSize: 24,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.skip_previous_rounded),
            color: PandoosColors.textPrimary,
            iconSize: 36,
            onPressed: () => audioHandler.skipToPrevious(),
          ),

          // Play/pause main button
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
              width: 68,
              height: 68,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [PandoosColors.primary, PandoosColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x809C6ADE),
                    blurRadius: 24, offset: Offset(0, 8),
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  key: ValueKey(isPlaying),
                  color: Colors.white,
                  size: 34,
                ),
              ),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.skip_next_rounded),
            color: PandoosColors.textPrimary,
            iconSize: 36,
            onPressed: () => audioHandler.skipToNext(),
          ),
          IconButton(
            icon: const Icon(Icons.repeat_rounded),
            color: PandoosColors.textMuted,
            iconSize: 24,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            color: PandoosColors.textMuted,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.lyrics_outlined),
            color: PandoosColors.textMuted,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.queue_music_rounded),
            color: PandoosColors.textMuted,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const QueueSheet(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined),
            color: PandoosColors.textMuted,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

