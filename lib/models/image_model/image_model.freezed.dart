// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'image_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$ImageModelTearOff {
  const _$ImageModelTearOff();

  _ImageModel call(
      {String? serverFileName,
      String? downloadUrl,
      File? file,
      String? fileHash}) {
    return _ImageModel(
      serverFileName: serverFileName,
      downloadUrl: downloadUrl,
      file: file,
      fileHash: fileHash,
    );
  }
}

/// @nodoc
const $ImageModel = _$ImageModelTearOff();

/// @nodoc
mixin _$ImageModel {
  String? get serverFileName => throw _privateConstructorUsedError;
  String? get downloadUrl => throw _privateConstructorUsedError;
  File? get file => throw _privateConstructorUsedError;
  String? get fileHash => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ImageModelCopyWith<ImageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageModelCopyWith<$Res> {
  factory $ImageModelCopyWith(
          ImageModel value, $Res Function(ImageModel) then) =
      _$ImageModelCopyWithImpl<$Res>;
  $Res call(
      {String? serverFileName,
      String? downloadUrl,
      File? file,
      String? fileHash});
}

/// @nodoc
class _$ImageModelCopyWithImpl<$Res> implements $ImageModelCopyWith<$Res> {
  _$ImageModelCopyWithImpl(this._value, this._then);

  final ImageModel _value;
  // ignore: unused_field
  final $Res Function(ImageModel) _then;

  @override
  $Res call({
    Object? serverFileName = freezed,
    Object? downloadUrl = freezed,
    Object? file = freezed,
    Object? fileHash = freezed,
  }) {
    return _then(_value.copyWith(
      serverFileName: serverFileName == freezed
          ? _value.serverFileName
          : serverFileName // ignore: cast_nullable_to_non_nullable
              as String?,
      downloadUrl: downloadUrl == freezed
          ? _value.downloadUrl
          : downloadUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      file: file == freezed
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as File?,
      fileHash: fileHash == freezed
          ? _value.fileHash
          : fileHash // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$ImageModelCopyWith<$Res> implements $ImageModelCopyWith<$Res> {
  factory _$ImageModelCopyWith(
          _ImageModel value, $Res Function(_ImageModel) then) =
      __$ImageModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? serverFileName,
      String? downloadUrl,
      File? file,
      String? fileHash});
}

/// @nodoc
class __$ImageModelCopyWithImpl<$Res> extends _$ImageModelCopyWithImpl<$Res>
    implements _$ImageModelCopyWith<$Res> {
  __$ImageModelCopyWithImpl(
      _ImageModel _value, $Res Function(_ImageModel) _then)
      : super(_value, (v) => _then(v as _ImageModel));

  @override
  _ImageModel get _value => super._value as _ImageModel;

  @override
  $Res call({
    Object? serverFileName = freezed,
    Object? downloadUrl = freezed,
    Object? file = freezed,
    Object? fileHash = freezed,
  }) {
    return _then(_ImageModel(
      serverFileName: serverFileName == freezed
          ? _value.serverFileName
          : serverFileName // ignore: cast_nullable_to_non_nullable
              as String?,
      downloadUrl: downloadUrl == freezed
          ? _value.downloadUrl
          : downloadUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      file: file == freezed
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as File?,
      fileHash: fileHash == freezed
          ? _value.fileHash
          : fileHash // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
class _$_ImageModel implements _ImageModel {
  const _$_ImageModel(
      {this.serverFileName, this.downloadUrl, this.file, this.fileHash});

  @override
  final String? serverFileName;
  @override
  final String? downloadUrl;
  @override
  final File? file;
  @override
  final String? fileHash;

  @override
  String toString() {
    return 'ImageModel(serverFileName: $serverFileName, downloadUrl: $downloadUrl, file: $file, fileHash: $fileHash)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ImageModel &&
            (identical(other.serverFileName, serverFileName) ||
                const DeepCollectionEquality()
                    .equals(other.serverFileName, serverFileName)) &&
            (identical(other.downloadUrl, downloadUrl) ||
                const DeepCollectionEquality()
                    .equals(other.downloadUrl, downloadUrl)) &&
            (identical(other.file, file) ||
                const DeepCollectionEquality().equals(other.file, file)) &&
            (identical(other.fileHash, fileHash) ||
                const DeepCollectionEquality()
                    .equals(other.fileHash, fileHash)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(serverFileName) ^
      const DeepCollectionEquality().hash(downloadUrl) ^
      const DeepCollectionEquality().hash(file) ^
      const DeepCollectionEquality().hash(fileHash);

  @JsonKey(ignore: true)
  @override
  _$ImageModelCopyWith<_ImageModel> get copyWith =>
      __$ImageModelCopyWithImpl<_ImageModel>(this, _$identity);
}

abstract class _ImageModel implements ImageModel {
  const factory _ImageModel(
      {String? serverFileName,
      String? downloadUrl,
      File? file,
      String? fileHash}) = _$_ImageModel;

  @override
  String? get serverFileName => throw _privateConstructorUsedError;
  @override
  String? get downloadUrl => throw _privateConstructorUsedError;
  @override
  File? get file => throw _privateConstructorUsedError;
  @override
  String? get fileHash => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ImageModelCopyWith<_ImageModel> get copyWith =>
      throw _privateConstructorUsedError;
}
