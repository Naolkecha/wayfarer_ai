import 'package:wayfarer_ai/domain/entities/trip.dart';

abstract class AIRepository {
  /// Generate a trip itinerary using AI
  Future<Trip> generateItinerary({
    required String destination,
    required String country,
    required DateTime startDate,
    required DateTime endDate,
    required double budget,
    required List<String> preferences,
  });

  /// Refine an existing itinerary
  Future<Trip> refineItinerary({
    required Trip trip,
    required String refinementPrompt,
  });

  /// Get activity suggestions for a specific day
  Future<List<String>> getActivitySuggestions({
    required String destination,
    required String activityType,
  });

  /// Get travel tips for a destination
  Future<List<String>> getTravelTips(String destination);
}

