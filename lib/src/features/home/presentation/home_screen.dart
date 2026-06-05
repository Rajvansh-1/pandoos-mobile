import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/audio/audio_service_provider.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../../core/widgets/glass_card.dart';
import 'home_notifier.dart';
import 'continue_listening_banner.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: PandoosColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGreeting(),
                  const SizedBox(height: 24),
                  const ContinueListeningBanner(),
                  const SizedBox(height: 28),
                  _buildSectionHeader('Recently Played'),
                  const SizedBox(height: 14),
                  _buildHorizontalCards(),
                  const SizedBox(height: 28),
                  _buildSectionHeader('Trending Now'),
                  const SizedBox(height: 14),
                  _buildTrackList(context, ref),
                  const SizedBox(height: 120), // bottom padding for mini player
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: PandoosColors.background,
      title: Row(
        children: [
          // Logo/brand
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [PandoosColors.primary, PandoosColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.music_note_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Text('Pandoos', style: PandoosTypography.h1),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          color: PandoosColors.textSecondary,
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: PandoosColors.primaryGlow,
            child: const Icon(Icons.person_outline_rounded,
                color: PandoosColors.primary, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning 🌅'
        : hour < 17
            ? 'Good afternoon ☀️'
            : 'Good evening 🌙';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(greeting, style: PandoosTypography.caption),
        const SizedBox(height: 4),
        Text('What are you\nlistening to?',
            style: PandoosTypography.display2),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  // _buildFeaturedBanner is replaced by ContinueListeningBanner in build()

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: PandoosTypography.h2),
        Text('See all', style: PandoosTypography.caption.copyWith(
          color: PandoosColors.primary,
        )),
      ],
    );
  }

  Widget _buildHorizontalCards() {
    final items = [
      ('Lo-fi Beats', Icons.coffee_rounded, PandoosColors.accent),
      ('Hip Hop Hits', Icons.whatshot_rounded, PandoosColors.pink),
      ('Workout Mode', Icons.fitness_center_rounded, PandoosColors.primary),
      ('Chill Vibes', Icons.waves_rounded, Color(0xFF56ADE3)),
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final (label, icon, color) = items[i];
          return GlassCard(
            width: 100,
            height: 110,
            borderRadius: 16,
            padding: const EdgeInsets.all(12),
            fillColor: color.withValues(alpha: 0.12),
            borderColor: color.withValues(alpha: 0.25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(height: 8),
                Text(label,
                  style: PandoosTypography.bodySmall.copyWith(color: PandoosColors.textPrimary),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          ).animate(delay: (i * 60).ms).fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0);
        },
      ),
    );
  }

  Widget _buildTrackList(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeNotifierProvider);

    return homeState.when(
      data: (tracks) {
        if (tracks.isEmpty) {
          return const Center(child: Text('No trending tracks found'));
        }
        return Column(
          children: List.generate(tracks.length, (i) {
            final track = tracks[i];
            final durStr = '${track.duration ~/ 60}:${(track.duration % 60).toString().padLeft(2, '0')}';
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: track.albumArt,
                    width: 48, height: 48, fit: BoxFit.cover,
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
                    const SizedBox(width: 8),
                    const Icon(Icons.more_vert_rounded,
                        color: PandoosColors.textMuted, size: 18),
                  ],
                ),
                onTap: () {
                  ref.read(audioHandlerProvider).playTrack(track);
                },
              ).animate(delay: (i * 50).ms).fadeIn(duration: 350.ms),
            );
          }),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: PandoosColors.primary)),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

