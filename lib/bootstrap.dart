import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'src/app.dart';
import 'src/features/download/data/download_repository.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 1. Load environment variables
    await dotenv.load(fileName: '.env');
    debugPrint('[Bootstrap] .env loaded ✓');

    // 2. Initialize Hive (fast cache)
    await Hive.initFlutter();
    await Hive.openBox('settings');
    await Hive.openBox('search_history');
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(DownloadTrackAdapter());
    }
    await Hive.openBox<DownloadTrack>('offline_tracks');
    debugPrint('[Bootstrap] Hive initialized ✓');

    // 3. Supabase — initialize eagerly so Library/Profile work immediately
    final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
    if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );
      debugPrint('[Bootstrap] Supabase initialized ✓');
    } else {
      debugPrint('[Bootstrap] Supabase skipped (missing .env keys)');
    }

    // 4. AudioService — initialized lazily when first song plays
    debugPrint('[Bootstrap] AudioService deferred ✓');

    // 5. Run app
    debugPrint('[Bootstrap] Starting app ✓');
    runApp(const ProviderScope(child: PandoosApp()));
  } catch (e, stack) {
    debugPrint('Bootstrap error: $e\n$stack');
    runApp(_ErrorApp(error: e.toString()));
  }
}

class _ErrorApp extends StatelessWidget {
  const _ErrorApp({required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: const Color(0xFF080811),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Color(0xFFE35656), size: 64),
              const SizedBox(height: 20),
              const Text('Startup Error',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              SelectableText(error,
                style: const TextStyle(color: Color(0xFF9896B0), fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
