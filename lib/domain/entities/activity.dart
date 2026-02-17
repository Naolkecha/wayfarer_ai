import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:wayfarer_ai/domain/entities/location.dart';

part 'activity.freezed.dart';

enum ActivityType {
  sightseeing,
  restaurant,
  hotel,
  shopping,
  entertainment,
  transport,
  other,
}

@freezed
class Activity with _$Activity {
  const factory Activity({
    required String id,
    required String name,
    required ActivityType type,
    required String time,
    required Location location,
    String? description,
    String? imageUrl,
    double? estimatedCost,
    int? duration, // in minutes
    String? bookingUrl,
    double? rating,
    List<String>? tags,
    @Default(false) bool isCompleted,
  }) = _Activity;

  const Activity._();

  IconData get typeIcon {
    switch (type) {
      case ActivityType.sightseeing:
        return Icons.museum;
      case ActivityType.restaurant:
        return Icons.restaurant;
      case ActivityType.hotel:
        return Icons.hotel;
      case ActivityType.shopping:
        return Icons.shopping_bag;
      case ActivityType.entertainment:
        return Icons.theater_comedy;
      case ActivityType.transport:
        return Icons.directions_car;
      case ActivityType.other:
        return Icons.place;
    }
  }
  
  String get typeEmoji {
    switch (type) {
      case ActivityType.sightseeing:
        return '🏛️';
      case ActivityType.restaurant:
        return '🍽️';
      case ActivityType.hotel:
        return '🏨';
      case ActivityType.shopping:
        return '🛍️';
      case ActivityType.entertainment:
        return '🎭';
      case ActivityType.transport:
        return '🚗';
      case ActivityType.other:
        return '📍';
    }
  }
}

