import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/components/FriendsList.dart';
import 'package:mype_app/components/GroupsList.dart';
import 'package:mype_app/controllers/friends_controller.dart';
import 'package:mype_app/controllers/groups_controller.dart';
import 'package:mype_app/controllers/user_controller.dart';
import 'package:mype_app/models/user_model/user_model.dart';
import 'package:mype_app/repositories/user_repository.dart';
import 'package:mype_app/screens/windows/FriendWindow.dart';
import 'package:mype_app/screens/windows/GroupWindow.dart';

class GroupsScreen extends HookWidget {
  final tabs = [
    Tab(
      text: "Groups",
    ),
    Tab(
      text: "Friends",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final groups = useProvider(groupsControllerProvider.state);
    final user = useProvider(userControllerProvider.state);
    final friends = useProvider(friendsControllerProvider.state);
    final userRepository = useProvider(userRepositoryProvider);
    final tabIndex = useState(0);
    TabController tabController = useTabController(initialLength: 2);

    tabController.addListener(() {
      tabIndex.value = tabController.index;
    });

    final List<String> friendIds = user != null ? user.friendIds.toList() : [];
    return Scaffold(
      appBar: AppBar(
        title: Text("Groups"),
        bottom: TabBar(controller: tabController, tabs: tabs),
        actions: [
          [
            IconButton(
                icon: Icon(Icons.group_add),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => GroupWindow()));
                }),
            IconButton(
                icon: Icon(Icons.person_add),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => FriendWindow()));
                }),
          ][tabIndex.value]
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          GroupsList(groups),
          FriendsList(
            friends: friends.values.toList(),
          )
        ],
      ),
    );
  }
}
