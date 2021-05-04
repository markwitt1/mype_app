import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/components/BadText.dart';
import 'package:mype_app/controllers/groups_controller.dart';
import 'package:mype_app/screens/windows/GroupWindow.dart';

class GroupsList extends HookWidget {
  const GroupsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupsController = useProvider(groupsControllerProvider);
    final groups = useProvider(groupsControllerProvider.state);

    if (groups.isNotEmpty)
      return RefreshIndicator(
        onRefresh: groupsController.getGroups,
        child: ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, i) {
              final key = groups.keys.elementAt(i);
              return ListTile(
                title: Text(groups[key]!.name),
                onTap: () async {
                  final updatedGroup = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => GroupWindow(group: groups[key])));
                  if (updatedGroup != null)
                    groupsController.updateGroup(updatedGroup);
                },
                trailing: IconButton(
                  icon: Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    //TODO:filter
                  },
                ),
              );
            }),
      );
    else
      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BadText("No groups..."),
            TextButton.icon(
                onPressed: groupsController.getGroups,
                icon: Icon(Icons.refresh),
                label: Text("Refresh"))
          ]);
  }
}
