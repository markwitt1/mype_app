import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import './UserController.dart';
import '../models/User.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User> _firebaseUser = Rx<User>();

  User get user => _firebaseUser.value;

  @override
  onInit() {
    super.onInit();
    Get.put(UserController());
    _firebaseUser.bindStream(_auth.authStateChanges());
    loadUser();
  }

  loadUser() {
    final userController = Get.find<UserController>();
    if (_auth.currentUser != null) {
      userController.getUser(_auth.currentUser.uid).then((user) {
        Get.find<UserController>().user = user;
      });
    }
  }

  void createUser(String name, String email, String password,
      PhoneAuthCredential phoneAuthCredential, String phoneNumber) async {
    final userController = Get.find<UserController>();

    try {
      UserCredential _authResult = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      await _authResult.user.updatePhoneNumber(phoneAuthCredential);
      UserModel _user = UserModel(
          id: _authResult.user.uid,
          name: name,
          email: _authResult.user.email,
          phoneNumber: phoneNumber);
      if (await userController.createNewUser(_user)) {
        Get.find<UserController>().user = _user;
        Get.back();
      }
    } catch (e) {
      Get.snackbar(
        "Error creating Account",
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void login(String email, String password) async {
    final userController = Get.find<UserController>();

    try {
      UserCredential _authResult = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      Get.find<UserController>().user =
          await userController.getUser(_authResult.user.uid);
    } catch (e) {
      Get.snackbar(
        "Error signing in",
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void signOut() async {
    try {
      await _auth.signOut();
      Get.find<UserController>().clear();
    } catch (e) {
      Get.snackbar(
        "Error signing out",
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
