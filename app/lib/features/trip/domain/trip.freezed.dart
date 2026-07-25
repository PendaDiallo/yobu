// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Trip {

 int get id; String get originLabel; String get destLabel;/// « 06:45 » — un trajet récurrent n'a pas de date.
 String get departureTime; int get durationMinutes; List<int> get daysOfWeek; int get seatsTotal; int get pricePerSeat; bool get active;
/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripCopyWith<Trip> get copyWith => _$TripCopyWithImpl<Trip>(this as Trip, _$identity);

  /// Serializes this Trip to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Trip&&(identical(other.id, id) || other.id == id)&&(identical(other.originLabel, originLabel) || other.originLabel == originLabel)&&(identical(other.destLabel, destLabel) || other.destLabel == destLabel)&&(identical(other.departureTime, departureTime) || other.departureTime == departureTime)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&const DeepCollectionEquality().equals(other.daysOfWeek, daysOfWeek)&&(identical(other.seatsTotal, seatsTotal) || other.seatsTotal == seatsTotal)&&(identical(other.pricePerSeat, pricePerSeat) || other.pricePerSeat == pricePerSeat)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,originLabel,destLabel,departureTime,durationMinutes,const DeepCollectionEquality().hash(daysOfWeek),seatsTotal,pricePerSeat,active);

@override
String toString() {
  return 'Trip(id: $id, originLabel: $originLabel, destLabel: $destLabel, departureTime: $departureTime, durationMinutes: $durationMinutes, daysOfWeek: $daysOfWeek, seatsTotal: $seatsTotal, pricePerSeat: $pricePerSeat, active: $active)';
}


}

/// @nodoc
abstract mixin class $TripCopyWith<$Res>  {
  factory $TripCopyWith(Trip value, $Res Function(Trip) _then) = _$TripCopyWithImpl;
@useResult
$Res call({
 int id, String originLabel, String destLabel, String departureTime, int durationMinutes, List<int> daysOfWeek, int seatsTotal, int pricePerSeat, bool active
});




}
/// @nodoc
class _$TripCopyWithImpl<$Res>
    implements $TripCopyWith<$Res> {
  _$TripCopyWithImpl(this._self, this._then);

  final Trip _self;
  final $Res Function(Trip) _then;

/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? originLabel = null,Object? destLabel = null,Object? departureTime = null,Object? durationMinutes = null,Object? daysOfWeek = null,Object? seatsTotal = null,Object? pricePerSeat = null,Object? active = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,originLabel: null == originLabel ? _self.originLabel : originLabel // ignore: cast_nullable_to_non_nullable
as String,destLabel: null == destLabel ? _self.destLabel : destLabel // ignore: cast_nullable_to_non_nullable
as String,departureTime: null == departureTime ? _self.departureTime : departureTime // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,daysOfWeek: null == daysOfWeek ? _self.daysOfWeek : daysOfWeek // ignore: cast_nullable_to_non_nullable
as List<int>,seatsTotal: null == seatsTotal ? _self.seatsTotal : seatsTotal // ignore: cast_nullable_to_non_nullable
as int,pricePerSeat: null == pricePerSeat ? _self.pricePerSeat : pricePerSeat // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Trip].
extension TripPatterns on Trip {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Trip value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Trip() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Trip value)  $default,){
final _that = this;
switch (_that) {
case _Trip():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Trip value)?  $default,){
final _that = this;
switch (_that) {
case _Trip() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String originLabel,  String destLabel,  String departureTime,  int durationMinutes,  List<int> daysOfWeek,  int seatsTotal,  int pricePerSeat,  bool active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Trip() when $default != null:
return $default(_that.id,_that.originLabel,_that.destLabel,_that.departureTime,_that.durationMinutes,_that.daysOfWeek,_that.seatsTotal,_that.pricePerSeat,_that.active);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String originLabel,  String destLabel,  String departureTime,  int durationMinutes,  List<int> daysOfWeek,  int seatsTotal,  int pricePerSeat,  bool active)  $default,) {final _that = this;
switch (_that) {
case _Trip():
return $default(_that.id,_that.originLabel,_that.destLabel,_that.departureTime,_that.durationMinutes,_that.daysOfWeek,_that.seatsTotal,_that.pricePerSeat,_that.active);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String originLabel,  String destLabel,  String departureTime,  int durationMinutes,  List<int> daysOfWeek,  int seatsTotal,  int pricePerSeat,  bool active)?  $default,) {final _that = this;
switch (_that) {
case _Trip() when $default != null:
return $default(_that.id,_that.originLabel,_that.destLabel,_that.departureTime,_that.durationMinutes,_that.daysOfWeek,_that.seatsTotal,_that.pricePerSeat,_that.active);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Trip implements Trip {
  const _Trip({required this.id, required this.originLabel, required this.destLabel, required this.departureTime, required this.durationMinutes, required final  List<int> daysOfWeek, required this.seatsTotal, required this.pricePerSeat, required this.active}): _daysOfWeek = daysOfWeek;
  factory _Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

@override final  int id;
@override final  String originLabel;
@override final  String destLabel;
/// « 06:45 » — un trajet récurrent n'a pas de date.
@override final  String departureTime;
@override final  int durationMinutes;
 final  List<int> _daysOfWeek;
@override List<int> get daysOfWeek {
  if (_daysOfWeek is EqualUnmodifiableListView) return _daysOfWeek;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_daysOfWeek);
}

@override final  int seatsTotal;
@override final  int pricePerSeat;
@override final  bool active;

/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripCopyWith<_Trip> get copyWith => __$TripCopyWithImpl<_Trip>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Trip&&(identical(other.id, id) || other.id == id)&&(identical(other.originLabel, originLabel) || other.originLabel == originLabel)&&(identical(other.destLabel, destLabel) || other.destLabel == destLabel)&&(identical(other.departureTime, departureTime) || other.departureTime == departureTime)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&const DeepCollectionEquality().equals(other._daysOfWeek, _daysOfWeek)&&(identical(other.seatsTotal, seatsTotal) || other.seatsTotal == seatsTotal)&&(identical(other.pricePerSeat, pricePerSeat) || other.pricePerSeat == pricePerSeat)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,originLabel,destLabel,departureTime,durationMinutes,const DeepCollectionEquality().hash(_daysOfWeek),seatsTotal,pricePerSeat,active);

@override
String toString() {
  return 'Trip(id: $id, originLabel: $originLabel, destLabel: $destLabel, departureTime: $departureTime, durationMinutes: $durationMinutes, daysOfWeek: $daysOfWeek, seatsTotal: $seatsTotal, pricePerSeat: $pricePerSeat, active: $active)';
}


}

