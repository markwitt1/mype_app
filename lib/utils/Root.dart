import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mype_app/controllers/AuthController.dart';
import 'package:mype_app/controllers/GroupsController.dart';
import 'package:mype_app/controllers/UserController.dart';
import '../screens/Home.dart';
import '../screens/Login.dart';

class Root extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return GetX(
      initState: (_) async {
        Get.put<UserController>(UserController());
        Get.put<GroupsController>(GroupsController());
      },
      builder: (_) {
        if (Get.find<AuthController>().user?.uid != null) {
          return Home();
        } else {
          return Login();
        }
      },
    );
  }
}
