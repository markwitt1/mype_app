import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mype_app/controllers/AuthController.dart';
import '../models/User.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:devicelocale/devicelocale.dart';

class UserController extends GetxController {
  init() {
    Get.find<AuthController>().loadUser();
  }

  Rx<UserModel> _userModel = UserModel().obs;

  UserModel get user => _userModel.value;

  set user(UserModel value) {
    this._userModel.value = value;
    update();
  }

  void clear() {
    _userModel.value = UserModel();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createNewUser(UserModel user) async {
    String locale = await Devicelocale.currentLocale;

    try {
      await _firestore.collection("users").doc(user.id).set({
        "name": user.name,
        "email": user.email,
        "phoneNumber": user.phoneNumber
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot _doc =
          await _firestore.collection("users").doc(uid).get();

      return UserModel.fromDocumentSnapshot(_doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  getUserByPhoneNumber(String phoneNumber) async {
    String locale = await Devicelocale.currentLocale;

    try {
      final parsedPhoneNumber = (await FlutterLibphonenumber()
          .parse(phoneNumber, region: locale))["e164"];
      QuerySnapshot querySnapshot = await _firestore
          .collection("users")
          .where("phoneNumber", isEqualTo: parsedPhoneNumber)
          .get();
      if (querySnapshot.size == 1)
        return UserModel.fromDocumentSnapshot(querySnapshot.docs[0]);
    } catch (e) {
      print(e);
    }
  }

  addFriend(String friendId) async {
    user.friendIds.add(friendId);
    _firestore
        .collection("users")
        .doc(user.id)
        .set({"friendIds": user.friendIds}, SetOptions(merge: true));
    update();
  }
}
