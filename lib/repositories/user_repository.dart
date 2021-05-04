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

  Future<User?> getUserByCode(String code) async {
    try {
      QuerySnapshot snapshot = await _read(firebaseFirestoreProvider)
          .collection("users")
          .where("code", isEqualTo: code)
          .get();

      if (snapshot.docs[0].exists) return User.fromDocument(snapshot.docs[0]);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<User?> getUser(String uid) async {
    try {
      DocumentSnapshot _doc = await _read(firebaseFirestoreProvider)
          .collection("users")
          .doc(uid)
          .get();
      if (_doc.exists) return User.fromDocument(_doc);
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  Future<Map<String, User>> getFriends(String userId) async {
    try {
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
    } on CustomException catch (e) {
      _read(exceptionProvider).state = e;
      return {};
    }
  }

  Future<User?> createNewUser(User user) async {
    try {
      await _read(firebaseFirestoreProvider)
          .collection("users")
          .doc(user.id)
          .set(user.toJson());
      return user;
    } on FirebaseException catch (fe) {
      final e = CustomException(message: fe.message);
      _read(exceptionProvider).state = e;
      throw e;
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
      } on FirebaseException catch (fe) {
        final e = CustomException(message: fe.message);
        _read(exceptionProvider).state = e;
        throw e;
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
    } on FirebaseException catch (fe) {
      final e = CustomException(message: fe.message);
      _read(exceptionProvider).state = e;
      throw e;
    }
  }

  removeFriend(User user1, String user2Id) async {
    try {
      user1.friendIds.remove(user2Id);

      _read(firebaseFirestoreProvider)
          .collection("users")
          .doc(user1.id!)
          .update({
        "friendIds": FieldValue.arrayRemove([user2Id])
      });
      _read(firebaseFirestoreProvider).collection("users").doc(user2Id).update({
        "friendIds": FieldValue.arrayRemove([user1.id!])
      });
      return user1;
    } on FirebaseException catch (fe) {
      final e = CustomException(message: fe.message);
      _read(exceptionProvider).state = e;
      throw e;
    }
  }
}