/// @nodoc
abstract mixin class _$TripCopyWith<$Res> implements $TripCopyWith<$Res> {
  factory _$TripCopyWith(_Trip value, $Res Function(_Trip) _then) = __$TripCopyWithImpl;
@override @useResult
$Res call({
 int id, String originLabel, String destLabel, String departureTime, int durationMinutes, List<int> daysOfWeek, int seatsTotal, int pricePerSeat, bool active
});




}
/// @nodoc
class __$TripCopyWithImpl<$Res>
    implements _$TripCopyWith<$Res> {
  __$TripCopyWithImpl(this._self, this._then);

  final _Trip _self;
  final $Res Function(_Trip) _then;

/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? originLabel = null,Object? destLabel = null,Object? departureTime = null,Object? durationMinutes = null,Object? daysOfWeek = null,Object? seatsTotal = null,Object? pricePerSeat = null,Object? active = null,}) {
  return _then(_Trip(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,originLabel: null == originLabel ? _self.originLabel : originLabel // ignore: cast_nullable_to_non_nullable
as String,destLabel: null == destLabel ? _self.destLabel : destLabel // ignore: cast_nullable_to_non_nullable
as String,departureTime: null == departureTime ? _self.departureTime : departureTime // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,daysOfWeek: null == daysOfWeek ? _self._daysOfWeek : daysOfWeek // ignore: cast_nullable_to_non_nullable
as List<int>,seatsTotal: null == seatsTotal ? _self.seatsTotal : seatsTotal // ignore: cast_nullable_to_non_nullable
as int,pricePerSeat: null == pricePerSeat ? _self.pricePerSeat : pricePerSeat // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
