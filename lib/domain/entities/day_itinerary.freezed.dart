// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_itinerary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DayItinerary {
  String get id => throw _privateConstructorUsedError;
  int get dayNumber => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String? get summary => throw _privateConstructorUsedError;
  List<Activity> get activities => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DayItineraryCopyWith<DayItinerary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DayItineraryCopyWith<$Res> {
  factory $DayItineraryCopyWith(
          DayItinerary value, $Res Function(DayItinerary) then) =
      _$DayItineraryCopyWithImpl<$Res, DayItinerary>;
  @useResult
  $Res call(
      {String id,
      int dayNumber,
      DateTime date,
      String? summary,
      List<Activity> activities});
}

/// @nodoc
class _$DayItineraryCopyWithImpl<$Res, $Val extends DayItinerary>
    implements $DayItineraryCopyWith<$Res> {
  _$DayItineraryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dayNumber = null,
    Object? date = null,
    Object? summary = freezed,
    Object? activities = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dayNumber: null == dayNumber
          ? _value.dayNumber
          : dayNumber // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      activities: null == activities
          ? _value.activities
          : activities // ignore: cast_nullable_to_non_nullable
              as List<Activity>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DayItineraryImplCopyWith<$Res>
    implements $DayItineraryCopyWith<$Res> {
  factory _$$DayItineraryImplCopyWith(
          _$DayItineraryImpl value, $Res Function(_$DayItineraryImpl) then) =
      __$$DayItineraryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int dayNumber,
      DateTime date,
      String? summary,
      List<Activity> activities});
}

/// @nodoc
class __$$DayItineraryImplCopyWithImpl<$Res>
    extends _$DayItineraryCopyWithImpl<$Res, _$DayItineraryImpl>
    implements _$$DayItineraryImplCopyWith<$Res> {
  __$$DayItineraryImplCopyWithImpl(
      _$DayItineraryImpl _value, $Res Function(_$DayItineraryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dayNumber = null,
    Object? date = null,
    Object? summary = freezed,
    Object? activities = null,
  }) {
    return _then(_$DayItineraryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dayNumber: null == dayNumber
          ? _value.dayNumber
          : dayNumber // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      activities: null == activities
          ? _value._activities
          : activities // ignore: cast_nullable_to_non_nullable
              as List<Activity>,
    ));
  }
}

/// @nodoc

class _$DayItineraryImpl extends _DayItinerary {
  const _$DayItineraryImpl(
      {required this.id,
      required this.dayNumber,
      required this.date,
      this.summary,
      required final List<Activity> activities})
      : _activities = activities,
        super._();

  @override
  final String id;
  @override
  final int dayNumber;
  @override
  final DateTime date;
  @override
  final String? summary;
  final List<Activity> _activities;
  @override
  List<Activity> get activities {
    if (_activities is EqualUnmodifiableListView) return _activities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activities);
  }

  @override
  String toString() {
    return 'DayItinerary(id: $id, dayNumber: $dayNumber, date: $date, summary: $summary, activities: $activities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DayItineraryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dayNumber, dayNumber) ||
                other.dayNumber == dayNumber) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality()
                .equals(other._activities, _activities));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, dayNumber, date, summary,
      const DeepCollectionEquality().hash(_activities));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DayItineraryImplCopyWith<_$DayItineraryImpl> get copyWith =>
      __$$DayItineraryImplCopyWithImpl<_$DayItineraryImpl>(this, _$identity);
}

abstract class _DayItinerary extends DayItinerary {
  const factory _DayItinerary(
      {required final String id,
      required final int dayNumber,
      required final DateTime date,
      final String? summary,
      required final List<Activity> activities}) = _$DayItineraryImpl;
  const _DayItinerary._() : super._();

  @override
  String get id;
  @override
  int get dayNumber;
  @override
  DateTime get date;
  @override
  String? get summary;
  @override
  List<Activity> get activities;
  @override
  @JsonKey(ignore: true)
  _$$DayItineraryImplCopyWith<_$DayItineraryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
