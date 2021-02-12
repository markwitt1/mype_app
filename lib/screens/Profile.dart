import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mype_app/controllers/AuthController.dart';
import 'package:mype_app/controllers/UserController.dart';

class Profile extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Get.find<UserController>().user.id != null
          ? Column(
              children: [
                Text(Get.find<UserController>().user.name),
                Text(Get.find<UserController>().user.email),
                RaisedButton(
                  onPressed: () {
                    controller.signOut();
                  },
                  child: Text("Sign out"),
                )
              ],
            )
          : Text("lost"),
    );
  }
}
