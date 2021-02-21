import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mype_app/controllers/UserController.dart';
import 'package:mype_app/models/User.dart';
import 'package:permission_handler/permission_handler.dart';

class FriendWindow extends StatefulWidget {
  FriendWindow({Key key}) : super(key: key);

  @override
  _FriendWindowState createState() => _FriendWindowState();
}

class _FriendWindowState extends State<FriendWindow> {
  Map<Contact, UserModel> contactUserMap = Map<Contact, UserModel>();

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
}
