import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/pandoos_colors.dart';

class WaveformBar extends StatefulWidget {
  final bool isPlaying;
  
  const WaveformBar({super.key, required this.isPlaying});

  @override
  State<WaveformBar> createState() => _WaveformBarState();
}

class _WaveformBarState extends State<WaveformBar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    if (widget.isPlaying) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant WaveformBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.animateTo(0.1, duration: const Duration(milliseconds: 300));
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(20, (index) {
          final factor = 0.3 + (_random.nextDouble() * 0.7);
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final height = 40.0 * (_controller.value * factor).clamp(0.1, 1.0);
              return Container(
                width: 6,
                height: height,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: widget.isPlaying ? PandoosColors.primary : Colors.white24,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: widget.isPlaying ? [
                    BoxShadow(color: PandoosColors.primary.withValues(alpha: 0.5), blurRadius: 4, spreadRadius: 1)
                  ] : null,
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
