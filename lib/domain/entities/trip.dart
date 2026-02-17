import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wayfarer_ai/domain/entities/day_itinerary.dart';

part 'trip.freezed.dart';

@freezed
class Trip with _$Trip {
  const factory Trip({
    required String id,
    required String destination,
    required String country,
    required DateTime startDate,
    required DateTime endDate,
    required double budget,
    required List<String> preferences,
    required List<DayItinerary> itinerary,
    double? currentSpending,
    String? userId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Trip;

  const Trip._();

  int get numberOfDays => itinerary.length;
  
  double get budgetRemaining => budget - (currentSpending ?? 0);
  
  bool get isOngoing {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }
  
  bool get isUpcoming => DateTime.now().isBefore(startDate);
  
  bool get isCompleted => DateTime.now().isAfter(endDate);
}

