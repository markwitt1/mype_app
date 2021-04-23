import 'package:flutter/material.dart';
import 'package:mype_app/components/BadText.dart';
import 'package:mype_app/models/group_model/group_model.dart';

class GroupsList extends StatelessWidget {
  final Map<String, Group> _groups;
  const GroupsList(this._groups, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_groups.isNotEmpty)
      return ListView.builder(
        itemCount: _groups.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(_groups.values.toList()[i].name),
          trailing: IconButton(
            icon: Icon(
              Icons.location_on,
              color: Colors.red,
            ),
            onPressed: () {},
          ),
        ),
      );
    else
      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [BadText("No groups...")]);
  }
}
