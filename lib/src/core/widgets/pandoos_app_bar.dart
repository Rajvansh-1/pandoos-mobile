import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/pandoos_typography.dart';
import '../theme/pandoos_colors.dart';

class PandoosAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const PandoosAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: AppBar(
          backgroundColor: PandoosColors.surface.withValues(alpha: 0.6),
          elevation: 0,
          title: Text(title, style: PandoosTypography.h3),
          centerTitle: true,
          leading: leading,
          actions: actions,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: Colors.white.withValues(alpha: 0.05),
              height: 1,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
