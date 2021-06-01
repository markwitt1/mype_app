// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'mype_marker.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MypeMarker _$MypeMarkerFromJson(Map<String, dynamic> json) {
  return _MypeMarker.fromJson(json);
}

/// @nodoc
class _$MypeMarkerTearOff {
  const _$MypeMarkerTearOff();

  _MypeMarker call(
      {String? id,
      String title = "",
      String description = "",
      required List<String> imageIds,
      required Set<String> groupIds,
      required double latitude,
      required double longitude}) {
    return _MypeMarker(
      id: id,
      title: title,
      description: description,
      imageIds: imageIds,
      groupIds: groupIds,
      latitude: latitude,
      longitude: longitude,
    );
  }

  MypeMarker fromJson(Map<String, Object> json) {
    return MypeMarker.fromJson(json);
  }
}

/// @nodoc
const $MypeMarker = _$MypeMarkerTearOff();

/// @nodoc
mixin _$MypeMarker {
  String? get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get imageIds => throw _privateConstructorUsedError;
  Set<String> get groupIds => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MypeMarkerCopyWith<MypeMarker> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MypeMarkerCopyWith<$Res> {
  factory $MypeMarkerCopyWith(
          MypeMarker value, $Res Function(MypeMarker) then) =
      _$MypeMarkerCopyWithImpl<$Res>;
  $Res call(
      {String? id,
      String title,
      String description,
      List<String> imageIds,
      Set<String> groupIds,
      double latitude,
      double longitude});
}

/// @nodoc
class _$MypeMarkerCopyWithImpl<$Res> implements $MypeMarkerCopyWith<$Res> {
  _$MypeMarkerCopyWithImpl(this._value, this._then);

  final MypeMarker _value;
  // ignore: unused_field
  final $Res Function(MypeMarker) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? imageIds = freezed,
    Object? groupIds = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageIds: imageIds == freezed
          ? _value.imageIds
          : imageIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      groupIds: groupIds == freezed
          ? _value.groupIds
          : groupIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      latitude: latitude == freezed
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: longitude == freezed
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
abstract class _$MypeMarkerCopyWith<$Res> implements $MypeMarkerCopyWith<$Res> {
  factory _$MypeMarkerCopyWith(
          _MypeMarker value, $Res Function(_MypeMarker) then) =
      __$MypeMarkerCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? id,
      String title,
      String description,
      List<String> imageIds,
      Set<String> groupIds,
      double latitude,
      double longitude});
}

/// @nodoc
class __$MypeMarkerCopyWithImpl<$Res> extends _$MypeMarkerCopyWithImpl<$Res>
    implements _$MypeMarkerCopyWith<$Res> {
  __$MypeMarkerCopyWithImpl(
      _MypeMarker _value, $Res Function(_MypeMarker) _then)
      : super(_value, (v) => _then(v as _MypeMarker));

  @override
  _MypeMarker get _value => super._value as _MypeMarker;

  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? imageIds = freezed,
    Object? groupIds = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(_MypeMarker(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageIds: imageIds == freezed
          ? _value.imageIds
          : imageIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      groupIds: groupIds == freezed
          ? _value.groupIds
          : groupIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      latitude: latitude == freezed
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: longitude == freezed
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MypeMarker with DiagnosticableTreeMixin implements _MypeMarker {
  const _$_MypeMarker(
      {this.id,
      this.title = "",
      this.description = "",
      required this.imageIds,
      required this.groupIds,
      required this.latitude,
      required this.longitude});

  factory _$_MypeMarker.fromJson(Map<String, dynamic> json) =>
      _$_$_MypeMarkerFromJson(json);

  @override
  final String? id;
  @JsonKey(defaultValue: "")
  @override
  final String title;
  @JsonKey(defaultValue: "")
  @override
  final String description;
  @override
  final List<String> imageIds;
  @override
  final Set<String> groupIds;
  @override
  final double latitude;
  @override
  final double longitude;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MypeMarker(id: $id, title: $title, description: $description, imageIds: $imageIds, groupIds: $groupIds, latitude: $latitude, longitude: $longitude)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'MypeMarker'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('imageIds', imageIds))
      ..add(DiagnosticsProperty('groupIds', groupIds))
      ..add(DiagnosticsProperty('latitude', latitude))
      ..add(DiagnosticsProperty('longitude', longitude));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MypeMarker &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.imageIds, imageIds) ||
                const DeepCollectionEquality()
                    .equals(other.imageIds, imageIds)) &&
            (identical(other.groupIds, groupIds) ||
                const DeepCollectionEquality()
                    .equals(other.groupIds, groupIds)) &&
            (identical(other.latitude, latitude) ||
                const DeepCollectionEquality()
                    .equals(other.latitude, latitude)) &&
            (identical(other.longitude, longitude) ||
                const DeepCollectionEquality()
                    .equals(other.longitude, longitude)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(imageIds) ^
      const DeepCollectionEquality().hash(groupIds) ^
      const DeepCollectionEquality().hash(latitude) ^
      const DeepCollectionEquality().hash(longitude);

  @JsonKey(ignore: true)
  @override
  _$MypeMarkerCopyWith<_MypeMarker> get copyWith =>
      __$MypeMarkerCopyWithImpl<_MypeMarker>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_MypeMarkerToJson(this);
  }
}

abstract class _MypeMarker implements MypeMarker {
  const factory _MypeMarker(
      {String? id,
      String title,
      String description,
      required List<String> imageIds,
      required Set<String> groupIds,
      required double latitude,
      required double longitude}) = _$_MypeMarker;

  factory _MypeMarker.fromJson(Map<String, dynamic> json) =
      _$_MypeMarker.fromJson;

  @override
  String? get id => throw _privateConstructorUsedError;
  @override
  String get title => throw _privateConstructorUsedError;
  @override
  String get description => throw _privateConstructorUsedError;
  @override
  List<String> get imageIds => throw _privateConstructorUsedError;
  @override
  Set<String> get groupIds => throw _privateConstructorUsedError;
  @override
  double get latitude => throw _privateConstructorUsedError;
  @override
  double get longitude => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MypeMarkerCopyWith<_MypeMarker> get copyWith =>
      throw _privateConstructorUsedError;
}
