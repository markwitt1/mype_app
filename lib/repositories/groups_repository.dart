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
      final document = await _read(firebaseFirestoreProvider)
          .collection("groups")
          .add(group.toJson());
      return document;
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
