import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/repositories/user_repository.dart';

import '../models/user_model/user_model.dart' as UserModel;
import '../general_providers.dart';
import 'custom_exception.dart';

abstract class BaseAuthRepository {
  Stream<User?> get authStateChanges;
  Future<void> signIn(String email, String password);
  User? getCurrentUser();
  Future<void> signOut();
  Future<void> createUser(String name, String email, String password,
      PhoneAuthCredential phoneAuthCredential, String phoneNumber);
}

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository(ref.read));

class AuthRepository implements BaseAuthRepository {
  final Reader _read;

  const AuthRepository(this._read);

  @override
  Stream<User?> get authStateChanges =>
      _read(firebaseAuthProvider).authStateChanges();

  @override
  User? getCurrentUser() => _read(firebaseAuthProvider).currentUser;

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _read(firebaseAuthProvider)
          .signInWithEmailAndPassword(email: email.trim(), password: password);
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      _read(firebaseAuthProvider).signOut();
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  Future<User?> createUser(String name, String email, String password,
      PhoneAuthCredential? phoneAuthCredential, String? phoneNumber) async {
    UserCredential _authResult = await _read(firebaseAuthProvider)
        .createUserWithEmailAndPassword(
            email: email.trim(), password: password);
            if (phoneAuthCredential != null && phoneNumber != null){
              await _authResult.user!.updatePhoneNumber(phoneAuthCredential);
            }
    await _read(userRepositoryProvider).createNewUser(UserModel.User(id:_authResult.user!.uid, name:name,email: email,phoneNumber: phoneNumber!,friendIds: Set.identity()));
    return _read(firebaseAuthProvider).currentUser;

  }
}
