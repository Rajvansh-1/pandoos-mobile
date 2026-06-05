import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/audio/audio_service_provider.dart';
import 'search_notifier.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../../core/widgets/glass_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PandoosColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text('Search', style: PandoosTypography.display2)
                  .animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 24),
              Expanded(
                child: _query.isEmpty
                    ? _buildBrowseCategories()
                    : _buildSearchResults(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _controller,
      onChanged: (val) {
        setState(() => _query = val);
        if (val.trim().length > 2) {
          ref.read(searchNotifierProvider.notifier).search(val);
        } else if (val.isEmpty) {
          ref.read(searchNotifierProvider.notifier).clear();
        }
      },
      style: PandoosTypography.bodyLarge,
      decoration: InputDecoration(
        hintText: 'Songs, artists, albums...',
        prefixIcon: const Icon(Icons.search_rounded, size: 22),
        suffixIcon: _query.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear_rounded, size: 20),
                onPressed: () {
                  _controller.clear();
                  setState(() => _query = '');
                  ref.read(searchNotifierProvider.notifier).clear();
                },
              )
            : null,
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(begin: 0.05, end: 0);
  }

  Widget _buildBrowseCategories() {
    final categories = [
      ('Pop', PandoosColors.pink, Icons.favorite_rounded),
      ('Hip-Hop', PandoosColors.primary, Icons.mic_rounded),
      ('Electronic', PandoosColors.accent, Icons.electric_bolt_rounded),
      ('R&B', Color(0xFFE3A756), Icons.piano_rounded),
      ('Rock', Color(0xFF56ADE3), Icons.headphones_rounded),
      ('Lo-fi', Color(0xFF9856E3), Icons.coffee_rounded),
      ('Jazz', Color(0xFFE356A7), Icons.music_note_rounded),
      ('Classical', Color(0xFF56E3A7), Icons.queue_music_rounded),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Browse Categories', style: PandoosTypography.h2),
        const SizedBox(height: 16),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.9,
            ),
            itemCount: categories.length,
            itemBuilder: (_, i) {
              final (label, color, icon) = categories[i];
              return GestureDetector(
                onTap: () {
                  _controller.text = label;
                  setState(() => _query = label);
                  ref.read(searchNotifierProvider.notifier).search(label);
                },
                child: GlassCard(
                  borderRadius: 14,
                  fillColor: color.withValues(alpha: 0.15),
                  borderColor: color.withValues(alpha: 0.3),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(icon, color: color, size: 24),
                      const SizedBox(width: 10),
                      Text(label,
                        style: PandoosTypography.h3.copyWith(color: PandoosColors.textPrimary),
                      ),
                    ],
                  ),
                ).animate(delay: (i * 40).ms).fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95)),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    final searchState = ref.watch(searchNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Results for "$_query"', style: PandoosTypography.h3),
        const SizedBox(height: 12),
        Expanded(
          child: searchState.when(
            data: (tracks) {
              if (tracks.isEmpty) {
                return Center(
                  child: Text('No results found.', style: PandoosTypography.bodyMedium),
                );
              }
              return ListView.separated(
                itemCount: tracks.length,
                separatorBuilder: (_, _) => const Divider(
                  color: PandoosColors.glassBorder, height: 1, indent: 64,
                ),
                itemBuilder: (_, i) {
                  final track = tracks[i];
                  final durStr = '${track.duration ~/ 60}:${(track.duration % 60).toString().padLeft(2, '0')}';
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
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
                    trailing: Text(durStr, style: PandoosTypography.bodySmall),
                    onTap: () {
                      ref.read(audioHandlerProvider).playTrack(track);
                      // TODO: Navigate to player screen or show mini-player
                    },
                  ).animate(delay: (i * 40).ms).fadeIn(duration: 300.ms);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: PandoosColors.primary)),
            error: (e, _) => Center(child: Text('Error: $e', style: PandoosTypography.bodyMedium)),
          ),
        ),
      ],
    );
  }
}

