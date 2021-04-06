/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:mype_app/controllers/AuthController.dart';
import 'package:mype_app/models/User.dart';
import '../models/User.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

class UserController extends GetxController {
  Rx<UserModel> _userModel = UserModel().obs;
  RxMap<String, Tuple2<Contact, UserModel>> contactUserMap =
      RxMap<String, Tuple2<Contact, UserModel>>();
  RxMap<String, UserModel> friends = RxMap<String, UserModel>();

  @override
  onInit() async {
    print("test");
    getContacts();

    super.onInit();
  }

  getFriends() async {
    for (final id in _userModel.value.friendIds) {
      final user = await getUser(id);
      friends[id] = user;
    }
    update();
  }

  UserModel get user => _userModel.value;

  set user(UserModel value) {
    this._userModel.value = value;
    getFriends();
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
    print(uid);
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
    contactUserMap.removeWhere((key, value) => value.value2.id == friendId);
    getContacts();
    update();
  }

  removeFriend(String friendId) async {
    user.friendIds.add(friendId);
    _firestore.collection("users").doc(user.id).update({
      "friendIds": FieldValue.arrayRemove([friendId])
    });
    friends.remove(friendId);
    getContacts();
    update();
  }

  getContacts() async {
    if (await Permission.contacts.request().isGranted) {
      try {
        final contacts =
            await ContactsService.getContacts(withThumbnails: false);
        print("test");
        for (final contact in contacts) {
          for (final phone in contact.phones) {
            print(phone.value);
            Get.find<UserController>()
                .getUserByPhoneNumber(phone.value)
                .then((user) {
              if (user != null) {
                final userController = Get.find<UserController>();
                if (user != null &&
                    !userController.friends.containsKey(user.id) &&
                    user.id != userController.user.id) {
                  contactUserMap[phone.value] = Tuple2(contact, user);
                }
              }
            });
          }
        }
      } catch (e) {
        print(e.message);
      }

      update();
    }
  }
}
 */
