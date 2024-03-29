import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mype_app/general_providers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

import 'custom_exception.dart';

final imagesRepositoryProvider =
    Provider<ImagesRepository>((ref) => ImagesRepository(ref.read));

class ImagesRepository {
  final Reader _read;

  ImagesRepository(this._read);
  final picker = ImagePicker();

  Future<File?> pickImage(ImageSource source) async {
    try {
      if (kReleaseMode) {
        final pickedFile = await picker.getImage(source: source);
        if (pickedFile?.path != null) return File(pickedFile!.path);
      } else {
        return await downloadFromUrl(
            "https://source.unsplash.com/random", "${Uuid().v4()}.png");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> upload(File image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final serverFileName = "${Uuid().v4()}${p.extension(image.path)}";
    final Reference firebaseStorageRef =
        _read(firebaseStorageProvider).ref().child(serverFileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(image);
    try {
      await uploadTask;
      prefs.setString(serverFileName, image.path);
      return serverFileName;
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  Future<File?> downloadFromUrl(String url, String fileName) async {
    if (await Permission.storage.request().isGranted) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      final client = http.Client();
      final http.Response downloadData = await client.get(Uri.parse(url));
      final file = File('${appDocDir.path}/$fileName');
      await file.writeAsBytes(downloadData.bodyBytes);
      return file;
    }
  }

/*   Future<File?> getImage(String imageId) async {
    SharedPreferences prefs = _read(sharedPrefsProvider).state!;
    final mappedPath = prefs.getString(imageId);
    if (mappedPath != null) {
      return File(mappedPath);
    } else {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      final checkFile = File('${appDocDir.path}/$imageId');
      if (await checkFile.exists()) {
        return checkFile;
      } else {
        final file = await downloadFromFirebase(imageId);
        return file;
      }
    }
  } */

  Future<File?> downloadFromFirebase(String imageId) async {
    if (await Permission.storage.request().isGranted) {
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        final imagesDir = Directory(externalDir.path + "/images");
        if (!await imagesDir.exists()) {
          await imagesDir.create();
        }
        final file = File('${imagesDir.path}/$imageId');
        await _read(firebaseStorageProvider).ref(imageId).writeToFile(file);
        print("downloaded $file");
        return file;
      }
    }
  }

  Future<String?> getImageUrl(String imageId) {
    return _read(firebaseStorageProvider).ref(imageId).getDownloadURL();
  }

/*   saveToGallery(String imageId) async {
    final file = await downloadFromFirebase(imageId);
    if (file != null) {
      final saved = await GallerySaver.saveImage(file.path);
      if (saved != true) {
        throw CustomException(message: "image couldn't be saved to gallery");
      }
    } else {
      throw CustomException(message: "download failed");
    }
  } */
}
