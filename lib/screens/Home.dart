import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:mype_app/screens/FireMap.dart';
import 'package:mype_app/screens/GroupsScreen/GroupsScreen.dart';
import 'package:mype_app/screens/Profile.dart';

class Home extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final navigationBarIndex = useState(0);
    final screens = [FireMap(), GroupsScreen(), Profile()];
    return Scaffold(
      body: IndexedStack(
        index: navigationBarIndex.value,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationBarIndex.value,
        onTap: (index) => navigationBarIndex.value = index,
        items: [
          BottomNavigationBarItem(label: "Map", icon: Icon(Icons.map)),
          BottomNavigationBarItem(label: "Groups", icon: Icon(Icons.people)),
          BottomNavigationBarItem(label: "Profile", icon: Icon(Icons.person))
        ],
      ),
    );
  }
}
