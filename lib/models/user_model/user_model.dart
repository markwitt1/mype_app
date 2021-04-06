import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part "user_model.freezed.dart";
part "user_model.g.dart";

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    required String phoneNumber,
    required Set<String> friendIds,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromDocument(DocumentSnapshot doc) =>
      User.fromJson(doc.data()!).copyWith(id: doc.id);
}
