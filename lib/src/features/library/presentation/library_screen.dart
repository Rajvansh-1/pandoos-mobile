import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/neon_button.dart';
import '../../download/data/download_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/audio/audio_service_provider.dart';
import '../../../core/models/track.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PandoosColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (_, _) => [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: PandoosColors.background,
            title: Text('Your Library', style: PandoosTypography.h1),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_rounded),
                color: PandoosColors.primary,
                onPressed: () {},
              ),
            ],
            bottom: TabBar(
              controller: _tabs,
              labelStyle: PandoosTypography.labelLarge,
              unselectedLabelStyle: PandoosTypography.bodyMedium,
              labelColor: PandoosColors.primary,
              unselectedLabelColor: PandoosColors.textMuted,
              indicatorColor: PandoosColors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Tab(text: 'Liked Songs'),
                Tab(text: 'Playlists'),
                Tab(text: 'Downloads'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabs,
          children: [
            _buildLikedSongs(),
            _buildPlaylists(),
            _buildDownloads(),
          ],
        ),
      ),
    );
  }

  Widget _buildLikedSongs() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Liked songs header card
        GlassCard(
          borderRadius: 16,
          padding: const EdgeInsets.all(20),
          fillColor: PandoosColors.pinkGlow,
          borderColor: PandoosColors.pink.withValues(alpha: 0.3),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [PandoosColors.pink, PandoosColors.primary],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.favorite_rounded,
                    color: Colors.white, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Liked Songs', style: PandoosTypography.h2),
                    const SizedBox(height: 4),
                    Text('0 songs', style: PandoosTypography.caption),
                  ],
                ),
              ),
              NeonButton(
                label: 'Play',
                icon: Icons.play_arrow_rounded,
                glowColor: PandoosColors.pink,
                onPressed: () {},
                width: 80,
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms),

        const SizedBox(height: 24),
        Center(
          child: Column(
            children: [
              const Icon(Icons.favorite_border_rounded,
                  color: PandoosColors.textMuted, size: 64),
              const SizedBox(height: 16),
              Text('No liked songs yet',
                  style: PandoosTypography.h3.copyWith(
                      color: PandoosColors.textMuted)),
              const SizedBox(height: 8),
              Text('Songs you like will appear here.',
                  style: PandoosTypography.bodyMedium),
            ],
          ).animate(delay: 200.ms).fadeIn(duration: 500.ms),
        ),
      ],
    );
  }

  Widget _buildPlaylists() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.queue_music_rounded,
              color: PandoosColors.textMuted, size: 64),
          const SizedBox(height: 16),
          Text('No playlists yet',
              style: PandoosTypography.h3.copyWith(
                  color: PandoosColors.textMuted)),
          const SizedBox(height: 8),
          Text('Create your first playlist!', style: PandoosTypography.bodyMedium),
          const SizedBox(height: 20),
          NeonButton(
            label: 'Create Playlist',
            icon: Icons.add_rounded,
            onPressed: () {},
          ),
        ],
      ).animate().fadeIn(duration: 500.ms),
    );
  }

  Widget _buildDownloads() {
    final downloadRepo = ref.watch(downloadRepositoryProvider);
    final downloads = downloadRepo.getAllTracks();

    if (downloads.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.download_rounded,
                color: PandoosColors.textMuted, size: 64),
            const SizedBox(height: 16),
            Text('No downloads yet',
                style: PandoosTypography.h3.copyWith(
                    color: PandoosColors.textMuted)),
            const SizedBox(height: 8),
            Text('Download songs to listen offline.',
                style: PandoosTypography.bodyMedium),
          ],
        ).animate().fadeIn(duration: 500.ms),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: downloads.length,
      itemBuilder: (context, index) {
        final track = downloads[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: track.albumArt,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(track.title, style: PandoosTypography.h3),
          subtitle: Text(track.artist, style: PandoosTypography.bodyMedium),
          trailing: const Icon(Icons.download_done, color: PandoosColors.primary),
          onTap: () {
            final playTrack = Track(
              id: track.videoId,
              videoId: track.videoId,
              title: track.title,
              artist: track.artist,
              albumArt: track.albumArt,
              duration: 0,
            );
            ref.read(audioHandlerProvider).playTrack(playTrack);
          },
        );
      },
    );
  }
}

