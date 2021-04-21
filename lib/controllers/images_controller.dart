import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/groups_controller.dart';
import 'package:mype_app/controllers/markers_controller.dart';
import 'package:mype_app/general_providers.dart';
import 'package:mype_app/models/group_model/group_model.dart';
import 'package:mype_app/models/image_model/image_model.dart';
import 'package:mype_app/models/mype_marker/mype_marker.dart';
import 'package:http/http.dart' as http;
import 'package:mype_app/repositories/images_repository.dart';
import 'package:path_provider/path_provider.dart';

final imagesControllerProvider =
    // ignore: top_level_function_literal_block
    StateNotifierProvider((ProviderReference ref) {
  final _markers = ref.watch(markersControllerProvider.state);
  return ImagesController(
      ref.read, _markers.data != null ? _markers.data!.value : {})
    ..sync();
});

class ImagesController extends StateNotifier<Map<String, ImageModel>> {
  final Reader _read;
  final Map<String, MypeMarker> _markers;
  ImagesController(this._read, this._markers) : super({});

  sync() async {
    for (final marker in _markers.values) {
      for (final imageId in marker.imageIds) {
        if (state[imageId] != null) {
          if (state[imageId]!.file != null) {
            //file exists on disk
          } else if (state[imageId]!.serverFileName != null) {
            _populateAndDownload(imageId);
          } else {}
        } else {
          state[imageId] = ImageModel(serverFileName: imageId);
          _populateAndDownload(imageId);
        }
      }
    }
  }

  _populateAndDownload(String imageId) async {
    final downloadUrl = state[imageId]!.downloadUrl != null
        ? state[imageId]!.downloadUrl!
        : await _read(firebaseStorageProvider)
            .ref(state[imageId]!.serverFileName)
            .getDownloadURL();

    state[imageId] = state[imageId]!.copyWith(
        file: await _read(imagesRepositoryProvider)
            .download(state[imageId]!.copyWith(downloadUrl: downloadUrl)));
  }
}
