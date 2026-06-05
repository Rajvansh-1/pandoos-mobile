import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart' as google;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../core/supabase/supabase_client.dart';
import '../domain/pandoos_user.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(SupabaseClientService());
});

class AuthRepository {
  final SupabaseClientService _supabaseService;

  AuthRepository(this._supabaseService);

  Future<PandoosUser?> signInWithGoogle() async {
    await _supabaseService.init();
    
    final webClientId = dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
    
    final google.GoogleSignIn googleSignIn = google.GoogleSignIn(
      serverClientId: webClientId,
      scopes: ['email', 'profile'],
    );

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return null;
    }

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    if (idToken == null) {
      throw Exception('No ID Token found.');
    }

    final AuthResponse res = await _supabaseService.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
    );

    final user = res.user;
    if (user != null) {
      return PandoosUser(
        id: user.id,
        email: user.email ?? '',
        username: user.userMetadata?['full_name'] ?? 'Pandoos User',
        avatarUrl: user.userMetadata?['avatar_url'],
        createdAt: user.createdAt,
      );
    }
    return null;
  }

  Future<void> signOut() async {
    await _supabaseService.init();
    await _supabaseService.client.auth.signOut();
    final google.GoogleSignIn googleSignIn = google.GoogleSignIn();
    await googleSignIn.signOut();
  }
}
