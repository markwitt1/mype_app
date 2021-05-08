import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/components/BadText.dart';
import 'package:mype_app/components/FriendProfilePicture.dart';
import 'package:mype_app/controllers/contacts_controller.dart';
import 'package:mype_app/controllers/friend_requests_controller.dart';
import './UserDialog.dart';

class ContactsList extends HookWidget {
  const ContactsList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final contactsController = useProvider(contactsControllerProvider);
    final contacts = useProvider(contactsControllerProvider.state);
    final friendRequestsController =
        useProvider(friendRequestsControllerProvider);
    final friendRequests = useProvider(friendRequestsControllerProvider.state);
    return contacts.when(
        data: (contactUserMap) {
          if (contactUserMap.isEmpty)
            return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(child: BadText("None of your contacts use MYPE"))
            ]);

          contactUserMap.removeWhere((_, user) =>
              friendRequests["outgoing"]!.any((fr) => fr.to == user.id));
          return RefreshIndicator(
            onRefresh: contactsController.getUsersFromContacts,
            child: ListView.builder(
              itemCount: contactUserMap.length,
              itemBuilder: (_, i) {
                final contact = contactUserMap.keys.elementAt(i);
                final user = contactUserMap[contact];
                return ListTile(
                  leading: FriendProfilePicture(
                    fileName: user!.profilePicture,
                  ),
                  title: Text((contact.displayName != null)
                      ? contact.displayName!
                      : "Unnamed Contact"),
                  subtitle: Text(user.name),
                  onTap: () => showUserDialog(context, user),
                  trailing: IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: () {
                      friendRequestsController
                          .sendFriendRequest(user.id!)
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("friend request sent!"),
                          ),
                        );
                      });

                      contactsController.getUsersFromContacts();
                    },
                  ),
                );
              },
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Text("Error: $e"));
  }
}
