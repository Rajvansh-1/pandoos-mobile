import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/audio/audio_service_provider.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import 'library_notifier.dart';

class LikedSongsScreen extends ConsumerWidget {
  const LikedSongsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryState = ref.watch(libraryNotifierProvider);

    return Scaffold(
      backgroundColor: PandoosColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Liked Songs', style: PandoosTypography.h2),
        centerTitle: true,
      ),
      body: libraryState.when(
        data: (tracks) {
          if (tracks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border_rounded, size: 64, color: PandoosColors.textMuted),
                  const SizedBox(height: 16),
                  Text('No liked songs yet', style: PandoosTypography.bodyLarge),
                  const SizedBox(height: 8),
                  Text('Songs you like will appear here.', style: PandoosTypography.bodyMedium),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: tracks.length,
            padding: const EdgeInsets.only(bottom: 120),
            itemBuilder: (context, i) {
              final track = tracks[i];
              final durStr = '${track.duration ~/ 60}:${(track.duration % 60).toString().padLeft(2, '0')}';

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: track.albumArt,
                    width: 56, height: 56, fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      color: PandoosColors.surfaceHigh,
                      child: const Icon(Icons.music_note_rounded, color: PandoosColors.textMuted),
                    ),
                  ),
                ),
                title: Text(track.title, style: PandoosTypography.labelLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(track.artist, style: PandoosTypography.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(durStr, style: PandoosTypography.bodySmall),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.favorite_rounded, color: PandoosColors.primary, size: 24),
                      onPressed: () {
                        ref.read(libraryNotifierProvider.notifier).unlikeTrack(track.videoId);
                      },
                    ),
                  ],
                ),
                onTap: () {
                  ref.read(audioHandlerProvider).playTrack(track);
                },
              ).animate(delay: (i * 40).ms).fadeIn(duration: 300.ms);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: PandoosColors.primary)),
        error: (e, _) => Center(child: Text('Error: $e', style: PandoosTypography.bodyMedium)),
      ),
    );
  }
}
