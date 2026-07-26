// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Booking {

 int get id; String get date; String get status; int get seats; int get pricePaid; BookingTrip get trip; BookingParty get driver; BookingParty? get rider;
/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingCopyWith<Booking> get copyWith => _$BookingCopyWithImpl<Booking>(this as Booking, _$identity);

  /// Serializes this Booking to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Booking&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.seats, seats) || other.seats == seats)&&(identical(other.pricePaid, pricePaid) || other.pricePaid == pricePaid)&&(identical(other.trip, trip) || other.trip == trip)&&(identical(other.driver, driver) || other.driver == driver)&&(identical(other.rider, rider) || other.rider == rider));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,status,seats,pricePaid,trip,driver,rider);

@override
String toString() {
  return 'Booking(id: $id, date: $date, status: $status, seats: $seats, pricePaid: $pricePaid, trip: $trip, driver: $driver, rider: $rider)';
}


}

/// @nodoc
abstract mixin class $BookingCopyWith<$Res>  {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) _then) = _$BookingCopyWithImpl;
@useResult
$Res call({
 int id, String date, String status, int seats, int pricePaid, BookingTrip trip, BookingParty driver, BookingParty? rider
});


$BookingTripCopyWith<$Res> get trip;$BookingPartyCopyWith<$Res> get driver;$BookingPartyCopyWith<$Res>? get rider;

}
/// @nodoc
class _$BookingCopyWithImpl<$Res>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._self, this._then);

  final Booking _self;
  final $Res Function(Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? status = null,Object? seats = null,Object? pricePaid = null,Object? trip = null,Object? driver = null,Object? rider = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,seats: null == seats ? _self.seats : seats // ignore: cast_nullable_to_non_nullable
as int,pricePaid: null == pricePaid ? _self.pricePaid : pricePaid // ignore: cast_nullable_to_non_nullable
as int,trip: null == trip ? _self.trip : trip // ignore: cast_nullable_to_non_nullable
as BookingTrip,driver: null == driver ? _self.driver : driver // ignore: cast_nullable_to_non_nullable
as BookingParty,rider: freezed == rider ? _self.rider : rider // ignore: cast_nullable_to_non_nullable
as BookingParty?,
  ));
}
/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingTripCopyWith<$Res> get trip {
  
  return $BookingTripCopyWith<$Res>(_self.trip, (value) {
    return _then(_self.copyWith(trip: value));
  });
}/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingPartyCopyWith<$Res> get driver {
  
  return $BookingPartyCopyWith<$Res>(_self.driver, (value) {
    return _then(_self.copyWith(driver: value));
  });
}/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingPartyCopyWith<$Res>? get rider {
    if (_self.rider == null) {
    return null;
  }

  return $BookingPartyCopyWith<$Res>(_self.rider!, (value) {
    return _then(_self.copyWith(rider: value));
  });
}
}


/// Adds pattern-matching-related methods to [Booking].
extension BookingPatterns on Booking {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Booking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Booking value)  $default,){
final _that = this;
switch (_that) {
case _Booking():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Booking value)?  $default,){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String date,  String status,  int seats,  int pricePaid,  BookingTrip trip,  BookingParty driver,  BookingParty? rider)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.date,_that.status,_that.seats,_that.pricePaid,_that.trip,_that.driver,_that.rider);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String date,  String status,  int seats,  int pricePaid,  BookingTrip trip,  BookingParty driver,  BookingParty? rider)  $default,) {final _that = this;
switch (_that) {
case _Booking():
return $default(_that.id,_that.date,_that.status,_that.seats,_that.pricePaid,_that.trip,_that.driver,_that.rider);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String date,  String status,  int seats,  int pricePaid,  BookingTrip trip,  BookingParty driver,  BookingParty? rider)?  $default,) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.date,_that.status,_that.seats,_that.pricePaid,_that.trip,_that.driver,_that.rider);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Booking implements Booking {
  const _Booking({required this.id, required this.date, required this.status, required this.seats, required this.pricePaid, required this.trip, required this.driver, this.rider});
  factory _Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);

