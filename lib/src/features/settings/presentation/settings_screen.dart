import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/theme/pandoos_colors.dart';
import '../../../core/theme/pandoos_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/router/route_names.dart';
import '../../auth/domain/sign_out_usecase.dart';
import 'audio_quality_tile.dart';
import 'theme_settings_tile.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _appVersion = '';
  bool _offlineMode = false;
  bool _autoPlay = true;
  bool _showLyrics = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) setState(() => _appVersion = info.version);
    });
  }

  void _loadSettings() {
    final box = Hive.box('settings');
    setState(() {
      _offlineMode = box.get('offline_mode', defaultValue: false);
      _autoPlay = box.get('auto_play', defaultValue: true);
      _showLyrics = box.get('show_lyrics', defaultValue: true);
    });
  }

  void _saveSetting(String key, dynamic value) {
    Hive.box('settings').put(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PandoosColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: PandoosColors.background,
            title: Text('Settings', style: PandoosTypography.h2),
            centerTitle: true,
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader('Playback'),
                  GlassCard(
                    borderRadius: 20,
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        const AudioQualityTile(),
                        _divider(),
                        SwitchListTile(
                          value: _autoPlay,
                          title: Text('Autoplay', style: PandoosTypography.bodyLarge),
                          subtitle: Text('Automatically play similar songs', style: PandoosTypography.caption),
                          activeColor: PandoosColors.primary,
                          onChanged: (val) {
                            setState(() => _autoPlay = val);
                            _saveSetting('auto_play', val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  _sectionHeader('Display'),
                  GlassCard(
                    borderRadius: 20,
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        const ThemeSettingsTile(),
                        _divider(),
                        SwitchListTile(
                          value: _showLyrics,
                          title: Text('Show Lyrics Overlay', style: PandoosTypography.bodyLarge),
                          subtitle: Text('Display synced lyrics on the player', style: PandoosTypography.caption),
                          activeColor: PandoosColors.primary,
                          onChanged: (val) {
                            setState(() => _showLyrics = val);
                            _saveSetting('show_lyrics', val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  _sectionHeader('Advanced'),
                  GlassCard(
                    borderRadius: 20,
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.equalizer_rounded, color: PandoosColors.primary),
                          title: Text('Equalizer', style: PandoosTypography.bodyLarge),
                          subtitle: Text('Fine-tune your audio experience', style: PandoosTypography.caption),
                          trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white54),
                          onTap: () => context.push(RouteNames.equalizer),
                        ),
                        _divider(),
                        ListTile(
                          leading: const Icon(Icons.nightlight_round, color: PandoosColors.accent),
                          title: Text('Sleep Timer', style: PandoosTypography.bodyLarge),
                          subtitle: Text('Stop playback after a set time', style: PandoosTypography.caption),
                          trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white54),
                          onTap: () => context.push(RouteNames.sleepTimer),
                        ),
                        _divider(),
                        SwitchListTile(
                          value: _offlineMode,
                          title: Text('Offline Mode', style: PandoosTypography.bodyLarge),
                          subtitle: Text('Only play downloaded songs', style: PandoosTypography.caption),
                          activeColor: PandoosColors.primary,
                          onChanged: (val) {
                            setState(() => _offlineMode = val);
                            _saveSetting('offline_mode', val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  _sectionHeader('Account'),
                  GlassCard(
                    borderRadius: 20,
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.logout_rounded, color: PandoosColors.error),
                          title: Text('Sign Out', style: PandoosTypography.bodyLarge.copyWith(color: PandoosColors.error)),
                          onTap: () async {
                            await ref.read(signOutUseCaseProvider).call();
                            if (context.mounted) context.go(RouteNames.onboarding);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  Center(
                    child: Text(
                      'Pandoos Mobile v$_appVersion\nPowered by the Panda Emotion Engine',
                      style: PandoosTypography.caption.copyWith(color: Colors.white24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(title, style: PandoosTypography.labelLarge.copyWith(color: Colors.white54)),
    );
  }

  Widget _divider() => const Divider(height: 1, color: Colors.white10, indent: 16, endIndent: 16);
}
