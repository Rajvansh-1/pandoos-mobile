import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/library/presentation/library_screen.dart';
import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/auth/presentation/onboarding_screen.dart';
import '../../features/player/presentation/now_playing_screen.dart';
import '../../features/panda_mood/presentation/mood_selector_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/settings/presentation/equalizer_screen.dart';
import '../../features/settings/presentation/sleep_timer_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/artist/presentation/artist_screen.dart';
import '../../features/album/presentation/album_screen.dart';
import '../../features/lyrics/presentation/lyrics_screen.dart';
import '../../features/wrapped/presentation/wrapped_screen.dart';
import '../widgets/main_shell.dart';
import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.home,
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: RouteNames.home,
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: RouteNames.search,
          name: 'search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: RouteNames.library,
          name: 'library',
          builder: (context, state) => const LibraryScreen(),
        ),
        GoRoute(
          path: RouteNames.profile,
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),

    // Auth
    GoRoute(
      path: RouteNames.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RouteNames.signIn,
      name: 'sign_in',
      builder: (context, state) => const SignInScreen(),
    ),

    // Player
    GoRoute(
      path: RouteNames.nowPlaying,
      name: 'now_playing',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const NowPlayingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
      ),
    ),

    // Mood
    GoRoute(
      path: RouteNames.moodSelector,
      name: 'mood_selector',
      pageBuilder: (context, state) => CustomTransitionPage(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        child: const MoodSelectorScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),

    // Settings
    GoRoute(
      path: RouteNames.settings,
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: RouteNames.equalizer,
      name: 'equalizer',
      builder: (context, state) => const EqualizerScreen(),
    ),
    GoRoute(
      path: RouteNames.sleepTimer,
      name: 'sleep_timer',
      builder: (context, state) => const SleepTimerScreen(),
    ),

    // Artist / Album
    GoRoute(
      path: '/artist/:browseId',
      name: 'artist',
      builder: (context, state) => ArtistScreen(
        browseId: state.pathParameters['browseId'] ?? '',
      ),
    ),
    GoRoute(
      path: '/album/:browseId',
      name: 'album',
      builder: (context, state) => AlbumScreen(
        browseId: state.pathParameters['browseId'] ?? '',
      ),
    ),

    // Lyrics
    GoRoute(
      path: RouteNames.lyrics,
      name: 'lyrics',
      builder: (context, state) => const LyricsScreen(),
    ),

    // Wrapped
    GoRoute(
      path: RouteNames.wrapped,
      name: 'wrapped',
      builder: (context, state) => const WrappedScreen(),
    ),
  ],
);
