import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../../core/widgets/neon_button.dart';
import 'wrapped_card_widget.dart';

class WrappedScreen extends ConsumerStatefulWidget {
  const WrappedScreen({super.key});

  @override
  ConsumerState<WrappedScreen> createState() => _WrappedScreenState();
}

class _WrappedScreenState extends ConsumerState<WrappedScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isSharing = false;

  Future<void> _shareWrapped() async {
    setState(() => _isSharing = true);
    try {
      final image = await _screenshotController.capture();
      if (image == null) return;

      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/pandoos_wrapped.png').create();
      await imagePath.writeAsBytes(image);

      await Share.shareXFiles(
        [XFile(imagePath.path)],
        text: 'Check out my Pandoos Wrapped!',
      );
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PandoosColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Your Month Wrapped', style: PandoosTypography.h3),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Screenshot(
              controller: _screenshotController,
              child: const WrappedCardWidget(
                topArtist: 'The Weeknd',
                topSong: 'Blinding Lights',
                minutesListened: 4320,
                dominantMood: 'Melancholy',
              ),
            ),
            const SizedBox(height: 40),
            _isSharing
                ? const CircularProgressIndicator(color: PandoosColors.primary)
                : NeonButton(
                    label: 'Share Wrapped',
                    icon: Icons.ios_share_rounded,
                    onPressed: _shareWrapped,
                    width: 200,
                  ),
          ],
        ),
      ),
    );
  }
}
