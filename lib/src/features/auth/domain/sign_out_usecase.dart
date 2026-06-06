import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase();
});

class SignOutUseCase {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> call() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _supabase.auth.signOut();
  }
}
