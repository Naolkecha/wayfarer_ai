import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';

@freezed
class Location with _$Location {
  const factory Location({
    required double latitude,
    required double longitude,
    required String address,
    String? placeId,
    String? name,
    String? city,
    String? country,
  }) = _Location;

  const Location._();

  String get coordinates => '$latitude,$longitude';
}

