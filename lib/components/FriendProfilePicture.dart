import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/repositories/images_repository.dart';

class FriendProfilePicture extends HookWidget {
  final String fileName;
  const FriendProfilePicture({Key? key, required this.fileName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imagesRepo = useProvider(imagesRepositoryProvider);
    return FutureBuilder(
      future: imagesRepo.getImage(fileName),
      builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return CircularProgressIndicator();
        else
          return CircleAvatar(backgroundImage: FileImage(snapshot.data!));
      },
    );
  }
}
