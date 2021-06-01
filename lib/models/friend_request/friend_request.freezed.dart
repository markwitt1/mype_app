// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'friend_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FriendRequest _$FriendRequestFromJson(Map<String, dynamic> json) {
  return _FriendRequest.fromJson(json);
}

/// @nodoc
class _$FriendRequestTearOff {
  const _$FriendRequestTearOff();

  _FriendRequest call(
      {String? id,
      required String from,
      required String to,
      String message = ""}) {
    return _FriendRequest(
      id: id,
      from: from,
      to: to,
      message: message,
    );
  }

  FriendRequest fromJson(Map<String, Object> json) {
    return FriendRequest.fromJson(json);
  }
}

/// @nodoc
const $FriendRequest = _$FriendRequestTearOff();

/// @nodoc
mixin _$FriendRequest {
  String? get id => throw _privateConstructorUsedError;
  String get from => throw _privateConstructorUsedError;
  String get to => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FriendRequestCopyWith<FriendRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendRequestCopyWith<$Res> {
  factory $FriendRequestCopyWith(
          FriendRequest value, $Res Function(FriendRequest) then) =
      _$FriendRequestCopyWithImpl<$Res>;
  $Res call({String? id, String from, String to, String message});
}

/// @nodoc
class _$FriendRequestCopyWithImpl<$Res>
    implements $FriendRequestCopyWith<$Res> {
  _$FriendRequestCopyWithImpl(this._value, this._then);

  final FriendRequest _value;
  // ignore: unused_field
  final $Res Function(FriendRequest) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? from = freezed,
    Object? to = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      from: from == freezed
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as String,
      to: to == freezed
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as String,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$FriendRequestCopyWith<$Res>
    implements $FriendRequestCopyWith<$Res> {
  factory _$FriendRequestCopyWith(
          _FriendRequest value, $Res Function(_FriendRequest) then) =
      __$FriendRequestCopyWithImpl<$Res>;
  @override
  $Res call({String? id, String from, String to, String message});
}

/// @nodoc
class __$FriendRequestCopyWithImpl<$Res>
    extends _$FriendRequestCopyWithImpl<$Res>
    implements _$FriendRequestCopyWith<$Res> {
  __$FriendRequestCopyWithImpl(
      _FriendRequest _value, $Res Function(_FriendRequest) _then)
      : super(_value, (v) => _then(v as _FriendRequest));

  @override
  _FriendRequest get _value => super._value as _FriendRequest;

  @override
  $Res call({
    Object? id = freezed,
    Object? from = freezed,
    Object? to = freezed,
    Object? message = freezed,
  }) {
    return _then(_FriendRequest(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      from: from == freezed
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as String,
      to: to == freezed
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as String,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FriendRequest with DiagnosticableTreeMixin implements _FriendRequest {
  const _$_FriendRequest(
      {this.id, required this.from, required this.to, this.message = ""});

  factory _$_FriendRequest.fromJson(Map<String, dynamic> json) =>
      _$_$_FriendRequestFromJson(json);

  @override
  final String? id;
  @override
  final String from;
  @override
  final String to;
  @JsonKey(defaultValue: "")
  @override
  final String message;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FriendRequest(id: $id, from: $from, to: $to, message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'FriendRequest'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('from', from))
      ..add(DiagnosticsProperty('to', to))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _FriendRequest &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.from, from) ||
                const DeepCollectionEquality().equals(other.from, from)) &&
            (identical(other.to, to) ||
                const DeepCollectionEquality().equals(other.to, to)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(from) ^
      const DeepCollectionEquality().hash(to) ^
      const DeepCollectionEquality().hash(message);

  @JsonKey(ignore: true)
  @override
  _$FriendRequestCopyWith<_FriendRequest> get copyWith =>
      __$FriendRequestCopyWithImpl<_FriendRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_FriendRequestToJson(this);
  }
}

abstract class _FriendRequest implements FriendRequest {
  const factory _FriendRequest(
      {String? id,
      required String from,
      required String to,
      String message}) = _$_FriendRequest;

  factory _FriendRequest.fromJson(Map<String, dynamic> json) =
      _$_FriendRequest.fromJson;

  @override
  String? get id => throw _privateConstructorUsedError;
  @override
  String get from => throw _privateConstructorUsedError;
  @override
  String get to => throw _privateConstructorUsedError;
  @override
  String get message => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$FriendRequestCopyWith<_FriendRequest> get copyWith =>
      throw _privateConstructorUsedError;
}
