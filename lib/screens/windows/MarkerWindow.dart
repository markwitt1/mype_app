import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/groups_controller.dart';
import 'package:mype_app/controllers/markers_controller.dart';
import 'package:mype_app/models/group_model/group_model.dart';
import 'package:mype_app/models/mype_marker/mype_marker.dart';
import 'package:mype_app/repositories/images_repository.dart';
import 'package:photo_view/photo_view.dart';
import '../../utils/pickImageSource.dart';

class MarkerWindow extends HookWidget {
  final MypeMarker mypeMarker;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  MarkerWindow({required this.mypeMarker}) : super();

  @override
  Widget build(BuildContext context) {
    final imagesRepo = useProvider(imagesRepositoryProvider);
    final markersController = useProvider(markersControllerProvider);
    final groups = useProvider(groupsControllerProvider.state);

    return Scaffold(
      appBar: AppBar(
        title: Text(mypeMarker.id == null
            ? "New Marker"
            : "Marker: ${mypeMarker.title}"),
      ),
      body: FormBuilder(
        key: _fbKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              FormBuilderTextField(
                name: "title",
                decoration: InputDecoration(labelText: "Title"),
                validator: FormBuilderValidators.required(context,
                    errorText: "lease add a title"),
                initialValue: mypeMarker.title,
              ),
              FormBuilderTextField(
                name: "description",
                decoration: InputDecoration(labelText: "Description"),
                initialValue: mypeMarker.description,
              ),
              FormBuilderFilterChip(
                decoration: InputDecoration(
                  labelText: 'Groups:',
                ),
                validator: ((groups) => groups!.length > 0
                    ? null
                    : "Please add at least one group"),
                name: "groups",
                options: groups.values
                    .map((group) => FormBuilderFieldOption(
                          value: group,
                          child: Text(group.name),
                        ))
                    .toList(),
                initialValue: groups.values
                    .where((group) => mypeMarker.groupIds.contains(group.id))
                    .toList(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text("Images:"),
              ),
              FormBuilderField<List<String>>(
                initialValue: mypeMarker.imageIds,
                name: "imageIds",
                decoration: InputDecoration(labelText: "Images"),
                builder: (field) => SizedBox(
                    height: 100,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...field.value!.map((imageId) => FutureBuilder(
                                future: imagesRepo.getImage(imageId),
                                builder: (_, AsyncSnapshot<File?> snapshot) =>
                                    Flexible(
                                  child: snapshot.connectionState ==
                                          ConnectionState.done
                                      ? Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => PhotoView(
                                                      onTapUp: (_, __, ___) =>
                                                          Navigator.pop(
                                                              context),
                                                      imageProvider: FileImage(
                                                        snapshot.data!,
                                                      ),
                                                      heroAttributes:
                                                          const PhotoViewHeroAttributes(
                                                              tag: "imageTag"),
                                                    ),
                                                  )),
                                              child: Hero(
                                                tag: "imageTag",
                                                child: Image.file(
                                                  snapshot.data!,
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                                top: -5,
                                                right: -5,
                                                child: IconButton(
                                                  color: Colors.red,
                                                  icon: Icon(
                                                      Icons.close_outlined),
                                                  onPressed: () {
                                                    field.value!
                                                        .remove(imageId);
                                                    field
                                                        .didChange(field.value);
                                                  },
                                                ))
                                          ],
                                        )
                                      : snapshot.connectionState ==
                                              ConnectionState.none
                                          ? Text("Image loading failed")
                                          : CircularProgressIndicator(),
                                ),
                              )),
                          IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () async {
                                final imageSource =
                                    await pickImageSource(context);
                                if (imageSource != null) {
                                  File? newImage =
                                      await imagesRepo.pickImage(imageSource);
                                  if (newImage != null) {
                                    try {
                                      final imageId =
                                          await imagesRepo.upload(newImage);
                                      field.didChange(
                                          [...?field.value, imageId]);
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  }
                                }
                              })
                        ])),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_fbKey.currentState?.value != null &&
                        _fbKey.currentState!.saveAndValidate()) {
                      if (_fbKey.currentState!.validate()) {
                        print(_fbKey.currentState!.value);

                        final newMarker = mypeMarker.copyWith(
                            title: _fbKey.currentState!.value["title"],
                            description:
                                _fbKey.currentState!.value["description"],
                            groupIds: (_fbKey.currentState!.value["groups"]
                                    as List<Group>)
                                .where((group) => group.id != null)
                                .map((group) => group.id!)
                                .toSet(),
                            imageIds: _fbKey.currentState!.value["imageIds"]);
                        if (mypeMarker.id == null) {
                          markersController.addMarker(newMarker);
                        } else {
                          markersController.updateMarker(
                              mypeMarker.id!, newMarker);
                        }
                      }
                      Navigator.of(context).pop(true);
                    }
                  },
                  child: Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }
}
