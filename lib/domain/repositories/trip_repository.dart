import 'package:wayfarer_ai/domain/entities/trip.dart';

abstract class TripRepository {
  /// Get all trips for the current user
  Future<List<Trip>> getTrips();

  /// Get a specific trip by ID
  Future<Trip?> getTripById(String id);

  /// Create a new trip
  Future<Trip> createTrip(Trip trip);

  /// Update an existing trip
  Future<Trip> updateTrip(Trip trip);

  /// Delete a trip
  Future<void> deleteTrip(String id);

  /// Get upcoming trips
  Future<List<Trip>> getUpcomingTrips();

  /// Get ongoing trips
  Future<List<Trip>> getOngoingTrips();

  /// Get completed trips
  Future<List<Trip>> getCompletedTrips();

  /// Toggle favorite status
  Future<void> toggleFavorite(String id);

  /// Stream of trips (real-time updates)
  Stream<List<Trip>> watchTrips();
}

