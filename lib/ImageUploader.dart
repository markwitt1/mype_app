/* import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

class ImageUploader extends StatefulWidget {
  final addImage;

  ImageUploader({Key? key, @required this.addImage}) : super(key: key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<ImageUploader> {
  final FirebaseStorage _storage =
      FirebaseStorage.instanceFor(bucket: 'gs://mype-app.appspot.com');

  File _image;
  UploadTask _uploadTask;
  ImagePicker _imagePicker = ImagePicker();

  /// Starts an upload task
  void _startUpload() {
    /// Unique file name for the file
    String filePath = '${Uuid().v4()}.${p.extension(_image.path)}';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(_image);
    });

    _uploadTask.whenComplete(() {
      if (_uploadTask.snapshot.state == TaskState.success)
        widget.addImage(_uploadTask.snapshot.ref.name, _image);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask == null && _image != null) {
      return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: FileImage(_image),
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.5), BlendMode.dstATop),
        )),
        child: FlatButton.icon(
          label: Text('Upload to Firebase'),
          icon: Icon(Icons.cloud_upload),
          onPressed: _startUpload,
        ),
      );
    } else if (_uploadTask != null) {
      return StreamBuilder<TaskSnapshot>(
          stream: _uploadTask.snapshotEvents,
          builder: (_, snapshot) {
            return Card(
                child: (snapshot.data?.state == TaskState.paused)
                    ? FlatButton(
                        child: Icon(Icons.play_arrow),
                        onPressed: _uploadTask.resume,
                      )
                    : FlatButton(
                        child: Icon(Icons.pause),
                        onPressed: _uploadTask.pause,
                      )

                // Progress bar
/*                 LinearProgressIndicator(value: progressPercent),
                Text('${(progressPercent * 100).toStringAsFixed(2)} % '), */

                );
          });
    } else {
      return FlatButton.icon(
        label: Text('Pick an Image'),
        icon: Icon(Icons.add),
        onPressed: () async {
          File image = File(
              (await _imagePicker.getImage(source: ImageSource.gallery)).path);
          setState(() {
            _image = image;
            print(_image);
          });
        },
      );
    }
  }
}
 */
