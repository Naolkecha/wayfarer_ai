// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Trip {
  String get id => throw _privateConstructorUsedError;
  String get destination => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  double get budget => throw _privateConstructorUsedError;
  List<String> get preferences => throw _privateConstructorUsedError;
  List<DayItinerary> get itinerary => throw _privateConstructorUsedError;
  double? get currentSpending => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TripCopyWith<Trip> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripCopyWith<$Res> {
  factory $TripCopyWith(Trip value, $Res Function(Trip) then) =
      _$TripCopyWithImpl<$Res, Trip>;
  @useResult
  $Res call(
      {String id,
      String destination,
      String country,
      DateTime startDate,
      DateTime endDate,
      double budget,
      List<String> preferences,
      List<DayItinerary> itinerary,
      double? currentSpending,
      String? userId,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$TripCopyWithImpl<$Res, $Val extends Trip>
    implements $TripCopyWith<$Res> {
  _$TripCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? destination = null,
    Object? country = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? budget = null,
    Object? preferences = null,
    Object? itinerary = null,
    Object? currentSpending = freezed,
    Object? userId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      budget: null == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as double,
      preferences: null == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as List<String>,
      itinerary: null == itinerary
          ? _value.itinerary
          : itinerary // ignore: cast_nullable_to_non_nullable
              as List<DayItinerary>,
      currentSpending: freezed == currentSpending
          ? _value.currentSpending
          : currentSpending // ignore: cast_nullable_to_non_nullable
              as double?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TripImplCopyWith<$Res> implements $TripCopyWith<$Res> {
  factory _$$TripImplCopyWith(
          _$TripImpl value, $Res Function(_$TripImpl) then) =
      __$$TripImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String destination,
      String country,
      DateTime startDate,
      DateTime endDate,
      double budget,
      List<String> preferences,
      List<DayItinerary> itinerary,
      double? currentSpending,
      String? userId,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$TripImplCopyWithImpl<$Res>
    extends _$TripCopyWithImpl<$Res, _$TripImpl>
    implements _$$TripImplCopyWith<$Res> {
  __$$TripImplCopyWithImpl(_$TripImpl _value, $Res Function(_$TripImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? destination = null,
    Object? country = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? budget = null,
    Object? preferences = null,
    Object? itinerary = null,
    Object? currentSpending = freezed,
    Object? userId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$TripImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      budget: null == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as double,
      preferences: null == preferences
          ? _value._preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as List<String>,
      itinerary: null == itinerary
          ? _value._itinerary
          : itinerary // ignore: cast_nullable_to_non_nullable
              as List<DayItinerary>,
      currentSpending: freezed == currentSpending
          ? _value.currentSpending
          : currentSpending // ignore: cast_nullable_to_non_nullable
              as double?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$TripImpl extends _Trip {
  const _$TripImpl(
      {required this.id,
      required this.destination,
      required this.country,
      required this.startDate,
      required this.endDate,
      required this.budget,
      required final List<String> preferences,
      required final List<DayItinerary> itinerary,
      this.currentSpending,
      this.userId,
      required this.createdAt,
      required this.updatedAt})
      : _preferences = preferences,
        _itinerary = itinerary,
        super._();

  @override
  final String id;
  @override
  final String destination;
  @override
  final String country;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final double budget;
  final List<String> _preferences;
  @override
  List<String> get preferences {
    if (_preferences is EqualUnmodifiableListView) return _preferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_preferences);
  }

  final List<DayItinerary> _itinerary;
  @override
  List<DayItinerary> get itinerary {
    if (_itinerary is EqualUnmodifiableListView) return _itinerary;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_itinerary);
  }

  @override
  final double? currentSpending;
  @override
  final String? userId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Trip(id: $id, destination: $destination, country: $country, startDate: $startDate, endDate: $endDate, budget: $budget, preferences: $preferences, itinerary: $itinerary, currentSpending: $currentSpending, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.budget, budget) || other.budget == budget) &&
            const DeepCollectionEquality()
                .equals(other._preferences, _preferences) &&
            const DeepCollectionEquality()
                .equals(other._itinerary, _itinerary) &&
            (identical(other.currentSpending, currentSpending) ||
                other.currentSpending == currentSpending) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      destination,
      country,
      startDate,
      endDate,
      budget,
      const DeepCollectionEquality().hash(_preferences),
      const DeepCollectionEquality().hash(_itinerary),
      currentSpending,
      userId,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      __$$TripImplCopyWithImpl<_$TripImpl>(this, _$identity);
}

abstract class _Trip extends Trip {
  const factory _Trip(
      {required final String id,
      required final String destination,
      required final String country,
      required final DateTime startDate,
      required final DateTime endDate,
      required final double budget,
      required final List<String> preferences,
      required final List<DayItinerary> itinerary,
      final double? currentSpending,
      final String? userId,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$TripImpl;
  const _Trip._() : super._();

  @override
  String get id;
  @override
  String get destination;
  @override
  String get country;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  double get budget;
  @override
  List<String> get preferences;
  @override
  List<DayItinerary> get itinerary;
  @override
  double? get currentSpending;
  @override
  String? get userId;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
