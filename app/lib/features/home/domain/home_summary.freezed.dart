// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeSummary {

 NextRide? get next;
/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeSummaryCopyWith<HomeSummary> get copyWith => _$HomeSummaryCopyWithImpl<HomeSummary>(this as HomeSummary, _$identity);

  /// Serializes this HomeSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeSummary&&(identical(other.next, next) || other.next == next));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,next);

@override
String toString() {
  return 'HomeSummary(next: $next)';
}


}

/// @nodoc
abstract mixin class $HomeSummaryCopyWith<$Res>  {
  factory $HomeSummaryCopyWith(HomeSummary value, $Res Function(HomeSummary) _then) = _$HomeSummaryCopyWithImpl;
@useResult
$Res call({
 NextRide? next
});


$NextRideCopyWith<$Res>? get next;

}
/// @nodoc
class _$HomeSummaryCopyWithImpl<$Res>
    implements $HomeSummaryCopyWith<$Res> {
  _$HomeSummaryCopyWithImpl(this._self, this._then);

  final HomeSummary _self;
  final $Res Function(HomeSummary) _then;

/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? next = freezed,}) {
  return _then(_self.copyWith(
next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as NextRide?,
  ));
}
/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NextRideCopyWith<$Res>? get next {
    if (_self.next == null) {
    return null;
  }

  return $NextRideCopyWith<$Res>(_self.next!, (value) {
    return _then(_self.copyWith(next: value));
  });
}
}


/// Adds pattern-matching-related methods to [HomeSummary].
extension HomeSummaryPatterns on HomeSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeSummary value)  $default,){
final _that = this;
switch (_that) {
case _HomeSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeSummary value)?  $default,){
final _that = this;
switch (_that) {
case _HomeSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NextRide? next)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeSummary() when $default != null:
return $default(_that.next);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NextRide? next)  $default,) {final _that = this;
switch (_that) {
case _HomeSummary():
return $default(_that.next);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NextRide? next)?  $default,) {final _that = this;
switch (_that) {
case _HomeSummary() when $default != null:
return $default(_that.next);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeSummary implements HomeSummary {
  const _HomeSummary({this.next});
  factory _HomeSummary.fromJson(Map<String, dynamic> json) => _$HomeSummaryFromJson(json);

@override final  NextRide? next;

/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeSummaryCopyWith<_HomeSummary> get copyWith => __$HomeSummaryCopyWithImpl<_HomeSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeSummary&&(identical(other.next, next) || other.next == next));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,next);

@override
String toString() {
  return 'HomeSummary(next: $next)';
}


}

/// @nodoc
abstract mixin class _$HomeSummaryCopyWith<$Res> implements $HomeSummaryCopyWith<$Res> {
  factory _$HomeSummaryCopyWith(_HomeSummary value, $Res Function(_HomeSummary) _then) = __$HomeSummaryCopyWithImpl;
@override @useResult
$Res call({
 NextRide? next
});


@override $NextRideCopyWith<$Res>? get next;

}
/// @nodoc
class __$HomeSummaryCopyWithImpl<$Res>
    implements _$HomeSummaryCopyWith<$Res> {
  __$HomeSummaryCopyWithImpl(this._self, this._then);

  final _HomeSummary _self;
  final $Res Function(_HomeSummary) _then;

/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? next = freezed,}) {
  return _then(_HomeSummary(
next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as NextRide?,
  ));
}

/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NextRideCopyWith<$Res>? get next {
    if (_self.next == null) {
    return null;
  }

  return $NextRideCopyWith<$Res>(_self.next!, (value) {
    return _then(_self.copyWith(next: value));
  });
}
}


