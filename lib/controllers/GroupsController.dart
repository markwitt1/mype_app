/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mype_app/controllers/UserController.dart';
import 'package:mype_app/models/Group.dart';
import 'package:mype_app/models/User.dart';

class GroupsController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxMap<String, GroupModel> groups = RxMap<String, GroupModel>();

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

  createGroup(String name, Set<UserModel> users) async {
    users.add(Get.find<UserController>().user);
    final ids = users.map((user) => user.id);
    GroupModel group = GroupModel(name: name, userIds: ids.toList());
    final document = await firestore.collection("groups").add({
      "name": group.name,
      "userIds": group.userIds,
    });
    group.id = document.id;
    update();
  }
}
 */
