import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import '../../../core/audio/audio_service_provider.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../lyrics/presentation/lyrics_notifier.dart';

class LyricsOverlay extends ConsumerWidget {
  const LyricsOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lyricsState = ref.watch(lyricsNotifierProvider);
    final audioHandler = ref.watch(audioHandlerProvider);

    return lyricsState.when(
      data: (lines) {
        if (lines.isEmpty) return const SizedBox.shrink();

        return Positioned(
          bottom: 120, // Sit just above the player controls
          left: 24,
          right: 24,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                alignment: Alignment.center,
                child: StreamBuilder<PlaybackState>(
                  stream: audioHandler.playbackState,
                  builder: (context, snapshot) {
                    final position = snapshot.data?.updatePosition ?? Duration.zero;

                    // Find current lyric index
                    int currentIndex = lines.lastIndexWhere((line) => line.time <= position);
                    if (currentIndex == -1) currentIndex = 0;

                    final text = lines.isNotEmpty ? lines[currentIndex].words : '';

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        text,
                        key: ValueKey<int>(currentIndex),
                        style: PandoosTypography.h3.copyWith(color: Colors.white, height: 1.2),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
