import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:mype_app/controllers/GroupsController.dart';
import '../../ImageUploader.dart';
import '../../models/MypeMarker.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dartz/dartz.dart' show Tuple2;

import '../../controllers/MarkersController.dart';

class MarkerWindow extends StatefulWidget {
  final String markerId;

  MarkerWindow({Key key, this.markerId}) : super(key: key);

  @override
  _MarkerWindowState createState() => _MarkerWindowState();

  static _MarkerWindowState of(BuildContext context) =>
      context.findAncestorStateOfType<_MarkerWindowState>();
}

class _MarkerWindowState extends State<MarkerWindow> {
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