/// @nodoc
mixin _$NextRide {

 String get role; String get date; String get departureTime; String get originLabel; String get destLabel; int? get price;@JsonKey(name: 'with') NextRidePartner? get partner; int? get seatsTaken; int? get seatsTotal;
/// Create a copy of NextRide
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NextRideCopyWith<NextRide> get copyWith => _$NextRideCopyWithImpl<NextRide>(this as NextRide, _$identity);

  /// Serializes this NextRide to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NextRide&&(identical(other.role, role) || other.role == role)&&(identical(other.date, date) || other.date == date)&&(identical(other.departureTime, departureTime) || other.departureTime == departureTime)&&(identical(other.originLabel, originLabel) || other.originLabel == originLabel)&&(identical(other.destLabel, destLabel) || other.destLabel == destLabel)&&(identical(other.price, price) || other.price == price)&&(identical(other.partner, partner) || other.partner == partner)&&(identical(other.seatsTaken, seatsTaken) || other.seatsTaken == seatsTaken)&&(identical(other.seatsTotal, seatsTotal) || other.seatsTotal == seatsTotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,date,departureTime,originLabel,destLabel,price,partner,seatsTaken,seatsTotal);

@override
String toString() {
  return 'NextRide(role: $role, date: $date, departureTime: $departureTime, originLabel: $originLabel, destLabel: $destLabel, price: $price, partner: $partner, seatsTaken: $seatsTaken, seatsTotal: $seatsTotal)';
}


}

