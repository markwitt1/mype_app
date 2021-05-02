import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part "user_model.freezed.dart";
part "user_model.g.dart";

String? createCode(String? id) => id?.substring(0, 10);

@freezed
class User with _$User {
  factory User({
    @JsonKey(name: "code", toJson: createCode) String? id,
    required String name,
    required String email,
    required String phoneNumber,
    required Set<String> friendIds,
    required String? profilePicture,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromDocument(DocumentSnapshot doc) =>
      User.fromJson(doc.data()!).copyWith(id: doc.id);
}
