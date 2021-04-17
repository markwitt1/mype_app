/* import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:mype_app/controllers/UserController.dart';
import 'package:mype_app/models/user_model/user_model.dart';
import 'package:permission_handler/permission_handler.dart';

class FriendWindow extends HookWidget {
 Map<Contact, User> contactUserMap = Map<Contact, User>();

  getContacts() async {
    if (await Permission.contacts.request().isGranted) {
      final contacts = await ContactsService.getContacts(withThumbnails: false);
      for (final contact in contacts) {
        for (final phone in contact.phones) {
          print(phone.value);
          Get.find<UserController>()
              .getUserByPhoneNumber(phone.value)
              .then((user) {
            if (user != null &&
                !Get.find<UserController>().user.friendIds.contains(user.id)) {
              setState(() {
                contactUserMap[contact] = user;
              });
            }
          });
        }
      }
    }
  }

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Friend"),
      ),
      body: ListView.builder(
        itemCount: contactUserMap.length,
        itemBuilder: (_, i) {
          final contact = contactUserMap.keys.elementAt(i);
          final user = contactUserMap[contact];
          return ListTile(
            title: Text(contact.displayName),
            subtitle: Text(user.name),
            trailing: IconButton(
              icon: Icon(Icons.person_add),
              onPressed: () {
                Get.find<UserController>().addFriend(user.id);
              },
            ),
          );
        },
      ),
    );
  }

} */