@override final  int id;
@override final  String date;
@override final  String status;
@override final  int seats;
@override final  int pricePaid;
@override final  BookingTrip trip;
@override final  BookingParty driver;
@override final  BookingParty? rider;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingCopyWith<_Booking> get copyWith => __$BookingCopyWithImpl<_Booking>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Booking&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.seats, seats) || other.seats == seats)&&(identical(other.pricePaid, pricePaid) || other.pricePaid == pricePaid)&&(identical(other.trip, trip) || other.trip == trip)&&(identical(other.driver, driver) || other.driver == driver)&&(identical(other.rider, rider) || other.rider == rider));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,status,seats,pricePaid,trip,driver,rider);

@override
String toString() {
  return 'Booking(id: $id, date: $date, status: $status, seats: $seats, pricePaid: $pricePaid, trip: $trip, driver: $driver, rider: $rider)';
}


}

/// @nodoc
abstract mixin class _$BookingCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$BookingCopyWith(_Booking value, $Res Function(_Booking) _then) = __$BookingCopyWithImpl;
@override @useResult
$Res call({
 int id, String date, String status, int seats, int pricePaid, BookingTrip trip, BookingParty driver, BookingParty? rider
});


@override $BookingTripCopyWith<$Res> get trip;@override $BookingPartyCopyWith<$Res> get driver;@override $BookingPartyCopyWith<$Res>? get rider;

}
/// @nodoc
class __$BookingCopyWithImpl<$Res>
    implements _$BookingCopyWith<$Res> {
  __$BookingCopyWithImpl(this._self, this._then);

  final _Booking _self;
  final $Res Function(_Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? status = null,Object? seats = null,Object? pricePaid = null,Object? trip = null,Object? driver = null,Object? rider = freezed,}) {
  return _then(_Booking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,seats: null == seats ? _self.seats : seats // ignore: cast_nullable_to_non_nullable
as int,pricePaid: null == pricePaid ? _self.pricePaid : pricePaid // ignore: cast_nullable_to_non_nullable
as int,trip: null == trip ? _self.trip : trip // ignore: cast_nullable_to_non_nullable
as BookingTrip,driver: null == driver ? _self.driver : driver // ignore: cast_nullable_to_non_nullable
as BookingParty,rider: freezed == rider ? _self.rider : rider // ignore: cast_nullable_to_non_nullable
as BookingParty?,
  ));
}

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingTripCopyWith<$Res> get trip {
  
  return $BookingTripCopyWith<$Res>(_self.trip, (value) {
    return _then(_self.copyWith(trip: value));
  });
}/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingPartyCopyWith<$Res> get driver {
  
  return $BookingPartyCopyWith<$Res>(_self.driver, (value) {
    return _then(_self.copyWith(driver: value));
  });
}/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingPartyCopyWith<$Res>? get rider {
    if (_self.rider == null) {
    return null;
  }

  return $BookingPartyCopyWith<$Res>(_self.rider!, (value) {
    return _then(_self.copyWith(rider: value));
  });
}
}


