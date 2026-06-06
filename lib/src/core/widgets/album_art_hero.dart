import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/pandoos_colors.dart';

class AlbumArtHero extends StatelessWidget {
  final String imageUrl;
  final String tag;
  final double size;
  final double borderRadius;

  const AlbumArtHero({
    super.key,
    required this.imageUrl,
    required this.tag,
    this.size = 200,
    this.borderRadius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 30,
              offset: const Offset(0, 15),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: PandoosColors.surfaceHigh,
              child: const Center(child: CircularProgressIndicator(color: PandoosColors.primary)),
            ),
            errorWidget: (context, url, error) => Container(
              color: PandoosColors.surfaceHigh,
              child: const Icon(Icons.music_note_rounded, color: Colors.white54, size: 60),
            ),
          ),
        ),
      ),
    );
  }
}
