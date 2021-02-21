import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mype_app/components/AddButton.dart';
import 'package:mype_app/controllers/GroupsController.dart';
import 'package:mype_app/controllers/UserController.dart';

class GroupsScreen extends StatefulWidget {
  GroupsScreen({Key key}) : super(key: key);

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen>
    with SingleTickerProviderStateMixin {
  final tabs = [
    Tab(
      text: "Groups",
    ),
    Tab(
      text: "Friends",
    ),
  ];
  TabController _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    _tabController = TabController(
        vsync: this, length: tabs.length, initialIndex: _tabIndex);
    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Groups"),
        bottom: TabBar(controller: _tabController, tabs: tabs),
        actions: [
          [
            AddButton(AddButtonType.group),
            AddButton(AddButtonType.friend)
          ][_tabIndex]
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          GetBuilder<GroupsController>(
            init: GroupsController(),
            builder: (_) => ListView.builder(
              itemCount: _.groups.length,
              itemBuilder: (context, i) => ListTile(
                title: Text(_.groups.values.toList()[i].name),
                trailing: IconButton(
                  icon: Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          GetBuilder<UserController>(
            init: UserController(),
            builder: (_) => ListView.builder(
              itemCount: _.user.friendIds.length,
              itemBuilder: (context, i) => FutureBuilder(
                  future: _.getUser(_.user.friendIds[i]),
                  builder: (context, future) {
                    if (future.connectionState == ConnectionState.done) {
                      return ListTile(title: Text(future.data.name));
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ),
          )
        ],
      ),
    );
  }
}
