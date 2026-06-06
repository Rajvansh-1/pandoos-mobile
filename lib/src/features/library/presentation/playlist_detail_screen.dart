import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../../core/widgets/neon_button.dart';
import '../data/library_data_source.dart';
import '../../../core/audio/audio_service_provider.dart';

class PlaylistDetailScreen extends ConsumerWidget {
  const PlaylistDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In production, we'd accept playlistName as a parameter
    final String playlistName = 'My Awesome Mix';

    return Scaffold(
      backgroundColor: PandoosColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: PandoosColors.background,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [PandoosColors.primary.withValues(alpha: 0.6), PandoosColors.background],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: PandoosColors.surfaceHigh,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 30, offset: const Offset(0, 10))
                        ],
                      ),
                      child: const Icon(Icons.queue_music_rounded, size: 60, color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(playlistName, style: PandoosTypography.display2),
                  const SizedBox(height: 8),
                  Text('Created by Pandoos User • 0 songs', style: PandoosTypography.bodyMedium.copyWith(color: Colors.white54)),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      NeonButton(
                        label: 'Play',
                        icon: Icons.play_arrow_rounded,
                        onPressed: () {},
                        width: 140,
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.shuffle_rounded, color: Colors.white54, size: 28),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert_rounded, color: Colors.white54, size: 28),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Text('This playlist is currently empty.', style: PandoosTypography.bodyLarge.copyWith(color: Colors.white24)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
