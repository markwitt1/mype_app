import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String email;
  String phoneNumber;
  List<String> friendIds = [];

  UserModel({this.id, this.name, this.email, this.phoneNumber});

  UserModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot.id;
    name = documentSnapshot["name"];
    email = documentSnapshot["email"];
    phoneNumber = documentSnapshot.data()["phoneNumber"];
    friendIds = List<String>.from(documentSnapshot["friendIds"]);
  }
}
