import 'package:flutter/material.dart';

import 'package:mype_app/screens/Profile.dart';
import 'package:mype_app/screens/GroupsScreen.dart';
import 'FireMap.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int bottomBarIndex = 0;

  List<Widget> screens = [FireMap(), GroupsScreen(), Profile()];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: IndexedStack(
          index: bottomBarIndex,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bottomBarIndex,
          onTap: (i) => setState(() {
            bottomBarIndex = i;
          }),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: "Groups"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
          ],
        ),
      ),
    );
  }
}
