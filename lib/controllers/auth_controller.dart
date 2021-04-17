import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/repositories/custom_exception.dart';
import '../repositories/auth_repository.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController>((ref) => AuthController(ref.read));

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
    try {} on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  void appStarted() async {
/*     if (user==null){
      await _read(authRepositoryProvider).signIn(email, password)
    } */
  }

  void signOut() async {
    await _read(authRepositoryProvider).signOut();
  }

  void createUser(String name, String email, String password,
      PhoneAuthCredential? phoneAuthCredential, String? phoneNumber) async {
    state = await _read(authRepositoryProvider)
        .createUser(name, email, password, phoneAuthCredential, phoneNumber);
  }
}
