import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/auth_controller.dart';
import 'package:mype_app/models/user_model/user_model.dart';
import 'package:mype_app/repositories/custom_exception.dart';
import 'package:mype_app/repositories/user_repository.dart';

// ignore: top_level_function_literal_block
final userControllerProvider = StateNotifierProvider((ProviderReference ref) {
  final firebaseUser = ref.watch(authControllerProvider.state);
  return UserController(ref.read, firebaseUser?.uid)..appStarted();
});

class UserController extends StateNotifier<User?> {
  final Reader _read;
  final String? _userId;

  UserController(this._read, this._userId) : super(null);

  Future<void> appStarted() async {
    if (_userId != null) {
      try {
        User? user = await _read(userRepositoryProvider).getUser(_userId!);
        state = user;
      } on FirebaseException catch (e) {
        state = null;
        throw CustomException(message: e.message);
      }
    }
  }

  removeFriend(String friendId) async {
    state = await _read(userRepositoryProvider).removeFriend(state!, friendId);
  }

  updateUser(User updated) async {
    if (_userId != null && _userId == updated.id) {
      try {
        User? user = await _read(userRepositoryProvider).updateUser(updated);
        if (user != null) state = user;
      } on CustomException catch (e) {
        _read(exceptionProvider).state = e;
        print(e.toString());
        state = null;
      }
    }
  }
}
