import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wayfarer_ai/domain/entities/activity.dart';

part 'day_itinerary.freezed.dart';

@freezed
class DayItinerary with _$DayItinerary {
  const factory DayItinerary({
    required String id,
    required int dayNumber,
    required DateTime date,
    String? summary,
    required List<Activity> activities,
  }) = _DayItinerary;

  const DayItinerary._();

  double get estimatedCost {
    return activities.fold(0.0, (sum, activity) => sum + (activity.estimatedCost ?? 0));
  }

  int get totalActivities => activities.length;
}