/// @nodoc
abstract mixin class $NextRideCopyWith<$Res>  {
  factory $NextRideCopyWith(NextRide value, $Res Function(NextRide) _then) = _$NextRideCopyWithImpl;
@useResult
$Res call({
 String role, String date, String departureTime, String originLabel, String destLabel, int? price,@JsonKey(name: 'with') NextRidePartner? partner, int? seatsTaken, int? seatsTotal
});


$NextRidePartnerCopyWith<$Res>? get partner;

}
/// @nodoc
class _$NextRideCopyWithImpl<$Res>
    implements $NextRideCopyWith<$Res> {
  _$NextRideCopyWithImpl(this._self, this._then);

  final NextRide _self;
  final $Res Function(NextRide) _then;

/// Create a copy of NextRide
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,Object? date = null,Object? departureTime = null,Object? originLabel = null,Object? destLabel = null,Object? price = freezed,Object? partner = freezed,Object? seatsTaken = freezed,Object? seatsTotal = freezed,}) {
  return _then(_self.copyWith(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,departureTime: null == departureTime ? _self.departureTime : departureTime // ignore: cast_nullable_to_non_nullable
as String,originLabel: null == originLabel ? _self.originLabel : originLabel // ignore: cast_nullable_to_non_nullable
as String,destLabel: null == destLabel ? _self.destLabel : destLabel // ignore: cast_nullable_to_non_nullable
as String,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int?,partner: freezed == partner ? _self.partner : partner // ignore: cast_nullable_to_non_nullable
as NextRidePartner?,seatsTaken: freezed == seatsTaken ? _self.seatsTaken : seatsTaken // ignore: cast_nullable_to_non_nullable
as int?,seatsTotal: freezed == seatsTotal ? _self.seatsTotal : seatsTotal // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of NextRide
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NextRidePartnerCopyWith<$Res>? get partner {
    if (_self.partner == null) {
    return null;
  }

  return $NextRidePartnerCopyWith<$Res>(_self.partner!, (value) {
    return _then(_self.copyWith(partner: value));
  });
}
}


/// Adds pattern-matching-related methods to [NextRide].
extension NextRidePatterns on NextRide {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NextRide value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NextRide() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NextRide value)  $default,){
final _that = this;
switch (_that) {
case _NextRide():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NextRide value)?  $default,){
final _that = this;
switch (_that) {
case _NextRide() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String role,  String date,  String departureTime,  String originLabel,  String destLabel,  int? price, @JsonKey(name: 'with')  NextRidePartner? partner,  int? seatsTaken,  int? seatsTotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NextRide() when $default != null:
return $default(_that.role,_that.date,_that.departureTime,_that.originLabel,_that.destLabel,_that.price,_that.partner,_that.seatsTaken,_that.seatsTotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String role,  String date,  String departureTime,  String originLabel,  String destLabel,  int? price, @JsonKey(name: 'with')  NextRidePartner? partner,  int? seatsTaken,  int? seatsTotal)  $default,) {final _that = this;
switch (_that) {
case _NextRide():
return $default(_that.role,_that.date,_that.departureTime,_that.originLabel,_that.destLabel,_that.price,_that.partner,_that.seatsTaken,_that.seatsTotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String role,  String date,  String departureTime,  String originLabel,  String destLabel,  int? price, @JsonKey(name: 'with')  NextRidePartner? partner,  int? seatsTaken,  int? seatsTotal)?  $default,) {final _that = this;
switch (_that) {
case _NextRide() when $default != null:
return $default(_that.role,_that.date,_that.departureTime,_that.originLabel,_that.destLabel,_that.price,_that.partner,_that.seatsTaken,_that.seatsTotal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NextRide implements NextRide {
  const _NextRide({required this.role, required this.date, required this.departureTime, required this.originLabel, required this.destLabel, this.price, @JsonKey(name: 'with') this.partner, this.seatsTaken, this.seatsTotal});
  factory _NextRide.fromJson(Map<String, dynamic> json) => _$NextRideFromJson(json);

@override final  String role;
@override final  String date;
@override final  String departureTime;
@override final  String originLabel;
@override final  String destLabel;
@override final  int? price;
@override@JsonKey(name: 'with') final  NextRidePartner? partner;
@override final  int? seatsTaken;
@override final  int? seatsTotal;

/// Create a copy of NextRide
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NextRideCopyWith<_NextRide> get copyWith => __$NextRideCopyWithImpl<_NextRide>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NextRideToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NextRide&&(identical(other.role, role) || other.role == role)&&(identical(other.date, date) || other.date == date)&&(identical(other.departureTime, departureTime) || other.departureTime == departureTime)&&(identical(other.originLabel, originLabel) || other.originLabel == originLabel)&&(identical(other.destLabel, destLabel) || other.destLabel == destLabel)&&(identical(other.price, price) || other.price == price)&&(identical(other.partner, partner) || other.partner == partner)&&(identical(other.seatsTaken, seatsTaken) || other.seatsTaken == seatsTaken)&&(identical(other.seatsTotal, seatsTotal) || other.seatsTotal == seatsTotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,date,departureTime,originLabel,destLabel,price,partner,seatsTaken,seatsTotal);

@override
String toString() {
  return 'NextRide(role: $role, date: $date, departureTime: $departureTime, originLabel: $originLabel, destLabel: $destLabel, price: $price, partner: $partner, seatsTaken: $seatsTaken, seatsTotal: $seatsTotal)';
}


}

/// @nodoc
abstract mixin class _$NextRideCopyWith<$Res> implements $NextRideCopyWith<$Res> {
  factory _$NextRideCopyWith(_NextRide value, $Res Function(_NextRide) _then) = __$NextRideCopyWithImpl;
@override @useResult
$Res call({
 String role, String date, String departureTime, String originLabel, String destLabel, int? price,@JsonKey(name: 'with') NextRidePartner? partner, int? seatsTaken, int? seatsTotal
});


@override $NextRidePartnerCopyWith<$Res>? get partner;

}
/// @nodoc
class __$NextRideCopyWithImpl<$Res>
    implements _$NextRideCopyWith<$Res> {
  __$NextRideCopyWithImpl(this._self, this._then);

  final _NextRide _self;
  final $Res Function(_NextRide) _then;

/// Create a copy of NextRide
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,Object? date = null,Object? departureTime = null,Object? originLabel = null,Object? destLabel = null,Object? price = freezed,Object? partner = freezed,Object? seatsTaken = freezed,Object? seatsTotal = freezed,}) {
  return _then(_NextRide(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,departureTime: null == departureTime ? _self.departureTime : departureTime // ignore: cast_nullable_to_non_nullable
as String,originLabel: null == originLabel ? _self.originLabel : originLabel // ignore: cast_nullable_to_non_nullable
as String,destLabel: null == destLabel ? _self.destLabel : destLabel // ignore: cast_nullable_to_non_nullable
as String,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int?,partner: freezed == partner ? _self.partner : partner // ignore: cast_nullable_to_non_nullable
as NextRidePartner?,seatsTaken: freezed == seatsTaken ? _self.seatsTaken : seatsTaken // ignore: cast_nullable_to_non_nullable
as int?,seatsTotal: freezed == seatsTotal ? _self.seatsTotal : seatsTotal // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of NextRide
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NextRidePartnerCopyWith<$Res>? get partner {
    if (_self.partner == null) {
    return null;
  }

  return $NextRidePartnerCopyWith<$Res>(_self.partner!, (value) {
    return _then(_self.copyWith(partner: value));
  });
}
}


/// @nodoc
mixin _$NextRidePartner {

 String get firstName; String get lastName; String? get photoUrl; String? get phone;
/// Create a copy of NextRidePartner
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NextRidePartnerCopyWith<NextRidePartner> get copyWith => _$NextRidePartnerCopyWithImpl<NextRidePartner>(this as NextRidePartner, _$identity);

  /// Serializes this NextRidePartner to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NextRidePartner&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,photoUrl,phone);

@override
String toString() {
  return 'NextRidePartner(firstName: $firstName, lastName: $lastName, photoUrl: $photoUrl, phone: $phone)';
}


}

/// @nodoc
abstract mixin class $NextRidePartnerCopyWith<$Res>  {
  factory $NextRidePartnerCopyWith(NextRidePartner value, $Res Function(NextRidePartner) _then) = _$NextRidePartnerCopyWithImpl;
@useResult
$Res call({
 String firstName, String lastName, String? photoUrl, String? phone
});




}
/// @nodoc
class _$NextRidePartnerCopyWithImpl<$Res>
    implements $NextRidePartnerCopyWith<$Res> {
  _$NextRidePartnerCopyWithImpl(this._self, this._then);

  final NextRidePartner _self;
  final $Res Function(NextRidePartner) _then;

/// Create a copy of NextRidePartner
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firstName = null,Object? lastName = null,Object? photoUrl = freezed,Object? phone = freezed,}) {
  return _then(_self.copyWith(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NextRidePartner].
extension NextRidePartnerPatterns on NextRidePartner {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NextRidePartner value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NextRidePartner() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NextRidePartner value)  $default,){
final _that = this;
switch (_that) {
case _NextRidePartner():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NextRidePartner value)?  $default,){
final _that = this;
switch (_that) {
case _NextRidePartner() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String firstName,  String lastName,  String? photoUrl,  String? phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NextRidePartner() when $default != null:
return $default(_that.firstName,_that.lastName,_that.photoUrl,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String firstName,  String lastName,  String? photoUrl,  String? phone)  $default,) {final _that = this;
switch (_that) {
case _NextRidePartner():
return $default(_that.firstName,_that.lastName,_that.photoUrl,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String firstName,  String lastName,  String? photoUrl,  String? phone)?  $default,) {final _that = this;
switch (_that) {
case _NextRidePartner() when $default != null:
return $default(_that.firstName,_that.lastName,_that.photoUrl,_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NextRidePartner implements NextRidePartner {
  const _NextRidePartner({required this.firstName, required this.lastName, this.photoUrl, this.phone});
  factory _NextRidePartner.fromJson(Map<String, dynamic> json) => _$NextRidePartnerFromJson(json);

@override final  String firstName;
@override final  String lastName;
@override final  String? photoUrl;
@override final  String? phone;

/// Create a copy of NextRidePartner
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NextRidePartnerCopyWith<_NextRidePartner> get copyWith => __$NextRidePartnerCopyWithImpl<_NextRidePartner>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NextRidePartnerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NextRidePartner&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,photoUrl,phone);

@override
String toString() {
  return 'NextRidePartner(firstName: $firstName, lastName: $lastName, photoUrl: $photoUrl, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$NextRidePartnerCopyWith<$Res> implements $NextRidePartnerCopyWith<$Res> {
  factory _$NextRidePartnerCopyWith(_NextRidePartner value, $Res Function(_NextRidePartner) _then) = __$NextRidePartnerCopyWithImpl;
@override @useResult
$Res call({
 String firstName, String lastName, String? photoUrl, String? phone
});




}
/// @nodoc
class __$NextRidePartnerCopyWithImpl<$Res>
    implements _$NextRidePartnerCopyWith<$Res> {
  __$NextRidePartnerCopyWithImpl(this._self, this._then);

  final _NextRidePartner _self;
  final $Res Function(_NextRidePartner) _then;

/// Create a copy of NextRidePartner
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstName = null,Object? lastName = null,Object? photoUrl = freezed,Object? phone = freezed,}) {
  return _then(_NextRidePartner(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
