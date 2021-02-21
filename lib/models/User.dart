import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String email;
  List<String> friendIds;

  UserModel({this.id, this.name, this.email});

  UserModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot.id;
    name = documentSnapshot["name"];
    email = documentSnapshot["email"];
    friendIds = List<String>.from(documentSnapshot["friendIds"]);
  }
}
