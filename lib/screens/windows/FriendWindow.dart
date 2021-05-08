import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/components/UserDialog.dart';
import 'package:mype_app/controllers/contacts_controller.dart';
import 'package:mype_app/controllers/friend_requests_controller.dart';
import 'package:mype_app/controllers/friends_controller.dart';
import 'package:mype_app/controllers/user_controller.dart';
import 'package:mype_app/components/ContactsList.dart';
import 'package:mype_app/components/CopyButton.dart';
import 'package:mype_app/components/IncomingFriendRequests.dart';
import '../../utils/createFriendLink.dart';
import 'package:share/share.dart';

class FriendWindow extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final user = useProvider(userControllerProvider.state);
    final friendsController = useProvider(friendsControllerProvider);
    final friendRequestsController =
        useProvider(friendRequestsControllerProvider);
    final contactsController = useProvider(contactsControllerProvider);
    final textController =
        useTextEditingController.fromValue(TextEditingValue.empty);

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Friend"),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                contactsController.getUsersFromContacts();
                friendRequestsController.getFriendRequests();
              })
        ],
      ),
      body: Column(children: [
        IncomingFriendRequests(),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SelectableText(
                  "My User ID: ${user != null ? user.id : "loading..."}"),
              CopyButton(user != null ? user.id : null),
              TextButton.icon(
                  icon: Icon(Icons.share),
                  label: Text("SHARE LINK"),
                  onPressed: () async {
                    String link =
                        await createFriendLink(user!.id!.substring(0, 10));
                    Share.share(link);
                  }),
              TextField(
                controller: textController,
                decoration: InputDecoration(hintText: "Enter Friends ID"),
              ),
              IconButton(
                icon: Icon(Icons.person_add),
                onPressed: () async {
                  if (textController.text != "") {
                    final otherUser =
                        await friendsController.getUser(textController.text);
                    textController.clear();

                    if (otherUser != null)
                      await showUserDialog(context, otherUser);
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ContactsList(),
        ),
      ]),
    );
  }
}
