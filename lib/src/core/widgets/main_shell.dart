import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:audio_service/audio_service.dart';
import '../audio/audio_service_provider.dart';
import '../router/route_names.dart';
import '../theme/pandoos_colors.dart';
import 'mini_player.dart';

/// Persistent shell with bottom navigation + mini player slot
class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  int _locationToIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith(RouteNames.search))  return 1;
    if (location.startsWith(RouteNames.library)) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = _locationToIndex(context);
    final audioHandler = ref.watch(audioHandlerProvider);

    return Scaffold(
      body: child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<MediaItem?>(
            stream: audioHandler.mediaItem,
            builder: (context, mediaSnapshot) {
              final mediaItem = mediaSnapshot.data;
              if (mediaItem == null) return const SizedBox.shrink();

              return StreamBuilder<PlaybackState>(
                stream: audioHandler.playbackState,
                builder: (context, playbackSnapshot) {
                  final playbackState = playbackSnapshot.data;
                  final isPlaying = playbackState?.playing ?? false;
                  
                  // For progress we need to use a ticker or AudioService's position stream.
                  // For simplicity in the mini player, we'll just show 0 or an indeterminate.
                  // (Usually we use AudioPlayer.positionStream)
                  final position = playbackState?.updatePosition ?? Duration.zero;
                  final duration = mediaItem.duration ?? const Duration(minutes: 3);
                  double progress = 0;
                  if (duration.inMilliseconds > 0) {
                    progress = position.inMilliseconds / duration.inMilliseconds;
                  }

                  return MiniPlayer(
                    title: mediaItem.title,
                    artist: mediaItem.artist ?? 'Unknown Artist',
                    albumArt: mediaItem.artUri?.toString() ?? '',
                    isPlaying: isPlaying,
                    progress: progress,
                    onPlayPause: () {
                      if (isPlaying) {
                        audioHandler.pause();
                      } else {
                        audioHandler.play();
                      }
                    },
                  );
                },
              );
            },
          ),
          NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              switch (index) {
                case 0: context.go(RouteNames.home); break;
                case 1: context.go(RouteNames.search); break;
                case 2: context.go(RouteNames.library); break;
              }
            },
            backgroundColor: PandoosColors.surface,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.search_rounded),
                label: 'Search',
              ),
              NavigationDestination(
                icon: Icon(Icons.library_music_outlined),
                selectedIcon: Icon(Icons.library_music_rounded),
                label: 'Library',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
