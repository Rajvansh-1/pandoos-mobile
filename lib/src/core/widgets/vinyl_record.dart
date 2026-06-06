import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/pandoos_colors.dart';

class VinylRecord extends StatefulWidget {
  final String albumArtUrl;
  final bool isPlaying;

  const VinylRecord({
    super.key,
    required this.albumArtUrl,
    required this.isPlaying,
  });

  @override
  State<VinylRecord> createState() => _VinylRecordState();
}

class _VinylRecordState extends State<VinylRecord> with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    if (widget.isPlaying) _rotationController.repeat();
  }

  @override
  void didUpdateWidget(covariant VinylRecord oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _rotationController.repeat();
      } else {
        _rotationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationController.value * 2 * pi,
          child: child,
        );
      },
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 30,
              spreadRadius: 10,
              offset: const Offset(0, 15),
            )
          ],
          border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Vinyl Grooves
            for (int i = 1; i < 6; i++)
              Container(
                width: 300 - (i * 30.0),
                height: 300 - (i * 30.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1),
                ),
              ),
            
            // Album Art center label
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: PandoosColors.surfaceHigh,
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: widget.albumArtUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => const Icon(Icons.music_note_rounded, color: Colors.white54, size: 40),
                ),
              ),
            ),
            
            // Center Spindle Hole
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: PandoosColors.background,
                border: Border.all(color: Colors.white38, width: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
