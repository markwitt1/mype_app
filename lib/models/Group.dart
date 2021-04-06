/* import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  String id;
  String name;
  List<String> userIds;

  GroupModel({this.id, this.userIds, this.name});

  GroupModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot.id;
    userIds = List<String>.from(documentSnapshot["userIds"]);
    name = documentSnapshot["name"];
  }

  Map<String, dynamic> toJson() => {
        'title': this.title,
        'id': this.marker,
        'latitude': this.marker.position.latitude,
        'longitude': this.marker.position.longitude,
        'description': this.description,
        'images': this.images,
        'groupIds': this.groupIds
      };
}
 */
