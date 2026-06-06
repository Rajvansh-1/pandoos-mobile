import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rive/rive.dart' hide Image;
import '../domain/sign_in_usecase.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/router/route_names.dart';
import '../../../core/errors/error_handler.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  bool _isLoading = false;

  Future<void> _handleSignIn() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(signInUseCaseProvider).call();
      if (mounted) context.go(RouteNames.home);
    } catch (e) {
      if (mounted) {
        ref.read(errorHandlerProvider).showError(context, e.toString());
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PandoosColors.background,
      body: Stack(
        children: [
          // Dynamic Blob Gradient Background
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: PandoosColors.primary,
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(end: 1.5, duration: 4.seconds),
          ),
          Positioned(
            bottom: -50,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: PandoosColors.pink,
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(end: 1.2, duration: 3.seconds),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  // Central Panda / Logo
                  Center(
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: PandoosColors.primary.withValues(alpha: 0.5),
                            blurRadius: 40,
                            spreadRadius: 10,
                          )
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/panda_placeholder.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ).animate().scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut),
                  ),
                  const Spacer(),
                  
                  // Text and Auth Button
                  GlassCard(
                    padding: const EdgeInsets.all(32),
                    borderRadius: 32,
                    blur: 20,
                    child: Column(
                      children: [
                        Text('Feel the Music.',
                          style: PandoosTypography.display2,
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
                        const SizedBox(height: 16),
                        Text('Pandoos Mobile adapts to your mood in real-time. Join the ecosystem.',
                          style: PandoosTypography.bodyLarge.copyWith(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2),
                        const SizedBox(height: 32),
                        
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleSignIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.g_mobiledata_rounded, size: 32),
                                      const SizedBox(width: 8),
                                      Text('Continue with Google', style: PandoosTypography.labelLarge.copyWith(color: Colors.black, fontSize: 16)),
                                    ],
                                  ),
                          ),
                        ).animate().fadeIn(delay: 900.ms).scale(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
