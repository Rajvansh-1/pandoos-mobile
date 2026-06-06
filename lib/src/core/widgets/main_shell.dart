import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:audio_service/audio_service.dart';
import '../audio/audio_service_provider.dart';
import '../router/route_names.dart';
import '../theme/pandoos_colors.dart';
import 'mini_player.dart';
import '../../features/player/data/progress_sync_service.dart';
import 'dart:ui' as ui;

class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  int _locationToIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith(RouteNames.search)) return 1;
    if (location.startsWith(RouteNames.library)) return 2;
    // We'll map index 3 to profile later
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(progressSyncServiceProvider);
    final audioHandler = ref.watch(audioHandlerProvider);
    final currentIndex = _locationToIndex(context);

    return Scaffold(
      extendBody: true, // Crucial for floating nav
      backgroundColor: PandoosColors.background,
      body: child,
      bottomNavigationBar: StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
        builder: (context, mediaSnapshot) {
          final mediaItem = mediaSnapshot.data;
          final bool hasPlayer = mediaItem != null;

          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (hasPlayer)
                StreamBuilder<PlaybackState>(
                  stream: audioHandler.playbackState,
                  builder: (context, playbackSnapshot) {
                    final playbackState = playbackSnapshot.data;
                    final isPlaying = playbackState?.playing ?? false;
                    final position = playbackState?.updatePosition ?? Duration.zero;
                    final duration = mediaItem.duration ?? const Duration(minutes: 3);
                    double progress = 0;
                    if (duration.inMilliseconds > 0) {
                      progress = position.inMilliseconds / duration.inMilliseconds;
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: MiniPlayer(
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
                      ),
                    );
                  },
                ),
              // Floating Frosted Nav
              ClipRect(
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                    decoration: BoxDecoration(
                      color: PandoosColors.surface.withValues(alpha: 0.9),
                      border: Border(
                        top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                      ),
                    ),
                    child: SizedBox(
                      height: 64,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _NavItem(
                            icon: Icons.home_rounded,
                            label: 'Home',
                            isActive: currentIndex == 0,
                            onTap: () => context.go(RouteNames.home),
                          ),
                          _NavItem(
                            icon: Icons.search_rounded,
                            label: 'Search',
                            isActive: currentIndex == 1,
                            onTap: () => context.go(RouteNames.search),
                          ),
                          _NavItem(
                            icon: Icons.library_music_rounded,
                            label: 'Library',
                            isActive: currentIndex == 2,
                            onTap: () => context.go(RouteNames.library),
                          ),
                          _ProfileNavItem(
                            isActive: currentIndex == 3,
                            onTap: () {
                              // context.go(RouteNames.profile);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? PandoosColors.primary : Colors.white54,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isActive ? PandoosColors.primary : Colors.white54,
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 4),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: PandoosColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class _ProfileNavItem extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _ProfileNavItem({required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [PandoosColors.primary, PandoosColors.pink],
                ),
                border: Border.all(
                  color: isActive ? Colors.white : Colors.transparent,
                  width: 2,
                ),
              ),
              child: const Icon(Icons.person, size: 16, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              'Profile',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isActive ? PandoosColors.primary : Colors.white54,
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 4),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: PandoosColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
