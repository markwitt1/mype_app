import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/repositories/images_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseImage extends HookWidget {
  final BoxFit? fit;
  final String? imageId;
  const FirebaseImage(
    this.imageId, {
    Key? key,
    this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imagesRepo = useProvider(imagesRepositoryProvider);
    final imageUrl = useState<String?>(null);
    final loading = useState(true);
    final future = useMemoized(SharedPreferences.getInstance);
    final sharedPrefs = useFuture(future, initialData: null);

    useEffect(() {
      if (sharedPrefs.data != null && imageUrl.value == null) {
        String? prefsUrl = sharedPrefs.data?.getString("imageUrl:$imageId");
        if (prefsUrl != null) {
          imageUrl.value = prefsUrl;
          loading.value = false;
        } else {
          loading.value = true;
          if (imageId != null && imageUrl.value == null)
            imagesRepo.getImageUrl(imageId!).then((value) async {
              if (value != null)
                await sharedPrefs.data!.setString("imageUrl:$imageId", value);
              imageUrl.value = value;
              loading.value = false;
            });
        }
      }
    }, [sharedPrefs.data]);
    if (loading.value == true) {
      /*        future: Future.delayed(Duration(milliseconds: 0)),
          builder: (_, s) {
            if (s.connectionState == ConnectionState.done) */
      return Center(
          child: CircularProgressIndicator(
        value: 100,
      ));
    } else if (imageUrl.value == null) {
      return Image.asset(
        "assets/image_missing.png",
        fit: fit,
      );
    } else {
      return CachedNetworkImage(
        progressIndicatorBuilder: (_, __, downloadProgress) => ConstrainedBox(
            constraints: new BoxConstraints(maxHeight: 20, maxWidth: 20),
            child: CircularProgressIndicator(
              value: downloadProgress.progress,
            )),
        imageUrl: imageUrl.value!,
        fit: fit,
      );
    }
  }
}
