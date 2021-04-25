import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part "group_model.freezed.dart";
part "group_model.g.dart";

@freezed
class Group with _$Group {
  const factory Group(
      {String? id,
      required String name,
      @Default("") String description,
      required Set<String> userIds}) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  factory Group.fromDocument(DocumentSnapshot doc) =>
      Group.fromJson(doc.data()!).copyWith(id: doc.id);
}
