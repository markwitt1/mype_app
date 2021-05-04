import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/auth_controller.dart';
import 'package:mype_app/controllers/user_controller.dart';
import 'package:mype_app/repositories/images_repository.dart';
import '../components/ProfilePicture.dart';
import '../utils/pickImageSource.dart';

class Profile extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final authController = useProvider(authControllerProvider);
    final user = useProvider(userControllerProvider.state);
    final userController = useProvider(userControllerProvider);
    final imagesRepo = useProvider(imagesRepositoryProvider);
    final nameController = useTextEditingController(text: user!.name);
    final nameEdit = useState(false);
    final profilePictureFile = useState<AsyncValue<File>>(AsyncValue.loading());
    useEffect(() {
      if (user.profilePicture != null &&
          profilePictureFile.value.data?.value == null) {
        profilePictureFile.value == AsyncValue.loading();
        imagesRepo.getImage(user.profilePicture!).then((value) {
          if (value != null) {
            profilePictureFile.value = AsyncValue.data(value);
          }
        });
      }
    });

    Future<void> pickProfilePicture() async {
      final source = await pickImageSource(context);
      if (source != null) {
        final pickedImage = await imagesRepo.pickImage(source);
        if (pickedImage != null) {
          try {
            final imageId = await imagesRepo.upload(pickedImage);
            userController.updateUser(user.copyWith(profilePicture: imageId));
            profilePictureFile.value = AsyncValue.data(pickedImage);
          } catch (e) {
            throw e;
          }
        }
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          actions: [
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () => authController.signOut())
          ],
        ),
        body: user != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(children: [
                      GestureDetector(
                          onTap: pickProfilePicture,
                          child: user.profilePicture == null
                              ? ProfilePicture()
                              : profilePictureFile.value.when(
                                  data: (file) => ProfilePicture(
                                        image: file,
                                      ),
                                  loading: () => CircularProgressIndicator(),
                                  error: (e, _) => Text("error")))
                    ]),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.centerRight,
                              children: <Widget>[
                                TextField(
                                  enabled: nameEdit.value,
                                  controller: nameController,
                                ),
                                nameEdit.value
                                    ? IconButton(
                                        icon: Icon(Icons.save),
                                        onPressed: () async {
                                          await userController.updateUser(
                                              user.copyWith(
                                                  name: nameController.text));
                                          nameEdit.value = false;
                                        })
                                    : IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          nameEdit.value = true;
                                        },
                                      ),
                              ],
                            ),
                            Text(user.email, style: TextStyle(fontSize: 16))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : CircularProgressIndicator());
  }
}
