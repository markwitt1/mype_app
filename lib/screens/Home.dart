import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/navigation_controller.dart';
import 'package:mype_app/screens/FireMap.dart';
import 'package:mype_app/screens/GroupsScreen/GroupsScreen.dart';
import 'package:mype_app/screens/Profile.dart';

class Home extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final navigationController = useProvider(navigationControllerProvider);
    final navigationBarIndex = useProvider(navigationControllerProvider.state);
    final screens = [FireMap(), GroupsScreen(), Profile()];
    return Scaffold(
      body: IndexedStack(
        index: navigationBarIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationBarIndex,
        onTap: (index) => navigationController.navigate(index),
        items: [
          BottomNavigationBarItem(label: "Map", icon: Icon(Icons.map)),
          BottomNavigationBarItem(label: "Groups", icon: Icon(Icons.people)),
          BottomNavigationBarItem(label: "Profile", icon: Icon(Icons.person))
        ],
      ),
    );
  }
}
