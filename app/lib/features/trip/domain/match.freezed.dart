// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Match {

 MatchTrip get trip; MatchDriver get driver; int get pickupDistanceM; int get dropoffDistanceM; double get score;
/// Create a copy of Match
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchCopyWith<Match> get copyWith => _$MatchCopyWithImpl<Match>(this as Match, _$identity);

  /// Serializes this Match to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Match&&(identical(other.trip, trip) || other.trip == trip)&&(identical(other.driver, driver) || other.driver == driver)&&(identical(other.pickupDistanceM, pickupDistanceM) || other.pickupDistanceM == pickupDistanceM)&&(identical(other.dropoffDistanceM, dropoffDistanceM) || other.dropoffDistanceM == dropoffDistanceM)&&(identical(other.score, score) || other.score == score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,trip,driver,pickupDistanceM,dropoffDistanceM,score);

@override
String toString() {
  return 'Match(trip: $trip, driver: $driver, pickupDistanceM: $pickupDistanceM, dropoffDistanceM: $dropoffDistanceM, score: $score)';
}


}

/// @nodoc
abstract mixin class $MatchCopyWith<$Res>  {
  factory $MatchCopyWith(Match value, $Res Function(Match) _then) = _$MatchCopyWithImpl;
@useResult
$Res call({
 MatchTrip trip, MatchDriver driver, int pickupDistanceM, int dropoffDistanceM, double score
});


$MatchTripCopyWith<$Res> get trip;$MatchDriverCopyWith<$Res> get driver;

}
/// @nodoc
class _$MatchCopyWithImpl<$Res>
    implements $MatchCopyWith<$Res> {
  _$MatchCopyWithImpl(this._self, this._then);

  final Match _self;
  final $Res Function(Match) _then;

/// Create a copy of Match
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? trip = null,Object? driver = null,Object? pickupDistanceM = null,Object? dropoffDistanceM = null,Object? score = null,}) {
  return _then(_self.copyWith(
trip: null == trip ? _self.trip : trip // ignore: cast_nullable_to_non_nullable
as MatchTrip,driver: null == driver ? _self.driver : driver // ignore: cast_nullable_to_non_nullable
as MatchDriver,pickupDistanceM: null == pickupDistanceM ? _self.pickupDistanceM : pickupDistanceM // ignore: cast_nullable_to_non_nullable
as int,dropoffDistanceM: null == dropoffDistanceM ? _self.dropoffDistanceM : dropoffDistanceM // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of Match
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MatchTripCopyWith<$Res> get trip {
  
  return $MatchTripCopyWith<$Res>(_self.trip, (value) {
    return _then(_self.copyWith(trip: value));
  });
}/// Create a copy of Match
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MatchDriverCopyWith<$Res> get driver {
  
  return $MatchDriverCopyWith<$Res>(_self.driver, (value) {
    return _then(_self.copyWith(driver: value));
  });
}
}


/// Adds pattern-matching-related methods to [Match].
extension MatchPatterns on Match {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Match value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Match() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Match value)  $default,){
final _that = this;
switch (_that) {
case _Match():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Match value)?  $default,){
final _that = this;
switch (_that) {
case _Match() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MatchTrip trip,  MatchDriver driver,  int pickupDistanceM,  int dropoffDistanceM,  double score)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Match() when $default != null:
return $default(_that.trip,_that.driver,_that.pickupDistanceM,_that.dropoffDistanceM,_that.score);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MatchTrip trip,  MatchDriver driver,  int pickupDistanceM,  int dropoffDistanceM,  double score)  $default,) {final _that = this;
switch (_that) {
case _Match():
return $default(_that.trip,_that.driver,_that.pickupDistanceM,_that.dropoffDistanceM,_that.score);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MatchTrip trip,  MatchDriver driver,  int pickupDistanceM,  int dropoffDistanceM,  double score)?  $default,) {final _that = this;
switch (_that) {
case _Match() when $default != null:
return $default(_that.trip,_that.driver,_that.pickupDistanceM,_that.dropoffDistanceM,_that.score);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Match implements Match {
  const _Match({required this.trip, required this.driver, required this.pickupDistanceM, required this.dropoffDistanceM, required this.score});
  factory _Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);

@override final  MatchTrip trip;
@override final  MatchDriver driver;
@override final  int pickupDistanceM;
@override final  int dropoffDistanceM;
@override final  double score;

/// Create a copy of Match
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchCopyWith<_Match> get copyWith => __$MatchCopyWithImpl<_Match>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Match&&(identical(other.trip, trip) || other.trip == trip)&&(identical(other.driver, driver) || other.driver == driver)&&(identical(other.pickupDistanceM, pickupDistanceM) || other.pickupDistanceM == pickupDistanceM)&&(identical(other.dropoffDistanceM, dropoffDistanceM) || other.dropoffDistanceM == dropoffDistanceM)&&(identical(other.score, score) || other.score == score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,trip,driver,pickupDistanceM,dropoffDistanceM,score);

@override
String toString() {
  return 'Match(trip: $trip, driver: $driver, pickupDistanceM: $pickupDistanceM, dropoffDistanceM: $dropoffDistanceM, score: $score)';
}


}

/// @nodoc
abstract mixin class _$MatchCopyWith<$Res> implements $MatchCopyWith<$Res> {
  factory _$MatchCopyWith(_Match value, $Res Function(_Match) _then) = __$MatchCopyWithImpl;
@override @useResult
$Res call({
 MatchTrip trip, MatchDriver driver, int pickupDistanceM, int dropoffDistanceM, double score
});


@override $MatchTripCopyWith<$Res> get trip;@override $MatchDriverCopyWith<$Res> get driver;

}
/// @nodoc
class __$MatchCopyWithImpl<$Res>
    implements _$MatchCopyWith<$Res> {
  __$MatchCopyWithImpl(this._self, this._then);

  final _Match _self;
  final $Res Function(_Match) _then;

/// Create a copy of Match
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trip = null,Object? driver = null,Object? pickupDistanceM = null,Object? dropoffDistanceM = null,Object? score = null,}) {
  return _then(_Match(
trip: null == trip ? _self.trip : trip // ignore: cast_nullable_to_non_nullable
as MatchTrip,driver: null == driver ? _self.driver : driver // ignore: cast_nullable_to_non_nullable
as MatchDriver,pickupDistanceM: null == pickupDistanceM ? _self.pickupDistanceM : pickupDistanceM // ignore: cast_nullable_to_non_nullable
as int,dropoffDistanceM: null == dropoffDistanceM ? _self.dropoffDistanceM : dropoffDistanceM // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of Match
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MatchTripCopyWith<$Res> get trip {
  
  return $MatchTripCopyWith<$Res>(_self.trip, (value) {
    return _then(_self.copyWith(trip: value));
  });
}/// Create a copy of Match
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MatchDriverCopyWith<$Res> get driver {
  
  return $MatchDriverCopyWith<$Res>(_self.driver, (value) {
    return _then(_self.copyWith(driver: value));
  });
}
}


/// @nodoc
mixin _$MatchTrip {

 int get id; String get originLabel; String get destLabel; String get departureTime; String get arrivalTime; int get durationMinutes; int get pricePerSeat;/// Pour LA date cherchée — jamais recalculé côté app.
 int get seatsLeft;
/// Create a copy of MatchTrip
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchTripCopyWith<MatchTrip> get copyWith => _$MatchTripCopyWithImpl<MatchTrip>(this as MatchTrip, _$identity);

  /// Serializes this MatchTrip to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchTrip&&(identical(other.id, id) || other.id == id)&&(identical(other.originLabel, originLabel) || other.originLabel == originLabel)&&(identical(other.destLabel, destLabel) || other.destLabel == destLabel)&&(identical(other.departureTime, departureTime) || other.departureTime == departureTime)&&(identical(other.arrivalTime, arrivalTime) || other.arrivalTime == arrivalTime)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.pricePerSeat, pricePerSeat) || other.pricePerSeat == pricePerSeat)&&(identical(other.seatsLeft, seatsLeft) || other.seatsLeft == seatsLeft));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,originLabel,destLabel,departureTime,arrivalTime,durationMinutes,pricePerSeat,seatsLeft);

@override
String toString() {
  return 'MatchTrip(id: $id, originLabel: $originLabel, destLabel: $destLabel, departureTime: $departureTime, arrivalTime: $arrivalTime, durationMinutes: $durationMinutes, pricePerSeat: $pricePerSeat, seatsLeft: $seatsLeft)';
}


}

/// @nodoc
abstract mixin class $MatchTripCopyWith<$Res>  {
  factory $MatchTripCopyWith(MatchTrip value, $Res Function(MatchTrip) _then) = _$MatchTripCopyWithImpl;
@useResult
$Res call({
 int id, String originLabel, String destLabel, String departureTime, String arrivalTime, int durationMinutes, int pricePerSeat, int seatsLeft
});




}
/// @nodoc
class _$MatchTripCopyWithImpl<$Res>
    implements $MatchTripCopyWith<$Res> {
  _$MatchTripCopyWithImpl(this._self, this._then);

  final MatchTrip _self;
  final $Res Function(MatchTrip) _then;

/// Create a copy of MatchTrip
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? originLabel = null,Object? destLabel = null,Object? departureTime = null,Object? arrivalTime = null,Object? durationMinutes = null,Object? pricePerSeat = null,Object? seatsLeft = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,originLabel: null == originLabel ? _self.originLabel : originLabel // ignore: cast_nullable_to_non_nullable
as String,destLabel: null == destLabel ? _self.destLabel : destLabel // ignore: cast_nullable_to_non_nullable
as String,departureTime: null == departureTime ? _self.departureTime : departureTime // ignore: cast_nullable_to_non_nullable
as String,arrivalTime: null == arrivalTime ? _self.arrivalTime : arrivalTime // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,pricePerSeat: null == pricePerSeat ? _self.pricePerSeat : pricePerSeat // ignore: cast_nullable_to_non_nullable
as int,seatsLeft: null == seatsLeft ? _self.seatsLeft : seatsLeft // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MatchTrip].
extension MatchTripPatterns on MatchTrip {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchTrip value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchTrip() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchTrip value)  $default,){
final _that = this;
switch (_that) {
case _MatchTrip():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchTrip value)?  $default,){
final _that = this;
switch (_that) {
case _MatchTrip() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String originLabel,  String destLabel,  String departureTime,  String arrivalTime,  int durationMinutes,  int pricePerSeat,  int seatsLeft)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchTrip() when $default != null:
return $default(_that.id,_that.originLabel,_that.destLabel,_that.departureTime,_that.arrivalTime,_that.durationMinutes,_that.pricePerSeat,_that.seatsLeft);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String originLabel,  String destLabel,  String departureTime,  String arrivalTime,  int durationMinutes,  int pricePerSeat,  int seatsLeft)  $default,) {final _that = this;
switch (_that) {
case _MatchTrip():
return $default(_that.id,_that.originLabel,_that.destLabel,_that.departureTime,_that.arrivalTime,_that.durationMinutes,_that.pricePerSeat,_that.seatsLeft);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String originLabel,  String destLabel,  String departureTime,  String arrivalTime,  int durationMinutes,  int pricePerSeat,  int seatsLeft)?  $default,) {final _that = this;
switch (_that) {
case _MatchTrip() when $default != null:
return $default(_that.id,_that.originLabel,_that.destLabel,_that.departureTime,_that.arrivalTime,_that.durationMinutes,_that.pricePerSeat,_that.seatsLeft);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MatchTrip implements MatchTrip {
  const _MatchTrip({required this.id, required this.originLabel, required this.destLabel, required this.departureTime, required this.arrivalTime, required this.durationMinutes, required this.pricePerSeat, required this.seatsLeft});
  factory _MatchTrip.fromJson(Map<String, dynamic> json) => _$MatchTripFromJson(json);

@override final  int id;
@override final  String originLabel;
@override final  String destLabel;
@override final  String departureTime;
@override final  String arrivalTime;
@override final  int durationMinutes;
@override final  int pricePerSeat;
/// Pour LA date cherchée — jamais recalculé côté app.
@override final  int seatsLeft;

/// Create a copy of MatchTrip
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchTripCopyWith<_MatchTrip> get copyWith => __$MatchTripCopyWithImpl<_MatchTrip>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchTripToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchTrip&&(identical(other.id, id) || other.id == id)&&(identical(other.originLabel, originLabel) || other.originLabel == originLabel)&&(identical(other.destLabel, destLabel) || other.destLabel == destLabel)&&(identical(other.departureTime, departureTime) || other.departureTime == departureTime)&&(identical(other.arrivalTime, arrivalTime) || other.arrivalTime == arrivalTime)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.pricePerSeat, pricePerSeat) || other.pricePerSeat == pricePerSeat)&&(identical(other.seatsLeft, seatsLeft) || other.seatsLeft == seatsLeft));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,originLabel,destLabel,departureTime,arrivalTime,durationMinutes,pricePerSeat,seatsLeft);

