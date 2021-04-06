import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/user_controller.dart';
import 'package:mype_app/general_providers.dart';
import 'package:mype_app/repositories/custom_exception.dart';
import '../repositories/auth_repository.dart';

final authControllerProvider =
    StateNotifierProvider((ref) => AuthController(ref.read)..appStarted());

class AuthController extends StateNotifier<User?> {
  final Reader _read;

  StreamSubscription<User?>? _authStateChangesSubscription;

  AuthController(this._read) : super(null) {
    _authStateChangesSubscription?.cancel();
    _authStateChangesSubscription = _read(authRepositoryProvider)
        .authStateChanges
        .listen((user) => state = user);
  }

  @override
  void dispose() {
    _authStateChangesSubscription?.cancel();
    super.dispose();
  }

  void login(String email, String password) async {
    try {
      UserCredential _authResult = await _read(firebaseAuthProvider)
          .signInWithEmailAndPassword(email: email.trim(), password: password);
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  void appStarted() async {
    final user = _read(authRepositoryProvider).getCurrentUser();
/*     if (user==null){
      await _read(authRepositoryProvider).signIn(email, password)
    } */
  }

  void signOut() async {
    await _read(authRepositoryProvider).signOut();
  }

  Future<void> createUser(String name, String email, String password,
          PhoneAuthCredential phoneAuthCredential, String phoneNumber) =>
      _read(authRepositoryProvider)
          .createUser(name, email, password, phoneAuthCredential, phoneNumber);
}
