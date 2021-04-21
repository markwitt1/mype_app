import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part "mype_marker.freezed.dart";
part "mype_marker.g.dart";

@freezed
 class MypeMarker with _$MypeMarker {
  const factory MypeMarker(
      {
    String? id,
      @Default("") String title,
      @Default("") String description,
      required List<String> imageIds,
      required Set<String> groupIds,
      required double latitude,
      required double longitude}) = _MypeMarker;

  factory MypeMarker.fromJson(Map<String, dynamic> json) =>
      _$MypeMarkerFromJson(json);

  factory MypeMarker.fromDocument(DocumentSnapshot doc) =>
      MypeMarker.fromJson(doc.data()!).copyWith(id: doc.id);
}
