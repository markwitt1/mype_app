import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/auth_controller.dart';
import 'package:mype_app/models/group_model/group_model.dart';
import 'package:mype_app/repositories/custom_exception.dart';
import 'package:mype_app/repositories/groups_repository.dart';
import 'package:mype_app/repositories/marker_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

final groupsControllerProvider = StateNotifierProvider((ref) {
  final User? user = ref.watch(authControllerProvider).state;
  return GroupsController(ref.read, user?.uid);
});

class GroupsController extends StateNotifier<AsyncValue<Map<String, Group>>> {
  final Reader _read;
  final String? _userId;

  GroupsController(this._read, this._userId) : super(AsyncValue.loading());

  Future<void> getMarkers({bool isRefreshing = false}) async {
    if (_userId == null) throw CustomException(message: "not logged in");
    if (isRefreshing) state = AsyncValue.loading();
    try {
      final markers = await _read(groupsRepositoryProvider).getGroups(_userId!);
      if (mounted) state = AsyncValue.data(markers);
    } on CustomException catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<Group> createGroup(String name, Set<String> userIds) async {
    Group group = Group(name: name, userIds: userIds);
    DocumentSnapshot doc = _read(groupsRepositoryProvider).createGroup(group);
    return group.copyWith(id: doc.id);
  }
/*     getGroupIds() async {
    await getGroups();
    return groups.values.map((GroupModel group) => group.id).toList();
  } */
}
