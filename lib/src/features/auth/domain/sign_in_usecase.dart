import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/errors/pandoos_exception.dart';

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  return SignInUseCase();
});

class SignInUseCase {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> call() async {
    try {
      const webClientId = '529626065517-rvrjir6ugvkred5ln3vuev30lfnfnsth.apps.googleusercontent.com';
      
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
      );
      
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final accessToken = googleAuth?.accessToken;
      final idToken = googleAuth?.idToken;

      if (accessToken == null || idToken == null) {
        throw PandoosException('Failed to retrieve Google Auth tokens.');
      }

      await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      throw PandoosException('Sign in failed: $e');
    }
  }
}
