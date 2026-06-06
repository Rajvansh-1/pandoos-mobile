import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/pandoos_colors.dart';

class ShimmerLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: PandoosColors.surfaceHigh,
      highlightColor: PandoosColors.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: PandoosColors.surfaceHigh,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
