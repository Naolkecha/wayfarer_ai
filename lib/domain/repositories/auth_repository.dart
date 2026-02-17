import 'package:wayfarer_ai/domain/entities/user_profile.dart';

abstract class AuthRepository {
  /// Get current user
  Future<UserProfile?> getCurrentUser();

  /// Sign in with email and password
  Future<UserProfile> signInWithEmail(String email, String password);

  /// Sign up with email and password
  Future<UserProfile> signUpWithEmail(String email, String password, String displayName);

  /// Sign in with Google
  Future<UserProfile> signInWithGoogle();

  /// Sign out
  Future<void> signOut();

  /// Reset password
  Future<void> resetPassword(String email);

  /// Update user profile
  Future<UserProfile> updateProfile(UserProfile profile);

  /// Stream of auth state changes
  Stream<UserProfile?> watchAuthState();
}