@override
String toString() {
  return 'MatchTrip(id: $id, originLabel: $originLabel, destLabel: $destLabel, departureTime: $departureTime, arrivalTime: $arrivalTime, durationMinutes: $durationMinutes, pricePerSeat: $pricePerSeat, seatsLeft: $seatsLeft)';
}


}

/// @nodoc
abstract mixin class _$MatchTripCopyWith<$Res> implements $MatchTripCopyWith<$Res> {
  factory _$MatchTripCopyWith(_MatchTrip value, $Res Function(_MatchTrip) _then) = __$MatchTripCopyWithImpl;
@override @useResult
$Res call({
 int id, String originLabel, String destLabel, String departureTime, String arrivalTime, int durationMinutes, int pricePerSeat, int seatsLeft
});




}
/// @nodoc
class __$MatchTripCopyWithImpl<$Res>
    implements _$MatchTripCopyWith<$Res> {
  __$MatchTripCopyWithImpl(this._self, this._then);

  final _MatchTrip _self;
  final $Res Function(_MatchTrip) _then;

/// Create a copy of MatchTrip
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? originLabel = null,Object? destLabel = null,Object? departureTime = null,Object? arrivalTime = null,Object? durationMinutes = null,Object? pricePerSeat = null,Object? seatsLeft = null,}) {
  return _then(_MatchTrip(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,originLabel: null == originLabel ? _self.originLabel : originLabel // ignore: cast_nullable_to_non_nullable
as String,destLabel: null == destLabel ? _self.destLabel : destLabel // ignore: cast_nullable_to_non_nullable
as String,departureTime: null == departureTime ? _self.departureTime : departureTime // ignore: cast_nullable_to_non_nullable
as String,arrivalTime: null == arrivalTime ? _self.arrivalTime : arrivalTime // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,pricePerSeat: null == pricePerSeat ? _self.pricePerSeat : pricePerSeat // ignore: cast_nullable_to_non_nullable
as int,seatsLeft: null == seatsLeft ? _self.seatsLeft : seatsLeft // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MatchDriver {

 int get id; String get firstName; String get lastName; String? get photoUrl; double get rating; int get ratingCount; int get tripsCompleted; List<String> get badges;
/// Create a copy of MatchDriver
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchDriverCopyWith<MatchDriver> get copyWith => _$MatchDriverCopyWithImpl<MatchDriver>(this as MatchDriver, _$identity);

  /// Serializes this MatchDriver to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchDriver&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.tripsCompleted, tripsCompleted) || other.tripsCompleted == tripsCompleted)&&const DeepCollectionEquality().equals(other.badges, badges));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,photoUrl,rating,ratingCount,tripsCompleted,const DeepCollectionEquality().hash(badges));

@override
String toString() {
  return 'MatchDriver(id: $id, firstName: $firstName, lastName: $lastName, photoUrl: $photoUrl, rating: $rating, ratingCount: $ratingCount, tripsCompleted: $tripsCompleted, badges: $badges)';
}


}

/// @nodoc
abstract mixin class $MatchDriverCopyWith<$Res>  {
  factory $MatchDriverCopyWith(MatchDriver value, $Res Function(MatchDriver) _then) = _$MatchDriverCopyWithImpl;
@useResult
$Res call({
 int id, String firstName, String lastName, String? photoUrl, double rating, int ratingCount, int tripsCompleted, List<String> badges
});




}
/// @nodoc
class _$MatchDriverCopyWithImpl<$Res>
    implements $MatchDriverCopyWith<$Res> {
  _$MatchDriverCopyWithImpl(this._self, this._then);

  final MatchDriver _self;
  final $Res Function(MatchDriver) _then;

/// Create a copy of MatchDriver
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? photoUrl = freezed,Object? rating = null,Object? ratingCount = null,Object? tripsCompleted = null,Object? badges = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,tripsCompleted: null == tripsCompleted ? _self.tripsCompleted : tripsCompleted // ignore: cast_nullable_to_non_nullable
as int,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [MatchDriver].
extension MatchDriverPatterns on MatchDriver {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchDriver value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchDriver() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchDriver value)  $default,){
final _that = this;
switch (_that) {
case _MatchDriver():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchDriver value)?  $default,){
final _that = this;
switch (_that) {
case _MatchDriver() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String firstName,  String lastName,  String? photoUrl,  double rating,  int ratingCount,  int tripsCompleted,  List<String> badges)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchDriver() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.photoUrl,_that.rating,_that.ratingCount,_that.tripsCompleted,_that.badges);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String firstName,  String lastName,  String? photoUrl,  double rating,  int ratingCount,  int tripsCompleted,  List<String> badges)  $default,) {final _that = this;
switch (_that) {
case _MatchDriver():
return $default(_that.id,_that.firstName,_that.lastName,_that.photoUrl,_that.rating,_that.ratingCount,_that.tripsCompleted,_that.badges);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String firstName,  String lastName,  String? photoUrl,  double rating,  int ratingCount,  int tripsCompleted,  List<String> badges)?  $default,) {final _that = this;
switch (_that) {
case _MatchDriver() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.photoUrl,_that.rating,_that.ratingCount,_that.tripsCompleted,_that.badges);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MatchDriver implements MatchDriver {
  const _MatchDriver({required this.id, required this.firstName, required this.lastName, this.photoUrl, this.rating = 0, this.ratingCount = 0, this.tripsCompleted = 0, final  List<String> badges = const []}): _badges = badges;
  factory _MatchDriver.fromJson(Map<String, dynamic> json) => _$MatchDriverFromJson(json);

@override final  int id;
@override final  String firstName;
@override final  String lastName;
@override final  String? photoUrl;
@override@JsonKey() final  double rating;
@override@JsonKey() final  int ratingCount;
@override@JsonKey() final  int tripsCompleted;
 final  List<String> _badges;
@override@JsonKey() List<String> get badges {
  if (_badges is EqualUnmodifiableListView) return _badges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_badges);
}


/// Create a copy of MatchDriver
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchDriverCopyWith<_MatchDriver> get copyWith => __$MatchDriverCopyWithImpl<_MatchDriver>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchDriverToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchDriver&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.tripsCompleted, tripsCompleted) || other.tripsCompleted == tripsCompleted)&&const DeepCollectionEquality().equals(other._badges, _badges));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,photoUrl,rating,ratingCount,tripsCompleted,const DeepCollectionEquality().hash(_badges));

