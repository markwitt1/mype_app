import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:mype_app/general_providers.dart';
import 'package:mype_app/models/user_model/user_model.dart';
import 'package:mype_app/utils/formatPhoneNumber.dart';

import 'custom_exception.dart';

abstract class BaseUserRepository {}

final userRepositoryProvider =
    Provider<UserRepository>((ref) => UserRepository(ref.read));

class UserRepository implements BaseUserRepository {
  final Reader _read;

  const UserRepository(this._read);

  Future<User?> getUser(String uid) async {
    try {
      DocumentSnapshot _doc = await _read(firebaseFirestoreProvider)
          .collection("users")
          .doc(uid)
          .get();
      if (_doc.exists) return User.fromDocument(_doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Map<String, User>> getFriends(String userId) async {
    final user = await getUser(userId);
    Map<String, User> friends = Map();
    if (user != null) {
      for (final id in user.friendIds) {
        final user = await getUser(id);
        friends[id] = user!;
      }
      return friends;
    } else
      return {};
  }

  Future<User?> createNewUser(User user) async {
    try {
      await _read(firebaseFirestoreProvider)
          .collection("users")
          .doc(user.id)
          .set(user.toJson());
      return user;
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  Future<User?> updateUser(User user) async {
    if (user.id == null) {
      throw new CustomException(message: "User doesn't have ID");
    } else {
      try {
        await _read(firebaseFirestoreProvider)
            .collection("users")
            .doc(user.id)
            .set(user.toJson());
        return user;
      } on FirebaseException catch (e) {
        throw CustomException(message: e.message);
      }
    }
  }

  Future<User?> getUserByPhoneNumber(String phoneNumber) async {
    try {
      QuerySnapshot querySnapshot = await _read(firebaseFirestoreProvider)
          .collection("users")
          .where("phoneNumber", isEqualTo: formatPhoneNumber(phoneNumber))
          .get();
      if (querySnapshot.size == 1)
        return User.fromDocument(querySnapshot.docs[0]);
      else {
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

/*   UserModel get user => _userModel.value;
 */
/*   set user(UserModel value) {
    this._userModel.value = value;
    getFriends();
    update();
  }

  void clear() {
    _userModel.value = UserModel();
  } */

/*   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 */
/*   

  Future<UserModel> getUser(String uid) async {
    print(uid);
    try {
      DocumentSnapshot _doc = await _read(firebaseFirestoreProvider)
          .collection("users")
          .doc(uid)
          .get();

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
  } */
}
