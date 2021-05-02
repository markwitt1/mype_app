import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<ImageSource?> pickImageSource(BuildContext context) async {
  return showModalBottomSheet(
    context: context,
    builder: (_) => ListView(
      shrinkWrap: true,
      children: [
        ListTile(
          leading: Icon(Icons.camera),
          title: Text("Camera"),
          onTap: () => Navigator.of(context).pop(ImageSource.camera),
        ),
        ListTile(
          leading: Icon(Icons.folder),
          title: Text("Gallery"),
          onTap: () => Navigator.of(context).pop(ImageSource.gallery),
        )
      ],
    ),
  );
}
