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
      ref.watch(groupsControllerProvider).state;
  final stream = ref
      .read(markerRepositoryProvider)
      .markersStream(groupIds.data!.value.keys.toSet());

  await for (final snapshot in stream) {
    yield snapshot.docs.map((doc) => MypeMarker.fromDocument(doc));
  }
});

final markersControllerProvider = StateNotifierProvider((ref) {
  final user = ref.watch(authControllerProvider).state;
  return MarkersController(ref.read, user?.uid);
});

class MarkersController
    extends StateNotifier<AsyncValue<Map<String, MypeMarker>>> {
  final Reader _read;
  final String? _userId;

  MarkersController(this._read, this._userId) : super(AsyncValue.loading());

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
}
