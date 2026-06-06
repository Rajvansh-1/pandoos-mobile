import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../domain/get_artist_usecase.dart';
import '../domain/artist.dart';
import '../../../core/models/track.dart';
import '../../../core/audio/audio_service_provider.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../../core/widgets/shimmer_loader.dart';

final _artistPageProvider = FutureProvider.family<(Artist, List<Track>), String>((ref, browseId) async {
  final useCase = ref.watch(getArtistUseCaseProvider);
  final artist = await useCase.call(browseId);
  final tracks = await useCase.getTopTracks(browseId);
  return (artist, tracks);
});

class ArtistScreen extends ConsumerWidget {
  final String browseId;
  const ArtistScreen({super.key, required this.browseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artistAsync = ref.watch(_artistPageProvider(browseId));
    final audioHandler = ref.watch(audioHandlerProvider);

    return Scaffold(
      backgroundColor: PandoosColors.background,
      body: artistAsync.when(
        loading: () => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              backgroundColor: PandoosColors.background,
              leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
              flexibleSpace: const FlexibleSpaceBar(
                background: ShimmerLoader(width: double.infinity, height: 300, borderRadius: 0),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  List.generate(6, (_) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(children: [
                      const ShimmerLoader(width: 56, height: 56, borderRadius: 8),
                      const SizedBox(width: 16),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        ShimmerLoader(width: MediaQuery.of(context).size.width * 0.5, height: 14),
                        const SizedBox(height: 8),
                        ShimmerLoader(width: MediaQuery.of(context).size.width * 0.3, height: 12),
                      ]),
                    ]),
                  )),
                ),
              ),
            ),
          ],
        ),
        error: (e, _) => Center(child: Text('Failed to load artist: $e')),
        data: (record) {
          final artist = record.$1;
          final tracks = record.$2;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: PandoosColors.background,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(artist.name, style: PandoosTypography.h3),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.topCenter,
                            radius: 1.5,
                            colors: [PandoosColors.primary.withValues(alpha: 0.4), PandoosColors.background],
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: PandoosColors.primary.withValues(alpha: 0.5), width: 2),
                                boxShadow: [BoxShadow(color: PandoosColors.primary.withValues(alpha: 0.3), blurRadius: 30, spreadRadius: 5)],
                              ),
                              child: ClipOval(
                                child: Container(
                                  color: PandoosColors.surfaceHigh,
                                  child: const Icon(Icons.person_rounded, size: 60, color: Colors.white54),
                                ),
                              ),
                            ),
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
                      Expanded(child: Text('Top Tracks', style: PandoosTypography.h2)),
                      if (tracks.isNotEmpty)
                        TextButton.icon(
                          icon: const Icon(Icons.play_arrow_rounded, color: PandoosColors.primary),
                          label: Text('Play All', style: PandoosTypography.labelLarge.copyWith(color: PandoosColors.primary)),
                          onPressed: () => audioHandler.playTrack(tracks.first),
                        ),
                    ],
                  ),
                ),
              ),

              if (tracks.isEmpty)
                SliverFillRemaining(
                  child: Center(child: Text('No tracks found', style: PandoosTypography.bodyLarge.copyWith(color: Colors.white38))),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final track = tracks[i];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: track.albumArt,
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(width: 52, height: 52, color: PandoosColors.surfaceHigh,
                              child: const Icon(Icons.music_note, color: Colors.white38)),
                          ),
                        ),
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
