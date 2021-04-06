/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/openMarkerWindow.dart';

class MypeMarker {
  MypeMarker(
      {@required this.marker,
      this.title,
      this.description,
      this.images,
      this.groupIds});
  MypeMarker.fromJson(Map<String, dynamic> json)
      : marker = Marker(
          markerId: MarkerId(json['id']),
          position: LatLng(json["latitude"], json["longitude"]),
          infoWindow: InfoWindow(
              title: json["title"],
              snippet: json["description"],
              onTap: () => openMarkerWindow(json["id"])),
        ),
        title = json['title'],
        description = json['description'],
        images = List<String>.from(json['images']),
        groupIds = List<String>.from(json['groupIds']);
  MypeMarker.fromDocumentSnapshot(DocumentSnapshot documentSnapshot)
      : marker = Marker(
          markerId: MarkerId(documentSnapshot.id),
          position: LatLng(
              documentSnapshot["latitude"], documentSnapshot["longitude"]),
          infoWindow: InfoWindow(
            title: documentSnapshot["title"],
            snippet: documentSnapshot["description"],
            onTap: () => openMarkerWindow(
              documentSnapshot.id,
            ),
          ),
        ),
        title = documentSnapshot['title'],
        description = documentSnapshot['description'],
        images = List<String>.from(documentSnapshot['images']),
        groupIds = List<String>.from(documentSnapshot['groupIds']);

  Marker marker;

  final String title;

  final String description;

  final List<String> images;

  final List<String> groupIds;

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
