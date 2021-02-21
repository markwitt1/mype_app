import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mype_app/controllers/AuthController.dart';
import 'package:mype_app/controllers/UserController.dart';

class Profile extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    Get.find<AuthController>().loadUser();
    print(Get.find<AuthController>().user);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: GetBuilder<UserController>(
        init: UserController(),
        builder: (_) {
          if (_.user.id != null)
            return Column(
              children: [
                Text(_.user.name),
                Text(_.user.email),
                RaisedButton(
                  onPressed: () {
                    controller.signOut();
                  },
                  child: Text("Sign out"),
                )
              ],
            );
          else {
            Get.find<AuthController>().loadUser();
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
