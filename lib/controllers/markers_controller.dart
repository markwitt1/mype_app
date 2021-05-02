import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/auth_controller.dart';
import 'package:mype_app/controllers/groups_controller.dart';
import 'package:mype_app/models/group_model/group_model.dart';
import 'package:mype_app/models/mype_marker/mype_marker.dart';
import 'package:mype_app/repositories/custom_exception.dart';
import 'package:mype_app/repositories/marker_repository.dart';

/* final markersStreamProvider =
    StreamProvider.autoDispose<Set<MypeMarker>>((ref) async* {
  final Map<String, Group>? groups =
      ref.watch(groupsControllerProvider.state);
  if (groups != null) {
    final stream = ref
        .read(markerRepositoryProvider)
        .markersStream(groupI.data!.value.keys.toSet());
    await for (final snapshot in stream) {
      yield snapshot.docs.map((doc) => MypeMarker.fromDocument(doc)).toSet();
    }
  }
});
 */
// ignore: top_level_function_literal_block
final markersControllerProvider = StateNotifierProvider((ref) {
  final user = ref.watch(authControllerProvider.state);
  final groups = ref.watch(groupsControllerProvider.state).values.toList();
  return MarkersController(ref.read, user?.uid, groups)..getMarkers();
});

class MarkersController
    extends StateNotifier<AsyncValue<Map<String, MypeMarker>>> {
  final Reader _read;
  final String? _userId;
  final List<Group> _groups;

  MarkersController(this._read, this._userId, this._groups)
      : super(AsyncValue.loading());

/*   listen() {
    _read(markersStreamProvider).whenData((data) => state = AsyncValue.data(
        Map.fromIterable(data, key: (m) => m.id, value: (m) => m)));
  } */

  Future<void> getMarkers({bool isRefreshing = false}) async {
    if (_userId != null) {
      if (isRefreshing) state = AsyncValue.loading();
      try {
        final markers = await _read(markerRepositoryProvider).getMarkers(
            _groups.where((g) => g.id != null).map((g) => g.id!).toList());
        if (mounted) state = AsyncValue.data(markers);
      } on CustomException catch (e, st) {
        state = AsyncValue.error(e, st);
      }
    } else {
      throw CustomException(message: "not logged in");
    }
  }

  Future<void> addMarker(MypeMarker marker) async {
    MypeMarker newMarker =
        await _read(markerRepositoryProvider).addMarker(marker);
    final newState = {newMarker.id!: newMarker, ...?state.data?.value};
    state = AsyncValue.data(newState);
  }

  Future<void> updateMarker(String markerId, MypeMarker newMarker) async {
    await _read(markerRepositoryProvider).updateMarker(markerId, newMarker);
    state = AsyncValue.data({markerId: newMarker, ...?state.data?.value});
  }
}
