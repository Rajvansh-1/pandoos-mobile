import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../../core/widgets/neon_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PandoosColors.background,
      body: Stack(
        children: [
          // Background gradient circles
          Positioned(top: -100, right: -100,
            child: Container(width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: PandoosColors.primary.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(bottom: -80, left: -80,
            child: Container(width: 250, height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: PandoosColors.accent.withValues(alpha: 0.10),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [PandoosColors.primary, PandoosColors.accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(
                        color: PandoosColors.primary.withValues(alpha: 0.5),
                        blurRadius: 30, offset: const Offset(0, 10),
                      )],
                    ),
                    child: const Icon(
                      Icons.music_note_rounded,
                      color: Colors.white, size: 40,
                    ),
                  ).animate().scale(begin: const Offset(0.5, 0.5), duration: 500.ms,
                      curve: Curves.elasticOut),

                  const SizedBox(height: 24),

                  Text('Pandoos', style: PandoosTypography.display1)
                      .animate(delay: 100.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 8),
                  Text(
                    'Your music, everywhere.',
                    style: PandoosTypography.bodyLarge.copyWith(
                      color: PandoosColors.textSecondary,
                    ),
                  ).animate(delay: 150.ms).fadeIn(duration: 400.ms),

                  const Spacer(flex: 2),

                  // Feature pills
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      _featurePill('🎵 YouTube Music'),
                      _featurePill('📱 Cross-device sync'),
                      _featurePill('❤️ Liked songs'),
                      _featurePill('⬇️ Offline mode'),
                    ],
                  ).animate(delay: 200.ms).fadeIn(duration: 500.ms),

                  const SizedBox(height: 48),

                  // Google Sign In button
                  NeonButton(
                    label: 'Continue with Google',
                    icon: Icons.g_mobiledata_rounded,
                    isLoading: _isLoading,
                    width: double.infinity,
                    onPressed: () {
                      setState(() => _isLoading = true);
                      // TODO: wire to AuthNotifier
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) setState(() => _isLoading = false);
                      });
                    },
                  ).animate(delay: 300.ms).fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 16),

                  Text(
                    'By continuing, you agree to our Terms & Privacy Policy.',
                    style: PandoosTypography.bodySmall,
                    textAlign: TextAlign.center,
                  ).animate(delay: 400.ms).fadeIn(duration: 300.ms),

                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featurePill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: PandoosColors.surfaceHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PandoosColors.glassBorder),
      ),
      child: Text(label, style: PandoosTypography.bodySmall.copyWith(
        color: PandoosColors.textPrimary,
      )),
    );
  }
}