@override
String toString() {
  return 'MatchDriver(id: $id, firstName: $firstName, lastName: $lastName, photoUrl: $photoUrl, rating: $rating, ratingCount: $ratingCount, tripsCompleted: $tripsCompleted, badges: $badges)';
}


}

/// @nodoc
abstract mixin class _$MatchDriverCopyWith<$Res> implements $MatchDriverCopyWith<$Res> {
  factory _$MatchDriverCopyWith(_MatchDriver value, $Res Function(_MatchDriver) _then) = __$MatchDriverCopyWithImpl;
@override @useResult
$Res call({
 int id, String firstName, String lastName, String? photoUrl, double rating, int ratingCount, int tripsCompleted, List<String> badges
});




}
/// @nodoc
class __$MatchDriverCopyWithImpl<$Res>
    implements _$MatchDriverCopyWith<$Res> {
  __$MatchDriverCopyWithImpl(this._self, this._then);

  final _MatchDriver _self;
  final $Res Function(_MatchDriver) _then;

/// Create a copy of MatchDriver
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? photoUrl = freezed,Object? rating = null,Object? ratingCount = null,Object? tripsCompleted = null,Object? badges = null,}) {
  return _then(_MatchDriver(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,tripsCompleted: null == tripsCompleted ? _self.tripsCompleted : tripsCompleted // ignore: cast_nullable_to_non_nullable
as int,badges: null == badges ? _self._badges : badges // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
