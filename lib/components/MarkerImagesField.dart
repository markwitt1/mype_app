import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mype_app/components/FirebaseImage.dart';
import 'package:mype_app/repositories/images_repository.dart';
import 'package:mype_app/utils/pickImageSource.dart';

class MarkerImagesField extends HookWidget {
  final List<String> initialValue;

  const MarkerImagesField({Key? key, this.initialValue = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uploading = useState(0);
    final imagesRepo = useProvider(imagesRepositoryProvider);
    return FormBuilderField<List<String>>(
      name: "imageIds",
      initialValue: initialValue,
      builder: (field) {
        final imageIds = field.value!;
        return Expanded(
          child: GridView.builder(
            itemCount: imageIds.length + uploading.value + 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 5.0,
            ),
            itemBuilder: (_, i) => i < imageIds.length
                ? Hero(
                    tag: imageIds[i],
                    child: GestureDetector(
                      child: FirebaseImage(imageIds[i]),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => Scaffold(
                              appBar: AppBar(
                                actions: [
                                  IconButton(
                                      onPressed: () {
                                        field.value!.remove(imageIds[i]);
                                        field.didChange(field.value);
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(Icons.delete)),
                                  IconButton(
                                      onPressed: () async {
                                        final imageFile = await imagesRepo
                                            .downloadFromFirebase(imageIds[i]);
                                        if (imageFile != null) {
                                          final res =
                                              await ImageGallerySaver.saveFile(
                                                  imageFile.path);
                                          if (res["isSuccess"] == true) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content:
                                                        Text("Image Saved")));
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Error: ${res["errorMessage"]}")));
                                          }
                                        }
                                      },
                                      icon: Icon(Icons.save))
                                ],
                              ),
                              backgroundColor: Colors.black,
                              body: InteractiveViewer(
                                  child: Center(
                                      child: FirebaseImage(field.value![i]))),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : i < imageIds.length + uploading.value
                    ? CircularProgressIndicator()
                    : Center(
                        child: IconButton(
                          icon: Icon(
                            Icons.add,
                          ),
                          onPressed: () async {
                            final imageSource = await pickImageSource(context);
                            if (imageSource != null) {
                              File? newImage =
                                  await imagesRepo.pickImage(imageSource);
                              if (newImage != null) {
                                try {
                                  uploading.value++;
                                  final imageId =
                                      await imagesRepo.upload(newImage);
                                  uploading.value--;
                                  field.didChange([...?field.value, imageId]);
                                } catch (e) {
                                  print(e.toString());
                                }
                              }
                            }
                          },
                        ),
                      ),
          ),
        );
      },
    );
  }
}

/* import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/repositories/images_repository.dart';
import 'package:mype_app/utils/pickImageSource.dart';

import 'FirebaseImage.dart';

class MarkerImagesField extends HookWidget {
  final List<String> initialValue;
  const MarkerImagesField({Key? key, this.initialValue = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imagesRepo = useProvider(imagesRepositoryProvider);
    return FormBuilderField<List<String>>(
      initialValue: initialValue,
      name: "imageIds",
      decoration: InputDecoration(labelText: "Images"),
      builder: (field) => SizedBox(
          height: 100,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...field.value!.map(
                  (imageId) => Flexible(
                      child: Stack(
                    children: [
                      GestureDetector(
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => InteractiveViewer(
                                    child: FirebaseImage(imageId),
                                  ),
                                ),
                              ),
                          child: FirebaseImage(
                            imageId,
                            fit: BoxFit.fitWidth,
                          )),
                      Positioned(
                          top: -5,
                          right: -5,
                          child: IconButton(
                            color: Colors.red,
                            icon: Icon(Icons.close_outlined),
                            onPressed: () {
                              field.value!.remove(imageId);
                              field.didChange(field.value);
                            },
                          ))
                    ],
                  )),
                ),
                IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () async {
                      final imageSource = await pickImageSource(context);
                      if (imageSource != null) {
                        File? newImage =
                            await imagesRepo.pickImage(imageSource);
                        if (newImage != null) {
                          try {
                            final imageId = await imagesRepo.upload(newImage);
                            field.didChange([...?field.value, imageId]);
                          } catch (e) {
                            print(e.toString());
                          }
                        }
                      }
                    })
              ])),
    );
  }
}
 */
