import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:audio_service/audio_service.dart';
import '../../../core/audio/audio_service_provider.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import 'lyrics_notifier.dart';

class LyricsScreen extends ConsumerStatefulWidget {
  const LyricsScreen({super.key});

  @override
  ConsumerState<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends ConsumerState<LyricsScreen> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ScrollOffsetController _scrollOffsetController = ScrollOffsetController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final lyricsState = ref.watch(lyricsNotifierProvider);
    final audioHandler = ref.watch(audioHandlerProvider);

    return Scaffold(
      backgroundColor: PandoosColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Lyrics', style: PandoosTypography.h3),
        centerTitle: true,
      ),
      body: lyricsState.when(
        data: (lines) {
          if (lines.isEmpty) {
            return Center(
              child: Text(
                'No lyrics found for this song.',
                style: PandoosTypography.bodyLarge.copyWith(color: Colors.white54),
              ),
            );
          }

          return StreamBuilder<PlaybackState>(
            stream: audioHandler.playbackState,
            builder: (context, snapshot) {
              final position = snapshot.data?.updatePosition ?? Duration.zero;

              // Find current lyric index based on position
              int newIndex = lines.lastIndexWhere((line) => line.time <= position);
              if (newIndex == -1) newIndex = 0;

              if (newIndex != _currentIndex && _itemScrollController.isAttached) {
                _currentIndex = newIndex;
                _itemScrollController.scrollTo(
                  index: _currentIndex,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  alignment: 0.4, // Center slightly above middle
                );
              }

              return ScrollablePositionedList.builder(
                itemCount: lines.length,
                itemScrollController: _itemScrollController,
                scrollOffsetController: _scrollOffsetController,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
                itemBuilder: (context, index) {
                  final line = lines[index];
                  final isActive = index == _currentIndex;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: isActive
                          ? PandoosTypography.display2.copyWith(color: Colors.white, fontSize: 32)
                          : PandoosTypography.h2.copyWith(color: Colors.white24, fontSize: 24),
                      child: Text(line.words),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: PandoosColors.primary)),
        error: (e, _) => Center(child: Text('Error loading lyrics: $e', style: PandoosTypography.bodyMedium)),
      ),
    );
  }
}
