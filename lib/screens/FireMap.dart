import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';
import 'package:mype_app/controllers/groups_controller.dart';

import 'package:mype_app/models/mype_marker/mype_marker.dart';
import 'package:mype_app/screens/windows/MarkerWindow.dart';
import 'package:mype_app/utils/useKeepAlive.dart';
import '../controllers/markers_controller.dart';

Marker markerFromMypeMarker(MypeMarker mypeMarker, void Function() open,
        {blue = false}) =>
    Marker(
      markerId: MarkerId(mypeMarker.id != null ? mypeMarker.id! : "user"),
      position: LatLng(mypeMarker.latitude, mypeMarker.longitude),
      icon: blue
          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
          : BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
          title: mypeMarker.title.length > 0 ? mypeMarker.title : "new Marker",
          snippet: mypeMarker.title.length > 0
              ? mypeMarker.description
              : "Tap to edit",
          onTap: open),
    );

class FireMap extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cameraPosition =
        useState(CameraPosition(target: LatLng(53.520008, 13.404954), zoom: 8));
    useAutomaticKeepAlive(wantKeepAlive: true);
    final userMarker = useState<MypeMarker?>(null);
    final markersController = useProvider(markersControllerProvider);
    final groupsController = useProvider(groupsControllerProvider);

    final markersAsyncValue = useProvider(markersControllerProvider.state);
    Future<LatLng?> getUserLocation() async {
      Location location = new Location();
      bool _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
      }
      if (!_serviceEnabled) return null;

      final data = await location.getLocation();
      return LatLng(data.latitude!, data.longitude!);
    }

    useEffect(() {
      getUserLocation().then((value) {
        if (value != null)
          cameraPosition.value = CameraPosition(target: value, zoom: 15);
      });
    }, []);

    openMarkerWindow(MypeMarker mypeMarker) async {
      bool? success = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MarkerWindow(mypeMarker: mypeMarker)));
      if (success == true) userMarker.value = null;
      markersController.getMarkers();
    }

    return markersAsyncValue.when(
        loading: () => Center(
              child: CircularProgressIndicator(),
            ),
        error: (error, stack) => Center(
              child: Text("error"),
            ),
        data: (markers) {
          Set<Marker> allMarkers =
              Set.from(markers.values.map((m) => markerFromMypeMarker(
                    m,
                    () {
                      openMarkerWindow(m);
                    },
                  )));

          if (userMarker.value != null) {
            allMarkers.add(markerFromMypeMarker(userMarker.value!, () {
              openMarkerWindow(userMarker.value!);
            }, blue: true));
          }

          return Stack(
            children: [
              GoogleMap(
                onCameraMove: (pos) => cameraPosition.value = pos,
                myLocationButtonEnabled: true,
                initialCameraPosition: cameraPosition.value,
                onLongPress: (LatLng pos) {
                  userMarker.value = MypeMarker(
                    imageIds: [],
                    groupIds: Set(),
                    latitude: pos.latitude,
                    longitude: pos.longitude,
                  );
                },
                onTap: (_) => userMarker.value = null,
                onMapCreated: (controller) {
/*                   googleMapController.value = controller;
                  getUserLocation().then((location) {
                    if (location != null) {
                      googleMapController.value!
                          .moveCamera(CameraUpdate.newLatLng(location));
                    }
                  }); */
                },
                myLocationEnabled: true,
                compassEnabled: true,
                markers: allMarkers,
              ),
              Positioned(
                top: 30,
                left: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        markersController.getMarkers();
                        groupsController.getGroups();
                      }),
                ),
              ),
            ],
          );
        });
  }
}
