import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart';

import 'dart:async';

import '../controllers/MarkersController.dart';

class FireMap extends StatefulWidget {
  FireMap({Key key}) : super(key: key);

  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> with AutomaticKeepAliveClientMixin {
  var mapController;

  Location location = new Location();

  Stream<dynamic> query;

  @override
  Widget build(BuildContext context) {
    return GetX<MarkersController>(
      init: MarkersController(),
      builder: (markersController) {
        return GoogleMap(
            initialCameraPosition:
                CameraPosition(target: LatLng(52.520008, 13.404954), zoom: 15),
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            compassEnabled: true,
            markers: Set.from(markersController.markers.values
                .map((mypeMarker) => mypeMarker.marker)),
            onLongPress: (LatLng pos) => markersController.addMarker(pos));
      },
    );
  }

  // Map Created Lifecycle Hook
  _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  bool get wantKeepAlive => true;
}
