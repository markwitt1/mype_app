import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/groups_controller.dart';
import 'package:mype_app/controllers/images_controller.dart';
import 'package:mype_app/controllers/markers_controller.dart';
import 'package:mype_app/models/group_model/group_model.dart';
import 'package:mype_app/models/mype_marker/mype_marker.dart';

class MarkerWindow extends HookWidget {
  final MypeMarker mypeMarker;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  MarkerWindow({required this.mypeMarker}) : super();

  @override
  Widget build(BuildContext context) {
    final markersController = useProvider(markersControllerProvider);
    final groups = useProvider(groupsControllerProvider.state);
    final images = useProvider(imagesControllerProvider.state);
    final imagesController = useProvider(imagesControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Marker"),
      ),
      body: FormBuilder(
        key: _fbKey,
        child: Column(
          children: [
            FormBuilderTextField(
              name: "title",
              decoration: InputDecoration(labelText: "Title"),
              initialValue: mypeMarker.title,
            ),
            FormBuilderTextField(
              name: "description",
              decoration: InputDecoration(labelText: "Description"),
              initialValue: mypeMarker.description,
            ),
            FormBuilderFilterChip(
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
            FutureBuilder(
                future: imagesController.sync(),
                builder: (_, snapshot) {
                  List<File> imageFiles = [];
                  if (snapshot.connectionState == ConnectionState.done) {
                    for (final imageId in mypeMarker.imageIds) {
                      if (images[imageId] != null) {
                        imageFiles.add(images[imageId]!.file!);
                      } else
                        imagesController.sync();
                    }

                    return FormBuilderImagePicker(
                      initialValue: imageFiles,
                      name: "images",
                    );
                  } else
                    return CircularProgressIndicator();
                }),
            ElevatedButton(
                onPressed: () {
                  if (_fbKey.currentState?.value != null &&
                      _fbKey.currentState!.saveAndValidate()) {
                    print(_fbKey.currentState!.value);

                    final newMarker = mypeMarker.copyWith(
                      title: _fbKey.currentState!.value["title"],
                      description: _fbKey.currentState!.value["description"],
                      groupIds:
                          (_fbKey.currentState!.value["groups"] as List<Group>)
                              .where((group) => group.id != null)
                              .map((group) => group.id!)
                              .toSet(),
                    );
                    if (mypeMarker.id == null) {
                      markersController.addMarker(newMarker);
                    } else {
                      markersController.updateMarker(mypeMarker.id!, newMarker);
                    }
                  }
                  Navigator.of(context).pop(true);
                },
                child: Text("Submit"))
          ],
        ),
      ),
    );
  }
}

/* class _MarkerWindowState extends State<MarkerWindow> {
  final _formKey = GlobalKey<FormState>();

  final markersController = Get.find<MarkersController>();
  final picker = ImagePicker();

  List<String> _groupIds = [];
  List<Tuple2<String, File>> _images = [];


  addImage(String serverName, File localFile) {
    final tuple = Tuple2(serverName, localFile);
    setState(() {
      _images.add(tuple);
    });
    markersController.addImage(tuple);
  }

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  loadMarkerData(MypeMarker originalMarker) {
    if (originalMarker.images.length > 0) {
      markersController.downloadImages(originalMarker.images);
    }

    setState(() {
      titleController.text = originalMarker.title;
      descriptionController.text = originalMarker.description;
      _groupIds = originalMarker.groupIds;
      _images = List<Tuple2<String, File>>.from(
          markersController.images.entries.map((e) {
        if (originalMarker.images.contains(e.key))
          return Tuple2(e.key, e.value);
      }));
    });
  }

  MypeMarker _originalMarker;

  @override
  void initState() {
    setState(() {
      _originalMarker = markersController.markers[widget.markerId];
    });

    loadMarkerData(_originalMarker);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Marker"),
      ),
      body: GetBuilder<MarkersController>(
          builder: (_) => Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(hintText: "Title"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(hintText: "Description"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    GetBuilder<GroupsController>(
                      builder: (_) => MultiSelectDialogField(
                        buttonText: Text("Groups"),
                        searchHint: "Groups",
                        title: Text("Groups"),
                        initialValue: _groupIds
                            .where((id) => _.groups.containsKey(id))
                            .toList(),
                        items: Get.find<GroupsController>()
                            .groups
                            .entries
                            .map((entry) =>
                                MultiSelectItem(entry.key, entry.value.name))
                            .toList(),
                        listType: MultiSelectListType.CHIP,
                        onConfirm: (values) {
                          setState(() {
                            _groupIds = values;
                            print(_groupIds);
                          });
                        },
                      ),
                    ),
                    Flexible(
                      child: ListView.builder(
                        reverse: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length + 1,
                        itemBuilder: (BuildContext context, int index) =>
                            (_images.length > index)
                                ? Stack(
                                    children: <Widget>[
                                      Image.file(_images[index].value2),
                                      Positioned(
                                          right: 0,
                                          top: 0,
                                          child: IconButton(
                                              icon: Icon(
                                                Icons.cancel,
                                                color:
                                                    Colors.red.withOpacity(0.5),
                                              ),
                                              onPressed: () => setState(() {
                                                    _images.removeAt(index);
                                                  })))
                                    ],
                                  )
                                : ImageUploader(addImage: addImage),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            print(_formKey.currentState.toString());
                            final mypeMarker = new MypeMarker(
                                marker: _originalMarker.marker,
                                title: titleController.value.text,
                                description: descriptionController.value.text,
                                images: List.from(
                                  _images.map((e) => e.value1),
                                ),
                                groupIds: _groupIds);

                            _.updateMarker(widget.markerId, mypeMarker);
                            Get.back();
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ),
                  ],
                ),
              )),
    );
  }
}
 */
