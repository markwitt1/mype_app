import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mype_app/components/FirebaseImage.dart';

class ProfilePicture extends HookWidget {
  final String? imageId;
  const ProfilePicture({this.imageId, Key? key}) : super(key: key);

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
              height: 80,
              width: 80,
              child: CircleAvatar(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipOval(
                        child: imageId != null
                            ? FirebaseImage(
                                imageId,
                                fit: BoxFit.fill,
                              )
                            : Image.asset("assets/profile.png")),
                    Align(
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
                  ],
                ),
              )))
    ]);
  }
}
