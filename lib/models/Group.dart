import 'package:cloud_firestore/cloud_firestore.dart';

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
}
