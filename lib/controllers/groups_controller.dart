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

  Future<void> createGroup(Group data) async {
    Group group = await _read(groupsRepositoryProvider).createGroup(data);
    state = {group.id!: group, ...state};
  }

  Future<void> updateGroup(Group data) async {
    final updated = await _read(groupsRepositoryProvider).updateGroup(data);
    state[updated.id!] = updated;
    state = {...state};
  }
}
