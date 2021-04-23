import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/components/BadText.dart';
import 'package:mype_app/controllers/friend_requests_controller.dart';
import 'package:mype_app/models/user_model/user_model.dart';

class ContactsList extends HookWidget {
  final Map<Contact, User> contactUserMap;
  const ContactsList(this.contactUserMap, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final friendRequestsController =
        useProvider(friendRequestsControllerProvider);
    if (contactUserMap.isEmpty)
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Center(child: BadText("None of your contacts use MYPE"))]);
    return ListView.builder(
      itemCount: contactUserMap.length,
      itemBuilder: (_, i) {
        final contact = contactUserMap.keys.elementAt(i);
        final user = contactUserMap[contact];
        return ListTile(
          title: Text((contact.displayName != null)
              ? contact.displayName!
              : "Unnamed Contact"),
          subtitle: Text(user!.name),
          trailing: IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              friendRequestsController.sendFriendRequest(user.id!);
            },
          ),
        );
      },
    );
  }
}
