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
  getContacts() async {
    if (await Permission.contacts.request().isGranted) {
      final contacts = await ContactsService.getContacts(withThumbnails: false);
      Map<Contact, UserModel> contactUserMap = Map<Contact, UserModel>();
      for (final contact in contacts) {
        contact.phones.forEach((phone) {
          print(phone.value);
          Get.find<UserController>()
              .getUserByPhoneNumber(phone.value)
              .then((user) {
            if (user != null) {
              contactUserMap[contact] = user;
            }
          });
        });
      }
      return contactUserMap;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Friend"),
        ),
        body: FutureBuilder(
          future: getContacts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.values.length,
                  itemBuilder: (_, i) {
                    final contact = snapshot.data.keys[i];
                    ListTile(
                      title: Text(contact.displayName),
                      subtitle: Text(snapshot.data[contact].name),
                    );
                  });
            }
            return CircularProgressIndicator();
          },
        ));
  }
}
