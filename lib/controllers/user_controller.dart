import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/auth_controller.dart';
import 'package:mype_app/models/user_model/user_model.dart';
import 'package:mype_app/repositories/user_repository.dart';

final userControllerProvider = StateNotifierProvider((ref) {
  final firebaseUser = ref.watch(authControllerProvider.state);
  return UserController(ref.read, firebaseUser?.uid)..appStarted();
});

class UserController extends StateNotifier<AsyncValue<User?>> {
  final Reader _read;
  final String? _userId;

  UserController(this._read, this._userId) : super(AsyncValue.loading());

  

  Future<void> appStarted() async {
    if (_userId != null) {
      try {
        User user = await _read(userRepositoryProvider).getUser(_userId!);
        state = AsyncValue.data(user);
      } on FirebaseException catch (e) {
        state = AsyncValue.error(e);
      }
    }
  }
}
