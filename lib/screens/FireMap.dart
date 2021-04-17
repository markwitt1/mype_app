import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:location/location.dart';
import 'package:mype_app/models/mype_marker/mype_marker.dart';
import '../controllers/markers_controller.dart';

Marker markerFromMypeMarker(
    MypeMarker mypeMarker, void Function(MypeMarker mypeMarker) open) {
  return Marker(
    markerId: MarkerId(mypeMarker.id),
    position: LatLng(mypeMarker.latitude, mypeMarker.longitude),
    infoWindow: InfoWindow(
        title: mypeMarker.title.length > 0 ? mypeMarker.title : "new Marker",
        snippet: mypeMarker.title.length > 0
            ? mypeMarker.description
            : "Tap to edit",
        onTap: () => open(mypeMarker)),
  );
}

class FireMap extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final googleMapController = useState<GoogleMapController?>(null);
    final markersController = useProvider(markersControllerProvider);
    markersController.getMarkers();
    final markersAsyncValue = useProvider(markersControllerProvider.state);

    return markersAsyncValue.when(
        loading: () => Center(
              child: CircularProgressIndicator(),
            ),
        error: (error, stack) => Center(
              child: Text("error"),
            ),
        data: (markers) {
          Set<Marker> allMarkers = Set.from(
            markers.values.map((m) => markerFromMypeMarker(
                  m,
                  (id) {},
                )),
          );
          return GoogleMap(
            onLongPress: (LatLng pos) {
              if (markers["user"] != null) {
                markersController.updateMarker(
                    "user",
                    MypeMarker(
                        imageIds: [],
                        groupIds: Set(),
                        latitude: pos.latitude,
                        longitude: pos.longitude,
                        title: "new Marker",
                        description: "Tap to edit"));
              } else {
                markersController.addMarker(pos,isUserMarker: true);
              }
            },
            initialCameraPosition:
                CameraPosition(target: LatLng(52.520008, 13.404954), zoom: 15),
            onMapCreated: (controller) =>
                googleMapController.value = controller,
            myLocationEnabled: true,
            compassEnabled: true,
            markers: allMarkers,
          );
        });
  }

  // Map Created Lifecycle Hook
  @override
  bool get wantKeepAlive => true;
}
