import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/friends_controller.dart';
import 'package:mype_app/controllers/groups_controller.dart';
import 'package:mype_app/controllers/user_controller.dart';
import 'package:mype_app/models/group_model/group_model.dart';
import 'package:mype_app/models/user_model/user_model.dart';

class GroupWindow extends HookWidget {
  final _fbKey = GlobalKey<FormBuilderState>();
  final Group? group;
  GroupWindow({this.group});

  @override
  Widget build(BuildContext context) {
    final groupsController = useProvider(groupsControllerProvider);
    final user = useProvider(userControllerProvider.state);
    final friends = useProvider(friendsControllerProvider.state);
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Group"),
        ),
        body: FormBuilder(
          key: _fbKey,
          child: Column(
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
                              return CheckboxListTile(
                                title: Text(friends[key]!.name),
                                onChanged: (bool? selected) {
                                  var newState = state.value!;
                                  if (selected == true) {
                                    newState.add(friends[key]!.id!);
                                    state.didChange(newState);
                                  } else if (selected == false) {
                                    newState.remove(friends[key]!.id!);
                                  }
                                  state.didChange(newState);
                                },
                                value: addedUsers.contains(friends[key]!.id),
                              );
                            });
                      },
                      initialValue:
                          group != null ? group!.userIds.toList() : [user.id!],
                      name: "userIds")
                  : CircularProgressIndicator(),
              ElevatedButton(
                  onPressed: () {
                    if (_fbKey.currentState?.value != null &&
                        _fbKey.currentState!.saveAndValidate()) {
                      final name = _fbKey.currentState!.value["name"];
                      final description =
                          _fbKey.currentState!.value["description"];

                      /*                      Set<String> userIds = [user!.id!].toSet();
                      List<User>? users = _fbKey.currentState!.value["users"];
                      if (users != null && users.isNotEmpty) {
                        userIds.addAll(users.map((user) => user.id!));
                      } */

                      final userIds =
                          _fbKey.currentState!.value["userIds"].toSet();

                      if (group != null) {
                        final updatedGroup = group!.copyWith(
                            name: name,
                            description: description,
                            userIds: userIds);
                        //TODO
                      } else {
                        final group = Group(
                            name: name,
                            description: description,
                            userIds: userIds);
                        groupsController.createGroup(group);
                      }
                      Navigator.of(context).pop(true);
                    }
                  },
                  child: Text("Submit"))
            ],
          ),
        ));
  }
}
