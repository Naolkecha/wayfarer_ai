import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
    List<String>? travelPreferences,
    String? currency,
    DateTime? createdAt,
  }) = _UserProfile;
}

