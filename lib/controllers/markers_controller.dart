import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/auth_controller.dart';
import 'package:mype_app/controllers/groups_controller.dart';
import 'package:mype_app/models/group_model/group_model.dart';
import 'package:mype_app/models/mype_marker/mype_marker.dart';
import 'package:mype_app/repositories/custom_exception.dart';
import 'package:mype_app/repositories/marker_repository.dart';

final markersStreamProvider =
    StreamProvider.autoDispose<Set<MypeMarker>>((ref) async* {
  final AsyncValue<Map<String, Group>> groupIds =
      ref.watch(groupsControllerProvider.state);
  if (groupIds.data != null) {
    final stream = ref
        .read(markerRepositoryProvider)
        .markersStream(groupIds.data!.value.keys.toSet());
    await for (final snapshot in stream) {
      yield snapshot.docs.map((doc) => MypeMarker.fromDocument(doc)).toSet();
    }
  }
});

final markersControllerProvider = StateNotifierProvider((ref) {
  final user = ref.watch(authControllerProvider.state);
  return MarkersController(ref.read, user?.uid)..listen();
});

class MarkersController
    extends StateNotifier<AsyncValue<Map<String, MypeMarker>>> {
  final Reader _read;
  final String? _userId;

  MarkersController(this._read, this._userId) : super(AsyncValue.loading());

  listen() {
    _read(markersStreamProvider).whenData((data) => state = AsyncValue.data(
        Map.fromIterable(data, key: (m) => m.id, value: (m) => m)));
  }

  Future<void> getMarkers({bool isRefreshing = false}) async {
    if (_userId != null) {
      if (isRefreshing) state = AsyncValue.loading();
      try {
        final markers =
            await _read(markerRepositoryProvider).getMarkers(_userId!);
        if (mounted) state = AsyncValue.data(markers);
      } on CustomException catch (e, st) {
        state = AsyncValue.error(e, st);
      }
    } else {
      throw CustomException(message: "not logged in");
    }
  }

  Future<void> addMarker(LatLng pos, {bool isUserMarker = true}) async {
    MypeMarker newMarker;
    if (isUserMarker) {
      newMarker = MypeMarker(
        imageIds: [],
        groupIds: Set.identity(),
        latitude: pos.latitude,
        longitude: pos.longitude,
      );
    } else {
      newMarker = await _read(markerRepositoryProvider).addMarker(pos);
    }
    if (state.data != null) {
      final newValue = state.data!.value;
      newValue[newMarker.id] = newMarker;
      state = AsyncValue.data(newValue);
      print(state);
    } else {
      state = AsyncValue.data({newMarker.id: newMarker});
    }
  }

  Future<void> updateMarker(String markerId, MypeMarker newMarker) async {
    try {
      await _read(markerRepositoryProvider).updateMarker(markerId, newMarker);
      if (state.data != null) {
        state.data!.value[markerId] = newMarker;
      } else {
        state = AsyncValue.data({markerId: newMarker});
      }
    } on CustomException catch (e) {}
  }
}
