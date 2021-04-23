import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:mype_app/models/mype_marker/mype_marker.dart';
import 'package:mype_app/screens/windows/MarkerWindow.dart';
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
    final userMarker = useState<MypeMarker?>(null);
    final markersController = useProvider(markersControllerProvider);

    openMarkerWindow(MypeMarker mypeMarker) async {
      bool? success = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MarkerWindow(mypeMarker: mypeMarker)));
      if (success == true) userMarker.value = null;
      markersController.getMarkers();
    }

    final googleMapController = useState<GoogleMapController?>(null);
    //final markersController = useProvider(markersControllerProvider);
    final markersAsyncValue = useProvider(markersControllerProvider.state);
    /*    useEffect(() {
      markersController.getMarkers();
    }, []); */

    return markersAsyncValue.when(
        loading: () => Center(
              child: CircularProgressIndicator(),
            ),
        error: (error, stack) => Center(
              child: Text("error"),
            ),
        data: (markers) {
          print(markers);
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

          return GoogleMap(
            onLongPress: (LatLng pos) {
              userMarker.value = MypeMarker(
                imageIds: [],
                groupIds: Set(),
                latitude: pos.latitude,
                longitude: pos.longitude,
              );
            },
            onTap: (_) => userMarker.value = null,
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
}
