import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../../core/widgets/glass_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  _buildFeaturedBanner(context),
                  const SizedBox(height: 28),
                  _buildSectionHeader('Recently Played'),
                  const SizedBox(height: 14),
                  _buildHorizontalCards(),
                  const SizedBox(height: 28),
                  _buildSectionHeader('Trending Now'),
                  const SizedBox(height: 14),
                  _buildTrackList(),
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

  Widget _buildFeaturedBanner(BuildContext context) {
    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(20),
      fillColor: PandoosColors.primaryGlow,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: PandoosColors.primary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('FEATURED', style: PandoosTypography.labelSmall.copyWith(
                    color: PandoosColors.primary,
                  )),
                ),
                const SizedBox(height: 10),
                Text('Your Daily Mix', style: PandoosTypography.h2),
                const SizedBox(height: 4),
                Text('32 songs curated just for you',
                    style: PandoosTypography.bodyMedium),
                const SizedBox(height: 16),
                Container(
                  height: 40,
                  width: 110,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      PandoosColors.primary, PandoosColors.accent
                    ]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(
                      color: PandoosColors.primary.withValues(alpha: 0.4),
                      blurRadius: 12, offset: const Offset(0, 4),
                    )],
                  ),
                  child: Center(child: Text('Play All',
                    style: PandoosTypography.labelLarge.copyWith(color: Colors.white),
                  )),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [PandoosColors.primary, PandoosColors.pink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(
                color: PandoosColors.primary.withValues(alpha: 0.5),
                blurRadius: 20, offset: const Offset(0, 8),
              )],
            ),
            child: const Icon(Icons.queue_music_rounded, color: Colors.white, size: 40),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

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

  Widget _buildTrackList() {
    final tracks = [
      ('Blinding Lights', 'The Weeknd', '3:20'),
      ('As It Was', 'Harry Styles', '2:47'),
      ('Anti-Hero', 'Taylor Swift', '3:21'),
      ('Unholy', 'Sam Smith', '2:37'),
      ('Flowers', 'Miley Cyrus', '3:21'),
    ];

    return Column(
      children: List.generate(tracks.length, (i) {
        final (title, artist, dur) = tracks[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      PandoosColors.primary.withValues(alpha: 0.6),
                      PandoosColors.accent.withValues(alpha: 0.4),
                    ],
                  ),
                ),
                child: const Icon(Icons.music_note_rounded,
                    color: Colors.white70, size: 22),
              ),
            ),
            title: Text(title, style: PandoosTypography.labelLarge),
            subtitle: Text(artist, style: PandoosTypography.caption),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(dur, style: PandoosTypography.bodySmall),
                const SizedBox(width: 8),
                const Icon(Icons.more_vert_rounded,
                    color: PandoosColors.textMuted, size: 18),
              ],
            ),
            onTap: () {},
          ).animate(delay: (i * 50).ms).fadeIn(duration: 350.ms),
        );
      }),
    );
  }
}

