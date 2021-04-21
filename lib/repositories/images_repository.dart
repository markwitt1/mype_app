import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/general_providers.dart';
import 'package:mype_app/models/image_model/image_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

import 'custom_exception.dart';

final imagesRepositoryProvider =
    Provider<ImagesRepository>((ref) => ImagesRepository(ref.read));

class ImagesRepository {
  final Reader _read;

  const ImagesRepository(this._read);

  addImage(File image) async {
    final serverFileName = "${Uuid().v4()}.${p.extension(image.path)}";
    final fullPath = "images/$serverFileName";
    final Reference firebaseStorageRef =
        _read(firebaseStorageProvider).ref().child(fullPath);
    UploadTask uploadTask = firebaseStorageRef.putFile(image);

    await uploadTask.whenComplete(() async {
      var downloadUrl = await firebaseStorageRef.getDownloadURL();
      return ImageModel(downloadUrl: downloadUrl, file: image);
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<File> download(ImageModel imageModel) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final http.Response downloadData =
        await http.get(Uri(path: imageModel.downloadUrl!));
    return File('${appDocDir.path}/${imageModel.serverFileName}');
  }
}
