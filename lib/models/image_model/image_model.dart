import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part "image_model.freezed.dart";

@freezed
class ImageModel with _$ImageModel {
  const factory ImageModel({
    String? serverFileName,
    String? downloadUrl,
    File? file,
    String? fileHash,
  }) = _ImageModel;
}
