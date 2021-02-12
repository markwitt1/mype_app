import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mype_app/controllers/UserController.dart';
import 'package:mype_app/models/Group.dart';

class GroupsController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxMap<String, GroupModel> groups = RxMap<String, GroupModel>();

  getGroupIds() async {
    await getGroups();
    return groups.values.map((GroupModel group) => group.id).toList();
  }

  getGroups() async {
    QuerySnapshot querySnapshot = await firestore
        .collection("groups")
        .where("userIds", arrayContains: Get.find<UserController>().user.id)
        .get();
    if (querySnapshot.size > 0) {
      for (final doc in querySnapshot.docs) {
        groups[doc.id] = GroupModel.fromDocumentSnapshot(doc);
      }
      update();
    }
  }
}
