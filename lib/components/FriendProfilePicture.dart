import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/repositories/images_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FriendProfilePicture extends HookWidget {
  final String? fileName;
  const FriendProfilePicture({Key? key, required this.fileName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imagesRepo = useProvider(imagesRepositoryProvider);
    final imageUrl = useState<String?>(null);

    useEffect(() {
      if (fileName != null)
        imagesRepo
            .getImageUrl(fileName!)
            .then((value) => imageUrl.value = value);
    }, []);

    if (fileName != null) {
      return CircleAvatar(
          backgroundImage: (imageUrl.value != null)
              ? CachedNetworkImageProvider(imageUrl.value!) as ImageProvider
              : AssetImage("image_missing.png"));
    } else {
      return CircleAvatar(backgroundImage: AssetImage("assets/profile.png"));
    }
  }
}
