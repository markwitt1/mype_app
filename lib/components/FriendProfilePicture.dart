import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/repositories/images_repository.dart';

class FriendProfilePicture extends HookWidget {
  final String? fileName;
  const FriendProfilePicture({Key? key, required this.fileName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final file = useState<File?>(null);
    final imagesRepo = useProvider(imagesRepositoryProvider);

    useEffect(() {
      if (fileName != null)
        imagesRepo.getImage(fileName!).then((value) => file.value = value);
    }, []);

    if (fileName != null) {
      if (file.value != null)
        return CircleAvatar(backgroundImage: FileImage(file.value!));
      else
        return CircularProgressIndicator();
    } else {
      return CircleAvatar(backgroundImage: AssetImage("assets/profile.png"));
    }
  }
}
