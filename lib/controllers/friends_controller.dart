import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/user_controller.dart';
import 'package:mype_app/models/user_model/user_model.dart';
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

  Future<void> getFriends() async {
    if (mounted && _user?.id != null)
      state = await _read(userRepositoryProvider).getFriends(_user!.id!);
  }

  Future<void> removeFriend(String friendId) async {
    await _read(userRepositoryProvider).removeFriend(_user!, friendId);
    state.remove(friendId);
    state = state;
  }

  Future<User?> getUser(id) => _read(userRepositoryProvider).getUser(id);
}
