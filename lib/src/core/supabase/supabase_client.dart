import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientService {
  static final SupabaseClientService _instance = SupabaseClientService._internal();
  factory SupabaseClientService() => _instance;

  SupabaseClientService._internal();

  SupabaseClient get client => Supabase.instance.client;
}
