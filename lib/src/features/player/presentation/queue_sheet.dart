import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/audio/audio_service_provider.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';

class QueueSheet extends ConsumerWidget {
  const QueueSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioHandler = ref.watch(audioHandlerProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: PandoosColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: PandoosColors.textMuted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text('Up Next', style: PandoosTypography.h3),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<List<MediaItem>>(
                  stream: audioHandler.queue,
                  builder: (context, snapshot) {
                    final queue = snapshot.data ?? [];
                    if (queue.isEmpty) {
                      return const Center(child: Text('Queue is empty.'));
                    }
                    return ReorderableListView.builder(
                      scrollController: scrollController,
                      itemCount: queue.length,
                      onReorder: (oldIndex, newIndex) {
                        audioHandler.reorderQueue(oldIndex, newIndex);
                      },
                      itemBuilder: (context, index) {
                        final item = queue[index];
                        return ListTile(
                          key: ValueKey(item.id),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: CachedNetworkImage(
                              imageUrl: item.artUri?.toString() ?? '',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => const Icon(Icons.music_note, color: Colors.grey),
                            ),
                          ),
                          title: Text(item.title, style: PandoosTypography.bodyMedium, maxLines: 1),
                          subtitle: Text(item.artist ?? '', style: PandoosTypography.bodySmall, maxLines: 1),
                          trailing: IconButton(
                            icon: const Icon(Icons.close_rounded, size: 20),
                            onPressed: () {
                              audioHandler.removeFromQueue(index);
                            },
                          ),
                          onTap: () {
                            audioHandler.playFromQueue(index);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
