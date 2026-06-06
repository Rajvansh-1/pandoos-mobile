import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/audio/audio_service_provider.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/panda/panda_state.dart';
import '../../panda_mood/presentation/mood_notifier.dart';
import 'home_notifier.dart';
import 'continue_listening_banner.dart';
import 'mood_rail_widget.dart';
import 'dart:ui' as ui;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: PandoosColors.background,
      body: Stack(
        children: [
          // 1. Dynamic Web-App Style Background Blobs
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: PandoosColors.primary.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            top: 200,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: PandoosColors.pink.withValues(alpha: 0.1),
              ),
            ),
          ),
          // Blur the blobs
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
          ),

          // 2. Main Scroll Content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGreeting(),
                      const SizedBox(height: 24),
                      const MoodRailWidget(),
                      const SizedBox(height: 32),
                      const ContinueListeningBanner(),
                      const SizedBox(height: 12),
                      _buildSectionHeader('Explore Styles'),
                      const SizedBox(height: 16),
                      _buildHorizontalCards(),
                      const SizedBox(height: 36),
                      Consumer(builder: (context, ref, _) {
                        final mood = ref.watch(moodNotifierProvider).currentMood;
                        final title = mood == PandaMood.neutral ? 'Trending Now' : '${mood.name.toUpperCase()} Playlists';
                        return _buildSectionHeader(title);
                      }),
                      const SizedBox(height: 16),
                      _buildTrackList(context, ref),
                      const SizedBox(height: 140), // bottom padding for mini player
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [PandoosColors.primary, PandoosColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: PandoosColors.primary.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))
              ],
            ),
            child: Image.asset('assets/images/logo.png', width: 24, height: 24),
          ),
          const SizedBox(width: 12),
          Text('Pandoos', style: PandoosTypography.h1.copyWith(fontSize: 24)),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          color: Colors.white,
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          color: Colors.white,
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 24, left: 8),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(greeting, style: PandoosTypography.labelLarge.copyWith(color: PandoosColors.primary)),
        const SizedBox(height: 6),
        Text('What are you\nlistening to?',
            style: PandoosTypography.display1.copyWith(height: 1.1)),
      ],
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05, end: 0);
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: PandoosTypography.h1.copyWith(fontSize: 22)),
        Text('See all', style: PandoosTypography.labelLarge.copyWith(
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
      ('Chill Vibes', Icons.waves_rounded, const Color(0xFF56ADE3)),
    ];

    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (_, i) {
          final (label, icon, color) = items[i];
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
            },
            child: GlassCard(
              width: 110,
              height: 130,
              borderRadius: 20,
              padding: const EdgeInsets.all(16),
              fillColor: color.withValues(alpha: 0.1),
              borderColor: color.withValues(alpha: 0.2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const Spacer(),
                  Text(label,
                    style: PandoosTypography.labelLarge.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ],
              ),
            ).animate(delay: (i * 60).ms).fadeIn(duration: 500.ms).slideX(begin: 0.05, end: 0),
          );
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
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  ref.read(audioHandlerProvider).playTrack(track);
                },
                child: GlassCard(
                  borderRadius: 16,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Album Art
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 10, offset: const Offset(0, 4)
                            )
                          ]
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: track.albumArt,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              color: Colors.white.withValues(alpha: 0.1),
                              child: const Icon(Icons.music_note_rounded, color: Colors.white54),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(track.title, style: PandoosTypography.h2.copyWith(fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text(track.artist, style: PandoosTypography.bodyMedium.copyWith(color: Colors.white70), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      // Meta
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Icon(Icons.more_horiz_rounded, color: Colors.white54, size: 20),
                          const SizedBox(height: 12),
                          Text(durStr, style: PandoosTypography.labelSmall.copyWith(color: Colors.white54)),
                        ],
                      ),
                    ],
                  ),
                ).animate(delay: (i * 40).ms).fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0),
              ),
            );
          }),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: PandoosColors.primary)),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

