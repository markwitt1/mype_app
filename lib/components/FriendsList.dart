import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/components/BadText.dart';
import 'package:mype_app/controllers/friends_controller.dart';
import 'package:mype_app/controllers/user_controller.dart';
import 'package:mype_app/components/FriendProfilePicture.dart';

class FriendsList extends HookWidget {
  const FriendsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userController = useProvider(userControllerProvider);
    final friends = useProvider(friendsControllerProvider.state);
    if (friends.isEmpty) return Center(child: BadText("No friends..."));
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, i) {
        final key = friends.keys.elementAt(i);
        final friend = friends[key]!;
        return ListTile(
          leading: friend.profilePicture != null
              ? FriendProfilePicture(fileName: friend.profilePicture!)
              : null,
          title: Text(friend.name),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              userController.removeFriend(friend.id!);
            },
          ),
        );
      },
    );
  }
}
