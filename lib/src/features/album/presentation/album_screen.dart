import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../data/album_repository.dart';
import '../domain/album.dart';
import '../../../core/models/track.dart';
import '../../../core/audio/audio_service_provider.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../../core/widgets/neon_button.dart';
import '../../../core/widgets/shimmer_loader.dart';

final _albumPageProvider = FutureProvider.family<(Album, List<Track>), String>((ref, browseId) async {
  return ref.watch(albumRepositoryProvider).getAlbumPage(browseId);
});

class AlbumScreen extends ConsumerWidget {
  final String browseId;
  const AlbumScreen({super.key, required this.browseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumAsync = ref.watch(_albumPageProvider(browseId));
    final audioHandler = ref.watch(audioHandlerProvider);

    return Scaffold(
      backgroundColor: PandoosColors.background,
      body: albumAsync.when(
        loading: () => CustomScrollView(slivers: [
          SliverAppBar(
            expandedHeight: 320,
            backgroundColor: PandoosColors.background,
            leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
            flexibleSpace: const FlexibleSpaceBar(
              background: ShimmerLoader(width: double.infinity, height: 320, borderRadius: 0),
            ),
          ),
        ]),
        error: (e, _) => Center(child: Text('Failed to load album: $e')),
        data: (record) {
          final album = record.$1;
          final tracks = record.$2;
          final coverArt = tracks.isNotEmpty ? tracks.first.albumArt : '';
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                backgroundColor: PandoosColors.background,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (coverArt.isNotEmpty)
                        CachedNetworkImage(imageUrl: coverArt, fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(color: PandoosColors.surfaceHigh)),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, PandoosColors.background],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.4, 1.0],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 24,
                        right: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(album.title, style: PandoosTypography.display2, maxLines: 2),
                            const SizedBox(height: 4),
                            Text('${tracks.length} songs', style: PandoosTypography.caption.copyWith(color: Colors.white54)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      if (tracks.isNotEmpty) NeonButton(
                        label: 'Play All',
                        icon: Icons.play_arrow_rounded,
                        onPressed: () => audioHandler.playTrack(tracks.first),
                        width: 140,
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.shuffle_rounded, color: Colors.white54, size: 28),
                        onPressed: () {
                          if (tracks.isNotEmpty) {
                            final shuffled = List<Track>.from(tracks)..shuffle();
                            audioHandler.playTrack(shuffled.first);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    final track = tracks[i];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                      leading: Text('${i + 1}', style: PandoosTypography.bodyMedium.copyWith(color: Colors.white38), textAlign: TextAlign.center),
                      title: Text(track.title, style: PandoosTypography.labelLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(track.artist, style: PandoosTypography.caption, maxLines: 1),
                      trailing: Text(
                        '${track.duration ~/ 60}:${(track.duration % 60).toString().padLeft(2, '0')}',
                        style: PandoosTypography.caption,
                      ),
                      onTap: () => audioHandler.playTrack(track),
                    );
                  },
                  childCount: tracks.length,
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          );
        },
      ),
    );
  }
}
