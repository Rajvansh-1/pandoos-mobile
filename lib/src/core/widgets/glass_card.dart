import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/pandoos_colors.dart';

/// A premium glassmorphism card that matches the Web App exactly
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 16,
    this.blur = 20,
    this.fillColor,
    this.borderColor,
    this.borderWidth = 1,
    this.width,
    this.height,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double blur;
  final Color? fillColor;
  final Color? borderColor;
  final double borderWidth;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding ?? EdgeInsets.zero,
          decoration: BoxDecoration(
            color: fillColor ?? Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? Colors.white.withValues(alpha: 0.1),
              width: borderWidth,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
