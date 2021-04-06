/* import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mype_app/controllers/GroupsController.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/openMarkerWindow.dart';
import '../models/MypeMarker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MarkersController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxMap<String, MypeMarker> markers = RxMap<String, MypeMarker>();

  RxMap<String, File> images = Map<String, File>().obs;

  @override
  onInit() async {
    this.getMarkers();
    this.listen();
    super.onInit();
  }

  listen() async {
    final groupIds = await Get.find<GroupsController>().getGroupIds();
    if (groupIds.length > 0) {
      Stream<Map<String, MypeMarker>> locationsStream = firestore
          .collection("locations")
          .where("groupIds", arrayContainsAny: groupIds)
          .snapshots()
          .map((snapshot) {
        Map<String, MypeMarker> retVal = Map<String, MypeMarker>();
        for (final doc in snapshot.docs) {
          retVal[doc.id] = MypeMarker.fromDocumentSnapshot(doc);
        }
        return retVal;
      });

      markers.bindStream(locationsStream);
    }
  }

  getMarkers() async {
    final groupIds = await Get.find<GroupsController>().getGroupIds();
    if (groupIds.length > 0) {
      final querySnapshot = await firestore
          .collection("locations")
          .where("groupIds", arrayContainsAny: groupIds)
          .get();

      for (final doc in querySnapshot.docs) {
        markers[doc.id] = MypeMarker.fromDocumentSnapshot(doc);
      }

      update();
    }
  }

  addImage(Tuple2<String, File> tuple) {
    images[tuple.value1] = tuple.value2;
    update();
  }

  downloadImages(List<String> serverNames) async {
    for (final serverName in serverNames) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      File newFile = File('${appDocDir.path}/$serverName');

      try {
        await FirebaseStorage.instance
            .ref('uploads/logo.png')
            .writeToFile(newFile);
        images[serverName] = newFile;
      } on FirebaseException catch (e) {
        e.printError();
      }
    }
    update();
  }

  addMarker(
    LatLng position,
  ) {
    markers["user"] = MypeMarker(
      images: [],
      groupIds: [],
      marker: Marker(
        markerId: MarkerId("user"),
        position: position,
        infoWindow: InfoWindow(
            title: "new Marker",
            snippet: 'Click to edit',
            onTap: () => openMarkerWindow("user")),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    update();
  }

  updateMarker(String id, MypeMarker mypeMarker) async {
    if (id == "user") markers.remove("user");
    final res =
        await firestore.collection('locations').add(mypeMarker.toSimpleJson());

    mypeMarker.marker = new Marker(
        markerId: MarkerId(res.id),
        position: mypeMarker.marker.position,
        infoWindow: InfoWindow(
            title: mypeMarker.title,
            snippet: mypeMarker.description,
            onTap: () => openMarkerWindow(res.id)));
    markers[res.id] = mypeMarker;
    update();
  }

  clearUserMarker() {
    markers.remove("user");
    update();
  }
}
 */
