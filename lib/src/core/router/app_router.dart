import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/library/presentation/library_screen.dart';
import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/player/presentation/now_playing_screen.dart';
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
      ],
    ),
    GoRoute(
      path: RouteNames.signIn,
      name: 'sign_in',
      builder: (context, state) => const SignInScreen(),
    ),
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
            ).animate(CurvedAnimation(
                parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
      ),
    ),
  ],
);
