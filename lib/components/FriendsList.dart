import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/components/BadText.dart';
import 'package:mype_app/controllers/user_controller.dart';
import 'package:mype_app/models/user_model/user_model.dart';

class FriendsList extends HookWidget {
  final List<User> friends;
  const FriendsList({Key? key, required this.friends}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userController = useProvider(userControllerProvider);
    if (friends.isEmpty) return Center(child: BadText("No friends..."));
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, i) => ListTile(
        title: Text(friends[i].name),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            userController.removeFriend(friends[i].id!);
          },
        ),
      ),
    );
  }
}
