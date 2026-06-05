import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  double _progress = 0.35;
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
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
                _buildAlbumArt(),
                const SizedBox(height: 28),
                _buildTrackInfo(),
                const SizedBox(height: 28),
                _buildSeekBar(),
                const SizedBox(height: 20),
                _buildControls(),
                const SizedBox(height: 20),
                _buildBottomActions(),
              ],
            ),
          ),
        ],
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

  Widget _buildAlbumArt() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
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
            child: const Center(
              child: Icon(Icons.music_note_rounded,
                  color: Colors.white54, size: 80),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrackInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('No Song Playing',
                    style: PandoosTypography.h1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('Select a song from Search',
                    style: PandoosTypography.bodyMedium),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              setState(() => _isLiked = !_isLiked);
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

  Widget _buildSeekBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Slider(
            value: _progress,
            onChanged: (v) => setState(() => _progress = v),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('1:12', style: PandoosTypography.bodySmall),
                Text('3:24', style: PandoosTypography.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
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
            onPressed: () {},
          ),

          // Play/pause main button
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() => _isPlaying = !_isPlaying);
            },
            child: Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [PandoosColors.primary, PandoosColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x809C6ADE),
                    blurRadius: 24, offset: Offset(0, 8),
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  key: ValueKey(_isPlaying),
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
            onPressed: () {},
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
            onPressed: () {},
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

