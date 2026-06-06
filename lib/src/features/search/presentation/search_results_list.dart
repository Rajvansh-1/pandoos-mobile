import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../domain/search_result.dart'; // We actually need track.dart, wait the model is Track.
import '../../../core/models/track.dart';
import 'search_notifier.dart';

class SearchResultsList extends ConsumerWidget {
  const SearchResultsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchNotifierProvider);

    return searchState.when(
      data: (tracks) {
        if (tracks.isEmpty) {
          return const Center(child: Text('No results found.', style: TextStyle(color: Colors.white54)));
        }
        
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 120, top: 16),
          itemCount: tracks.length,
          itemBuilder: (context, index) {
            final track = tracks[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: PandoosColors.surfaceHigh.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: track.albumArt,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        width: 56,
                        height: 56,
                        color: PandoosColors.surfaceHigh,
                        child: const Icon(Icons.music_note, color: Colors.white54),
                      ),
                    ),
                  ),
                  title: Text(track.title, style: PandoosTypography.bodyLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(track.artist, style: PandoosTypography.bodyMedium.copyWith(color: Colors.white54), maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: const Icon(Icons.play_circle_fill_rounded, color: PandoosColors.primary, size: 36),
                    onPressed: () {
                      // In production, this adds to queue and plays via audioHandler
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: PandoosColors.primary)),
      error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: PandoosColors.error))),
    );
  }
}
