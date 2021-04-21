import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/user_controller.dart';
import 'package:mype_app/models/friend_request/friend_request.dart';
import 'package:mype_app/models/user_model/user_model.dart';
import 'package:mype_app/repositories/custom_exception.dart';
import 'package:mype_app/repositories/friend_requests_repository.dart';
import 'package:mype_app/repositories/user_repository.dart';

final friendsControllerProvider =
    // ignore: top_level_function_literal_block
    StateNotifierProvider((ProviderReference ref) {
  final user = ref.watch(userControllerProvider.state);
  return FriendsController(ref.read, user)..getFriends();
});

class FriendsController extends StateNotifier<Map<String, User>> {
  final Reader _read;
  final User? _user;
  FriendsController(this._read, this._user) : super({});

  getFriends() async {
    if (_user?.id != null)
      state = await _read(userRepositoryProvider).getFriends(_user!.id!);
  }

  getUser(id) => _read(userRepositoryProvider).getUser(id);

  removeFriend(String id) {}
}
