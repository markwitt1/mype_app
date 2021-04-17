import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/models/mype_marker/mype_marker.dart';

final userMarkerControllerProvider =
    StateNotifierProvider((ref) => UserMarkerController(ref.read));

class UserMarkerController extends StateNotifier<MypeMarker?> {
  final Reader _read;

  UserMarkerController(this._read) : super(null);

/*   addMarker(LatLng position) {
    state = MypeMarker(
      imageIds: [],
      groupIds: Set(),
      marker: Marker(
        markerId: MarkerId("user"),
        position: position,
        infoWindow: InfoWindow(
            title: "new Marker",
            snippet: 'Click to edit',
            onTap: () => openMarkerWindow("user")),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
  }
 */
  clearUserMarker() {
    state = null;
  }
}
