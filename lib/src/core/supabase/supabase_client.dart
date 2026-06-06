import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseClientService {
  static final SupabaseClientService _instance = SupabaseClientService._internal();
  factory SupabaseClientService() => _instance;
  SupabaseClientService._internal();

  /// Initializes Supabase if it hasn't been done yet (idempotent).
  Future<void> init() async {
    try {
      // If already initialized (by bootstrap), this will succeed immediately.
      Supabase.instance.client;
      return;
    } catch (_) {
      // Not initialized yet — do it now.
    }

    final url = dotenv.env['SUPABASE_URL'] ?? '';
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

    if (url.isNotEmpty && anonKey.isNotEmpty) {
      await Supabase.initialize(url: url, anonKey: anonKey);
    }
  }

  /// Returns the Supabase client, initializing synchronously if needed.
  SupabaseClient get client {
    try {
      return Supabase.instance.client;
    } catch (_) {
      throw Exception('Supabase is not initialized. Make sure bootstrap() ran first.');
    }
  }

  bool get isInitialized {
    try {
      Supabase.instance.client;
      return true;
    } catch (_) {
      return false;
    }
  }
}
