import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/friends_controller.dart';
import 'package:mype_app/controllers/groups_controller.dart';
import 'package:mype_app/controllers/user_controller.dart';
import 'package:mype_app/models/group_model/group_model.dart';
import 'package:mype_app/components/FriendProfilePicture.dart';

class GroupWindow extends HookWidget {
  final _fbKey = GlobalKey<FormBuilderState>();
  final Group? group;
  GroupWindow({this.group});

  @override
  Widget build(BuildContext context) {
    final user = useProvider(userControllerProvider.state);
    final friends = useProvider(friendsControllerProvider.state);
    final groupsController = useProvider(groupsControllerProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(group == null ? "Add Group" : "Group: ${group!.name}"),
        ),
        body: FormBuilder(
          key: _fbKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                FormBuilderTextField(
                  name: "name",
                  decoration: InputDecoration(labelText: "Name"),
                  initialValue: group != null ? group!.name : "",
                ),
                FormBuilderTextField(
                  name: "description",
                  decoration: InputDecoration(labelText: "Description"),
                  initialValue: group != null ? group!.description : "",
                ),
                user != null
                    ? FormBuilderField<List<String>>(
                        builder: (state) {
                          if (friends.isEmpty)
                            return Text("You have no friends :(");
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: friends.length,
                              itemBuilder: (_, i) {
                                final List<String> addedUsers =
                                    state.value != null ? state.value! : [];
                                String key = friends.keys.elementAt(i);
                                final friend = friends[key]!;
                                return CheckboxListTile(
                                  secondary: FriendProfilePicture(
                                      fileName: friend.profilePicture),
                                  title: Text(friends[key]!.name),
                                  onChanged: (bool? selected) {
                                    var newState = state.value!;
                                    if (selected == true) {
                                      newState.add(friend.id!);
                                      state.didChange(newState);
                                    } else if (selected == false) {
                                      newState.remove(key);
                                    }
                                    state.didChange(newState);
                                  },
                                  value: addedUsers.contains(friend.id),
                                );
                              });
                        },
                        initialValue: group != null
                            ? group!.userIds.toList()
                            : [user.id!],
                        name: "userIds")
                    : CircularProgressIndicator(),
                ElevatedButton(
                    onPressed: () async {
                      if (_fbKey.currentState?.value != null &&
                          _fbKey.currentState!.saveAndValidate()) {
                        final name = _fbKey.currentState!.value["name"];
                        final description =
                            _fbKey.currentState!.value["description"];

                        final userIds =
                            _fbKey.currentState!.value["userIds"].toSet();

                        if (group != null) {
                          final updatedGroup = group!.copyWith(
                              name: name,
                              description: description,
                              userIds: userIds);
                          Navigator.of(context).pop(updatedGroup);
                        } else {
                          final newGroup = Group(
                              name: name,
                              description: description,
                              userIds: userIds);
                          Navigator.of(context).pop(newGroup);
                        }
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("error")));
                      }
                    },
                    child: Text("Submit")),
                if (group != null)
                  TextButton.icon(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.red)),
                      onPressed: () {
                        groupsController.deleteGroup(group!.id!);
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.delete),
                      label: Text(
                        "Delete Group",
                      ))
              ],
            ),
          ),
        ));
  }
}
