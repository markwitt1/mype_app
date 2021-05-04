import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/components/BadText.dart';
import 'package:mype_app/controllers/friends_controller.dart';
import 'package:mype_app/controllers/user_controller.dart';
import 'package:mype_app/components/FriendProfilePicture.dart';
import 'package:mype_app/components/UserDialog.dart';

class FriendsList extends HookWidget {
  get wantKeepAlive => true;

  const FriendsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final friendsController = useProvider(friendsControllerProvider);
    final userController = useProvider(userControllerProvider);
    final friends = useProvider(friendsControllerProvider.state);
    if (friends.isEmpty)
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BadText("No friends..."),
          TextButton.icon(
            onPressed: friendsController.getFriends,
            icon: Icon(Icons.refresh),
            label: Text("Refresh"),
          ),
        ],
      );
    return RefreshIndicator(
      onRefresh: friendsController.getFriends,
      child: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, i) {
          final key = friends.keys.elementAt(i);
          final friend = friends[key]!;
          return ListTile(
            onTap: () => showUserDialog(context, friend),
            leading: FriendProfilePicture(fileName: friend.profilePicture),
            title: Text(friend.name),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                userController.removeFriend(friend.id!);
              },
            ),
          );
        },
      ),
    );
  }
}
