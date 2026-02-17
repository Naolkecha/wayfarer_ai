import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wayfarer_ai/domain/entities/trip.dart';
import 'package:wayfarer_ai/domain/entities/day_itinerary.dart';
import 'package:wayfarer_ai/domain/entities/activity.dart';
import 'package:wayfarer_ai/domain/entities/location.dart';

class LocalStorageService {
  static const String _tripsBoxName = 'trips';
  static Box<String>? _tripsBox;

  /// Initialize Hive and open boxes
  static Future<void> init() async {
    await Hive.initFlutter();
    _tripsBox = await Hive.openBox<String>(_tripsBoxName);
  }

  /// Save a trip to local storage
  static Future<void> saveTrip(Trip trip) async {
    if (_tripsBox == null) {
      throw Exception('LocalStorageService not initialized. Call init() first.');
    }
    
    final tripJson = _tripToJson(trip);
    final tripString = json.encode(tripJson);
    await _tripsBox!.put(trip.id, tripString);
  }

  /// Get a specific trip by ID
  static Trip? getTrip(String id) {
    if (_tripsBox == null) {
      throw Exception('LocalStorageService not initialized. Call init() first.');
    }
    
    final tripString = _tripsBox!.get(id);
    if (tripString == null) return null;
    
    final tripJson = json.decode(tripString) as Map<String, dynamic>;
    return _tripFromJson(tripJson);
  }

  /// Get all saved trips
  static List<Trip> getAllTrips() {
    if (_tripsBox == null) {
      throw Exception('LocalStorageService not initialized. Call init() first.');
    }
    
    final trips = <Trip>[];
    for (final tripString in _tripsBox!.values) {
      try {
        final tripJson = json.decode(tripString) as Map<String, dynamic>;
        trips.add(_tripFromJson(tripJson));
      } catch (e) {
        print('Error parsing trip: $e');
      }
    }
    
    // Sort by creation date, newest first
    trips.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return trips;
  }

  /// Delete a trip
  static Future<void> deleteTrip(String id) async {
    if (_tripsBox == null) {
      throw Exception('LocalStorageService not initialized. Call init() first.');
    }
    
    await _tripsBox!.delete(id);
  }

  /// Clear all trips
  static Future<void> clearAllTrips() async {
    if (_tripsBox == null) {
      throw Exception('LocalStorageService not initialized. Call init() first.');
    }
    
    await _tripsBox!.clear();
  }

  /// Convert Trip to JSON
  static Map<String, dynamic> _tripToJson(Trip trip) {
    return {
      'id': trip.id,
      'destination': trip.destination,
      'country': trip.country,
      'startDate': trip.startDate.toIso8601String(),
      'endDate': trip.endDate.toIso8601String(),
      'budget': trip.budget,
      'preferences': trip.preferences,
      'itinerary': trip.itinerary.map((day) => _dayToJson(day)).toList(),
      'currentSpending': trip.currentSpending,
      'userId': trip.userId,
      'createdAt': trip.createdAt.toIso8601String(),
      'updatedAt': trip.updatedAt.toIso8601String(),
    };
  }

  /// Convert JSON to Trip
  static Trip _tripFromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as String,
      destination: json['destination'] as String,
      country: json['country'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      budget: (json['budget'] as num).toDouble(),
      preferences: (json['preferences'] as List).cast<String>(),
      itinerary: (json['itinerary'] as List)
          .map((day) => _dayFromJson(day as Map<String, dynamic>))
          .toList(),
      currentSpending: (json['currentSpending'] as num?)?.toDouble(),
      userId: json['userId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert DayItinerary to JSON
  static Map<String, dynamic> _dayToJson(DayItinerary day) {
    return {
      'id': day.id,
      'dayNumber': day.dayNumber,
      'date': day.date.toIso8601String(),
      'summary': day.summary,
      'activities': day.activities.map((activity) => _activityToJson(activity)).toList(),
    };
  }

  /// Convert JSON to DayItinerary
  static DayItinerary _dayFromJson(Map<String, dynamic> json) {
    return DayItinerary(
      id: json['id'] as String,
      dayNumber: json['dayNumber'] as int,
      date: DateTime.parse(json['date'] as String),
      summary: json['summary'] as String?,
      activities: (json['activities'] as List)
          .map((activity) => _activityFromJson(activity as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Convert Activity to JSON
  static Map<String, dynamic> _activityToJson(Activity activity) {
    return {
      'id': activity.id,
      'name': activity.name,
      'type': activity.type.name,
      'time': activity.time,
      'estimatedCost': activity.estimatedCost,
      'description': activity.description,
      'location': _locationToJson(activity.location),
      'duration': activity.duration,
    };
  }

  /// Convert JSON to Activity
  static Activity _activityFromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String,
      name: json['name'] as String,
      type: _parseActivityType(json['type'] as String),
      time: json['time'] as String,
      location: _locationFromJson(json['location'] as Map<String, dynamic>),
      description: json['description'] as String?,
      estimatedCost: (json['estimatedCost'] as num?)?.toDouble(),
      duration: json['duration'] as int?,
    );
  }

  /// Convert Location to JSON
  static Map<String, dynamic> _locationToJson(Location location) {
    return {
      'address': location.address,
      'latitude': location.latitude,
      'longitude': location.longitude,
    };
  }

  /// Convert JSON to Location
  static Location _locationFromJson(Map<String, dynamic> json) {
    return Location(
      address: json['address'] as String,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Parse activity type string to enum
  static ActivityType _parseActivityType(String type) {
    switch (type.toLowerCase()) {
      case 'sightseeing':
        return ActivityType.sightseeing;
      case 'restaurant':
        return ActivityType.restaurant;
      case 'hotel':
        return ActivityType.hotel;
      case 'shopping':
        return ActivityType.shopping;
      case 'entertainment':
        return ActivityType.entertainment;
      case 'transport':
        return ActivityType.transport;
      default:
        return ActivityType.other;
    }
  }
}

