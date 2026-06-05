import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/router/app_router.dart';
import 'core/theme/pandoos_theme.dart';
import 'core/theme/pandoos_colors.dart';

class PandoosApp extends StatelessWidget {
  const PandoosApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Force dark status bar icons to be light
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: PandoosColors.surface,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    return MaterialApp.router(
      title: 'Pandoos',
      debugShowCheckedModeBanner: false,
      theme: PandoosTheme.dark,
      routerConfig: appRouter,
    );
  }
}
