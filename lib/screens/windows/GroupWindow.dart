import 'package:flutter/material.dart';

class GroupWindow extends StatefulWidget {
  GroupWindow({Key key}) : super(key: key);

  @override
  _GroupWindowState createState() => _GroupWindowState();
}

class _GroupWindowState extends State<GroupWindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Group"),
      ),
      body: Text("yolo"),
    );
  }
}