/// @nodoc
mixin _$BookingTrip {

 int get id; String get originLabel; String get destLabel; String get departureTime; int get durationMinutes;
/// Create a copy of BookingTrip
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingTripCopyWith<BookingTrip> get copyWith => _$BookingTripCopyWithImpl<BookingTrip>(this as BookingTrip, _$identity);

  /// Serializes this BookingTrip to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingTrip&&(identical(other.id, id) || other.id == id)&&(identical(other.originLabel, originLabel) || other.originLabel == originLabel)&&(identical(other.destLabel, destLabel) || other.destLabel == destLabel)&&(identical(other.departureTime, departureTime) || other.departureTime == departureTime)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,originLabel,destLabel,departureTime,durationMinutes);

@override
String toString() {
  return 'BookingTrip(id: $id, originLabel: $originLabel, destLabel: $destLabel, departureTime: $departureTime, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class $BookingTripCopyWith<$Res>  {
  factory $BookingTripCopyWith(BookingTrip value, $Res Function(BookingTrip) _then) = _$BookingTripCopyWithImpl;
@useResult
$Res call({
 int id, String originLabel, String destLabel, String departureTime, int durationMinutes
});




}
/// @nodoc
class _$BookingTripCopyWithImpl<$Res>
    implements $BookingTripCopyWith<$Res> {
  _$BookingTripCopyWithImpl(this._self, this._then);

  final BookingTrip _self;
  final $Res Function(BookingTrip) _then;

/// Create a copy of BookingTrip
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? originLabel = null,Object? destLabel = null,Object? departureTime = null,Object? durationMinutes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,originLabel: null == originLabel ? _self.originLabel : originLabel // ignore: cast_nullable_to_non_nullable
as String,destLabel: null == destLabel ? _self.destLabel : destLabel // ignore: cast_nullable_to_non_nullable
as String,departureTime: null == departureTime ? _self.departureTime : departureTime // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingTrip].
extension BookingTripPatterns on BookingTrip {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingTrip value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingTrip() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingTrip value)  $default,){
final _that = this;
switch (_that) {
case _BookingTrip():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingTrip value)?  $default,){
final _that = this;
switch (_that) {
case _BookingTrip() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String originLabel,  String destLabel,  String departureTime,  int durationMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingTrip() when $default != null:
return $default(_that.id,_that.originLabel,_that.destLabel,_that.departureTime,_that.durationMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String originLabel,  String destLabel,  String departureTime,  int durationMinutes)  $default,) {final _that = this;
switch (_that) {
case _BookingTrip():
return $default(_that.id,_that.originLabel,_that.destLabel,_that.departureTime,_that.durationMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String originLabel,  String destLabel,  String departureTime,  int durationMinutes)?  $default,) {final _that = this;
switch (_that) {
case _BookingTrip() when $default != null:
return $default(_that.id,_that.originLabel,_that.destLabel,_that.departureTime,_that.durationMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingTrip implements BookingTrip {
  const _BookingTrip({required this.id, required this.originLabel, required this.destLabel, required this.departureTime, required this.durationMinutes});
  factory _BookingTrip.fromJson(Map<String, dynamic> json) => _$BookingTripFromJson(json);

@override final  int id;
@override final  String originLabel;
@override final  String destLabel;
@override final  String departureTime;
@override final  int durationMinutes;

/// Create a copy of BookingTrip
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingTripCopyWith<_BookingTrip> get copyWith => __$BookingTripCopyWithImpl<_BookingTrip>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingTripToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingTrip&&(identical(other.id, id) || other.id == id)&&(identical(other.originLabel, originLabel) || other.originLabel == originLabel)&&(identical(other.destLabel, destLabel) || other.destLabel == destLabel)&&(identical(other.departureTime, departureTime) || other.departureTime == departureTime)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,originLabel,destLabel,departureTime,durationMinutes);

@override
String toString() {
  return 'BookingTrip(id: $id, originLabel: $originLabel, destLabel: $destLabel, departureTime: $departureTime, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class _$BookingTripCopyWith<$Res> implements $BookingTripCopyWith<$Res> {
  factory _$BookingTripCopyWith(_BookingTrip value, $Res Function(_BookingTrip) _then) = __$BookingTripCopyWithImpl;
@override @useResult
$Res call({
 int id, String originLabel, String destLabel, String departureTime, int durationMinutes
});




}
/// @nodoc
class __$BookingTripCopyWithImpl<$Res>
    implements _$BookingTripCopyWith<$Res> {
  __$BookingTripCopyWithImpl(this._self, this._then);

  final _BookingTrip _self;
  final $Res Function(_BookingTrip) _then;

/// Create a copy of BookingTrip
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? originLabel = null,Object? destLabel = null,Object? departureTime = null,Object? durationMinutes = null,}) {
  return _then(_BookingTrip(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,originLabel: null == originLabel ? _self.originLabel : originLabel // ignore: cast_nullable_to_non_nullable
as String,destLabel: null == destLabel ? _self.destLabel : destLabel // ignore: cast_nullable_to_non_nullable
as String,departureTime: null == departureTime ? _self.departureTime : departureTime // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BookingParty {

 int get id; String get firstName; String get lastName; String? get photoUrl; double get rating; int get ratingCount; int get tripsCompleted;/// Présent seulement quand la réservation est acceptée.
 String? get phone;
/// Create a copy of BookingParty
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingPartyCopyWith<BookingParty> get copyWith => _$BookingPartyCopyWithImpl<BookingParty>(this as BookingParty, _$identity);

  /// Serializes this BookingParty to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingParty&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.tripsCompleted, tripsCompleted) || other.tripsCompleted == tripsCompleted)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,photoUrl,rating,ratingCount,tripsCompleted,phone);

@override
String toString() {
  return 'BookingParty(id: $id, firstName: $firstName, lastName: $lastName, photoUrl: $photoUrl, rating: $rating, ratingCount: $ratingCount, tripsCompleted: $tripsCompleted, phone: $phone)';
}


}

/// @nodoc
abstract mixin class $BookingPartyCopyWith<$Res>  {
  factory $BookingPartyCopyWith(BookingParty value, $Res Function(BookingParty) _then) = _$BookingPartyCopyWithImpl;
@useResult
$Res call({
 int id, String firstName, String lastName, String? photoUrl, double rating, int ratingCount, int tripsCompleted, String? phone
});




}
/// @nodoc
class _$BookingPartyCopyWithImpl<$Res>
    implements $BookingPartyCopyWith<$Res> {
  _$BookingPartyCopyWithImpl(this._self, this._then);

  final BookingParty _self;
  final $Res Function(BookingParty) _then;

/// Create a copy of BookingParty
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? photoUrl = freezed,Object? rating = null,Object? ratingCount = null,Object? tripsCompleted = null,Object? phone = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,tripsCompleted: null == tripsCompleted ? _self.tripsCompleted : tripsCompleted // ignore: cast_nullable_to_non_nullable
as int,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingParty].
extension BookingPartyPatterns on BookingParty {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingParty value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingParty() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingParty value)  $default,){
final _that = this;
switch (_that) {
case _BookingParty():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingParty value)?  $default,){
final _that = this;
switch (_that) {
case _BookingParty() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String firstName,  String lastName,  String? photoUrl,  double rating,  int ratingCount,  int tripsCompleted,  String? phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingParty() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.photoUrl,_that.rating,_that.ratingCount,_that.tripsCompleted,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String firstName,  String lastName,  String? photoUrl,  double rating,  int ratingCount,  int tripsCompleted,  String? phone)  $default,) {final _that = this;
switch (_that) {
case _BookingParty():
return $default(_that.id,_that.firstName,_that.lastName,_that.photoUrl,_that.rating,_that.ratingCount,_that.tripsCompleted,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String firstName,  String lastName,  String? photoUrl,  double rating,  int ratingCount,  int tripsCompleted,  String? phone)?  $default,) {final _that = this;
switch (_that) {
case _BookingParty() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.photoUrl,_that.rating,_that.ratingCount,_that.tripsCompleted,_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingParty implements BookingParty {
  const _BookingParty({required this.id, required this.firstName, required this.lastName, this.photoUrl, this.rating = 0, this.ratingCount = 0, this.tripsCompleted = 0, this.phone});
  factory _BookingParty.fromJson(Map<String, dynamic> json) => _$BookingPartyFromJson(json);

@override final  int id;
@override final  String firstName;
@override final  String lastName;
@override final  String? photoUrl;
@override@JsonKey() final  double rating;
@override@JsonKey() final  int ratingCount;
@override@JsonKey() final  int tripsCompleted;
/// Présent seulement quand la réservation est acceptée.
@override final  String? phone;

/// Create a copy of BookingParty
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingPartyCopyWith<_BookingParty> get copyWith => __$BookingPartyCopyWithImpl<_BookingParty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingPartyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingParty&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.tripsCompleted, tripsCompleted) || other.tripsCompleted == tripsCompleted)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,photoUrl,rating,ratingCount,tripsCompleted,phone);

@override
String toString() {
  return 'BookingParty(id: $id, firstName: $firstName, lastName: $lastName, photoUrl: $photoUrl, rating: $rating, ratingCount: $ratingCount, tripsCompleted: $tripsCompleted, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$BookingPartyCopyWith<$Res> implements $BookingPartyCopyWith<$Res> {
  factory _$BookingPartyCopyWith(_BookingParty value, $Res Function(_BookingParty) _then) = __$BookingPartyCopyWithImpl;
@override @useResult
$Res call({
 int id, String firstName, String lastName, String? photoUrl, double rating, int ratingCount, int tripsCompleted, String? phone
});




}
/// @nodoc
class __$BookingPartyCopyWithImpl<$Res>
    implements _$BookingPartyCopyWith<$Res> {
  __$BookingPartyCopyWithImpl(this._self, this._then);

  final _BookingParty _self;
  final $Res Function(_BookingParty) _then;

/// Create a copy of BookingParty
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? photoUrl = freezed,Object? rating = null,Object? ratingCount = null,Object? tripsCompleted = null,Object? phone = freezed,}) {
  return _then(_BookingParty(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,tripsCompleted: null == tripsCompleted ? _self.tripsCompleted : tripsCompleted // ignore: cast_nullable_to_non_nullable
as int,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
