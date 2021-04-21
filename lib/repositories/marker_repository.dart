import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/general_providers.dart';
import 'package:mype_app/models/mype_marker/mype_marker.dart';

import 'custom_exception.dart';

final markerRepositoryProvider =
    Provider<MarkerRepository>((ref) => MarkerRepository(ref.read));

class MarkerRepository {
  final Reader _read;

  const MarkerRepository(this._read);

  Stream<QuerySnapshot> markersStream(Set<String> groupIds) =>
      _read(firebaseFirestoreProvider)
          .collection("markers")
          .where("groupIds", arrayContainsAny: groupIds.toList())
          .snapshots();

  Future<Map<String, MypeMarker>> getMarkers(List<String> groupIds) async {
    Map<String, MypeMarker> markers = Map<String, MypeMarker>();
    if (groupIds.isNotEmpty){
    final querySnapshot = await _read(firebaseFirestoreProvider)
        .collection("markers")
        .where("groupIds", arrayContainsAny: groupIds.toList())
        .get();

    for (final doc in querySnapshot.docs) {
      markers[doc.id] = MypeMarker.fromDocument(doc);
    }
    }

    return markers;
  }

/*   addImage(Tuple2<String, File> tuple) {
    images[tuple.value1] = tuple.value2;
    update();
  }
 */
/*   downloadImages(List<String> serverNames) async {
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
  } */

  addMarker(MypeMarker marker) async {
    final doc = await _read(firebaseFirestoreProvider)
        .collection("markers")
        .add(marker.toJson());
    return marker.copyWith(id: doc.id);
  }

/*   updateMarker(String id, MypeMarker mypeMarker) async {
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
  } */

  updateMarker(String id, MypeMarker mypeMarker) async {
    if (id != "user") {
      try {
        await _read(firebaseFirestoreProvider)
            .collection('locations')
            .doc(id)
            .update(mypeMarker.toJson());
      } on FirebaseException catch (e) {
        throw CustomException(message: e.message);
      }
    }
  }

/*   clearUserMarker() {
    markers.remove("user");
    update();
  } */
}
