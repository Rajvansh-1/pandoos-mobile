import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../auth/domain/sign_out_usecase.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: PandoosColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Profile', style: PandoosTypography.h3),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white54),
            onPressed: () {
              ref.read(signOutUseCaseProvider).call();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar & Name
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [PandoosColors.primary, PandoosColors.pink],
                  ),
                  border: Border.all(color: Colors.white24, width: 2),
                ),
                child: const Icon(Icons.person_rounded, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text('Pandoos User', style: PandoosTypography.display2),
            Text('user@pandoos.com', style: PandoosTypography.bodyMedium.copyWith(color: Colors.white54)),
            
            const SizedBox(height: 40),
            
            // Gamification Stats
            Row(
              children: [
                Expanded(
                  child: GlassCard(
                    padding: const EdgeInsets.all(20),
                    borderRadius: 20,
                    child: Column(
                      children: [
                        const Icon(Icons.star_rounded, color: PandoosColors.primary, size: 32),
                        const SizedBox(height: 8),
                        Text('Level 12', style: PandoosTypography.h3),
                        Text('Music Explorer', style: PandoosTypography.caption.copyWith(color: PandoosColors.primary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GlassCard(
                    padding: const EdgeInsets.all(20),
                    borderRadius: 20,
                    child: Column(
                      children: [
                        const Icon(Icons.local_fire_department_rounded, color: PandoosColors.accent, size: 32),
                        const SizedBox(height: 8),
                        Text('14 Days', style: PandoosTypography.h3),
                        Text('Current Streak', style: PandoosTypography.caption.copyWith(color: PandoosColors.accent)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Badges
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Earned Badges', style: PandoosTypography.h2),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildBadge(Icons.headphones_rounded, 'First Listen', PandoosColors.primary),
                _buildBadge(Icons.favorite_rounded, 'Taste Maker', PandoosColors.pink),
                _buildBadge(Icons.nightlight_round, 'Night Owl', Colors.indigo),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.1),
            border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 20, spreadRadius: 2)
            ]
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 8),
        Text(label, style: PandoosTypography.caption, textAlign: TextAlign.center),
      ],
    );
  }
}
