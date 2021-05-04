import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/general_providers.dart';
import 'package:mype_app/models/group_model/group_model.dart';

import 'custom_exception.dart';

final groupsRepositoryProvider =
    Provider<GroupsRepository>((ref) => GroupsRepository(ref.read));

class GroupsRepository {
  final Reader _read;

  const GroupsRepository(this._read);

  createGroup(Group group) async {
    //users.add(Get.find<UserController>().user);
    try {
      final doc = await _read(firebaseFirestoreProvider)
          .collection("groups")
          .add(group.toJson());
      return group.copyWith(id: doc.id);
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  Future<Group> updateGroup(Group group) async {
    try {
      await _read(firebaseFirestoreProvider)
          .collection("groups")
          .doc(group.id)
          .update(group.toJson());
      return group;
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  Future<void> deleteGroup(String groupId) async {
    try {
      await _read(firebaseFirestoreProvider)
          .collection("groups")
          .doc(groupId)
          .delete();
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  getGroups(String userId) async {
    Map<String, Group> groups = Map();
    QuerySnapshot querySnapshot = await _read(firebaseFirestoreProvider)
        .collection("groups")
        .where("userIds", arrayContains: userId)
        .get();
    for (final doc in querySnapshot.docs) {
      groups[doc.id] = Group.fromDocument(doc);
    }
    return groups;
  }
}
