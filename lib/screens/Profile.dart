import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/auth_controller.dart';
import 'package:mype_app/controllers/user_controller.dart';

class Profile extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final authController = useProvider(authControllerProvider);
    final user = useProvider(userControllerProvider.state);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),actions: [IconButton(icon: Icon(Icons.exit_to_app),onPressed: ()=>authController.signOut())],
      ),
      body: user != null ?
      Column(
              children: [
                Text(user.name),
                Text(user.email),
              ],
      ) : CircularProgressIndicator()
    );
  }
}
