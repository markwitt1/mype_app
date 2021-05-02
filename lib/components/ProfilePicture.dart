import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProfilePicture extends HookWidget {
  final File? image;
  const ProfilePicture({this.image, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        margin: EdgeInsets.only(top: 48),
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            child: CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 12.0,
                      child: Icon(
                        Icons.camera_alt,
                        size: 15.0,
                        color: Color(0xFF404040),
                      ),
                    ),
                  ),
                  radius: 38.0,
                  backgroundImage: image != null
                      ? FileImage(image!) as ImageProvider
                      : AssetImage('assets/profile.png'),
                )),
          )),
    ]);
  }
}
