import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/auth_controller.dart';
import 'package:mype_app/models/group_model/group_model.dart';
import 'package:mype_app/repositories/groups_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

final groupsControllerProvider = StateNotifierProvider((ref) {
  final User? user = ref.watch(authControllerProvider.state);
  print(user);
  return GroupsController(ref.read, user?.uid)..getGroups();
});

class GroupsController extends StateNotifier<AsyncValue<Map<String, Group>>> {
  final Reader _read;
  final String? _userId;

  GroupsController(this._read, this._userId) : super(AsyncValue.loading());

/*   Future<void> getMarkers({bool isRefreshing = false}) async {
    if (_userId == null) throw CustomException(message: "not logged in");
    if (isRefreshing) state = AsyncValue.loading();
    try {
      final markers = await _read(groupsRepositoryProvider).getGroups(_userId!);
      if (mounted) state = AsyncValue.data(markers);
    } on CustomException catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  } */

  void getGroups() async {
    if (_userId != null) {
      final groups =
          await await _read(groupsRepositoryProvider).getGroups(_userId!);
      if (mounted) state = AsyncValue.data(groups);
    } else {
       if (mounted) state = AsyncValue.error("User not logged in");
    }
  }

  void createGroup(String name, Set<String> userIds) async {
    Group group = Group(name: name, userIds: userIds);
    DocumentSnapshot doc = _read(groupsRepositoryProvider).createGroup(group);
    final newMap =
        state.data != null ? state.data!.value : new Map<String, Group>();
    newMap[doc.id] = Group.fromDocument(doc);
    state = AsyncValue.data(newMap);
    //return group.copyWith(id: doc.id);
  }
/*     getGroupIds() async {
    await getGroups();
    return groups.values.map((GroupModel group) => group.id).toList();
  } */
}
