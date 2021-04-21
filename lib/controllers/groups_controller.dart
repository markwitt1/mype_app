import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/auth_controller.dart';
import 'package:mype_app/models/group_model/group_model.dart';
import 'package:mype_app/repositories/groups_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: top_level_function_literal_block
final groupsControllerProvider = StateNotifierProvider((ref) {
  final User? user = ref.watch(authControllerProvider.state);
  return GroupsController(ref.read, user?.uid)..getGroups();
});

class GroupsController extends StateNotifier<Map<String, Group>> {
  final Reader _read;
  final String? _userId;

  GroupsController(this._read, this._userId) : super({});

  void getGroups() async {
    if (_userId != null) {
      if (mounted)
        state = await _read(groupsRepositoryProvider).getGroups(_userId!);
    }
  }

  void createGroup(Group data) async {
    Group group = await _read(groupsRepositoryProvider).createGroup(data);
    state = {group.id!: group, ...state};
    //return group.copyWith(id: doc.id);
  }
/*     getGroupIds() async {
    await getGroups();
    return groups.values.map((GroupModel group) => group.id).toList();
  } */
}
