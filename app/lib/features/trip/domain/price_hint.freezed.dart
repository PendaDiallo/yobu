// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_hint.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PriceHint {

 int get min; int get suggested; int get max;
/// Create a copy of PriceHint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceHintCopyWith<PriceHint> get copyWith => _$PriceHintCopyWithImpl<PriceHint>(this as PriceHint, _$identity);

  /// Serializes this PriceHint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceHint&&(identical(other.min, min) || other.min == min)&&(identical(other.suggested, suggested) || other.suggested == suggested)&&(identical(other.max, max) || other.max == max));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,min,suggested,max);

@override
String toString() {
  return 'PriceHint(min: $min, suggested: $suggested, max: $max)';
}


}

/// @nodoc
abstract mixin class $PriceHintCopyWith<$Res>  {
  factory $PriceHintCopyWith(PriceHint value, $Res Function(PriceHint) _then) = _$PriceHintCopyWithImpl;
@useResult
$Res call({
 int min, int suggested, int max
});




}
/// @nodoc
class _$PriceHintCopyWithImpl<$Res>
    implements $PriceHintCopyWith<$Res> {
  _$PriceHintCopyWithImpl(this._self, this._then);

  final PriceHint _self;
  final $Res Function(PriceHint) _then;

/// Create a copy of PriceHint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? min = null,Object? suggested = null,Object? max = null,}) {
  return _then(_self.copyWith(
min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as int,suggested: null == suggested ? _self.suggested : suggested // ignore: cast_nullable_to_non_nullable
as int,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceHint].
extension PriceHintPatterns on PriceHint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceHint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceHint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceHint value)  $default,){
final _that = this;
switch (_that) {
case _PriceHint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceHint value)?  $default,){
final _that = this;
switch (_that) {
case _PriceHint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int min,  int suggested,  int max)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceHint() when $default != null:
return $default(_that.min,_that.suggested,_that.max);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int min,  int suggested,  int max)  $default,) {final _that = this;
switch (_that) {
case _PriceHint():
return $default(_that.min,_that.suggested,_that.max);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int min,  int suggested,  int max)?  $default,) {final _that = this;
switch (_that) {
case _PriceHint() when $default != null:
return $default(_that.min,_that.suggested,_that.max);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PriceHint implements PriceHint {
  const _PriceHint({required this.min, required this.suggested, required this.max});
  factory _PriceHint.fromJson(Map<String, dynamic> json) => _$PriceHintFromJson(json);

@override final  int min;
@override final  int suggested;
@override final  int max;

/// Create a copy of PriceHint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceHintCopyWith<_PriceHint> get copyWith => __$PriceHintCopyWithImpl<_PriceHint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PriceHintToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceHint&&(identical(other.min, min) || other.min == min)&&(identical(other.suggested, suggested) || other.suggested == suggested)&&(identical(other.max, max) || other.max == max));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,min,suggested,max);

@override
String toString() {
  return 'PriceHint(min: $min, suggested: $suggested, max: $max)';
}


}

/// @nodoc
abstract mixin class _$PriceHintCopyWith<$Res> implements $PriceHintCopyWith<$Res> {
  factory _$PriceHintCopyWith(_PriceHint value, $Res Function(_PriceHint) _then) = __$PriceHintCopyWithImpl;
@override @useResult
$Res call({
 int min, int suggested, int max
});




}
/// @nodoc
class __$PriceHintCopyWithImpl<$Res>
    implements _$PriceHintCopyWith<$Res> {
  __$PriceHintCopyWithImpl(this._self, this._then);

  final _PriceHint _self;
  final $Res Function(_PriceHint) _then;

/// Create a copy of PriceHint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? min = null,Object? suggested = null,Object? max = null,}) {
  return _then(_PriceHint(
min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as int,suggested: null == suggested ? _self.suggested : suggested // ignore: cast_nullable_to_non_nullable
as int,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
