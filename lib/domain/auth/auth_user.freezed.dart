// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'auth_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AuthUser {
  UniqueId get id => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AuthUserCopyWith<AuthUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthUserCopyWith<$Res> {
  factory $AuthUserCopyWith(AuthUser value, $Res Function(AuthUser) then) =
      _$AuthUserCopyWithImpl<$Res>;
  $Res call({UniqueId id});
}

/// @nodoc
class _$AuthUserCopyWithImpl<$Res> implements $AuthUserCopyWith<$Res> {
  _$AuthUserCopyWithImpl(this._value, this._then);

  final AuthUser _value;
  // ignore: unused_field
  final $Res Function(AuthUser) _then;

  @override
  $Res call({
    Object? id = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as UniqueId,
    ));
  }
}

/// @nodoc
abstract class _$$_AuthUserCopyWith<$Res> implements $AuthUserCopyWith<$Res> {
  factory _$$_AuthUserCopyWith(
          _$_AuthUser value, $Res Function(_$_AuthUser) then) =
      __$$_AuthUserCopyWithImpl<$Res>;
  @override
  $Res call({UniqueId id});
}

/// @nodoc
class __$$_AuthUserCopyWithImpl<$Res> extends _$AuthUserCopyWithImpl<$Res>
    implements _$$_AuthUserCopyWith<$Res> {
  __$$_AuthUserCopyWithImpl(
      _$_AuthUser _value, $Res Function(_$_AuthUser) _then)
      : super(_value, (v) => _then(v as _$_AuthUser));

  @override
  _$_AuthUser get _value => super._value as _$_AuthUser;

  @override
  $Res call({
    Object? id = freezed,
  }) {
    return _then(_$_AuthUser(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as UniqueId,
    ));
  }
}

/// @nodoc

class _$_AuthUser implements _AuthUser {
  const _$_AuthUser({required this.id});

  @override
  final UniqueId id;

  @override
  String toString() {
    return 'AuthUser(id: $id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AuthUser &&
            const DeepCollectionEquality().equals(other.id, id));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(id));

  @JsonKey(ignore: true)
  @override
  _$$_AuthUserCopyWith<_$_AuthUser> get copyWith =>
      __$$_AuthUserCopyWithImpl<_$_AuthUser>(this, _$identity);
}

abstract class _AuthUser implements AuthUser {
  const factory _AuthUser({required final UniqueId id}) = _$_AuthUser;

  @override
  UniqueId get id;
  @override
  @JsonKey(ignore: true)
  _$$_AuthUserCopyWith<_$_AuthUser> get copyWith =>
      throw _privateConstructorUsedError;
}
