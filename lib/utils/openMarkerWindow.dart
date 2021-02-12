import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../screens/MarkerWindow.dart';

openMarkerWindow(String markerId) {
  Get.to(MarkerWindow(
    markerId: markerId,
  ));
}
