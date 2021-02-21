import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mype_app/screens/windows/FriendWindow.dart';
import 'package:mype_app/screens/windows/GroupWindow.dart';

enum AddButtonType { group, friend }

class AddButton extends StatelessWidget {
  final AddButtonType type;
  const AddButton(this.type, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        type == AddButtonType.group ? Icons.group_add : Icons.person_add,
        color: Colors.white,
      ),
      onPressed: () {
        type == AddButtonType.group
            ? Get.to(GroupWindow())
            : Get.to(FriendWindow());
      },
    );
  }
}
