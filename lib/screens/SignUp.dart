import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/auth_controller.dart';

class SignUp extends HookWidget {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  String getValue(String key) => _fbKey.currentState?.value[key];
  @override
  Widget build(BuildContext context) {
    final authController = context.read(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: FormBuilder(
        key: _fbKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FormBuilderTextField(
                  name: "name",
                  decoration: InputDecoration(labelText: "Name"),
                  initialValue: "Mark Test",
                ),
                FormBuilderTextField(
                  name: "email",
                  decoration: InputDecoration(labelText: "Email Address"),
                  initialValue: "test@flutter.fl",
                ),
                //FormBuilderPhoneField(name: "phoneNumber"),
                FormBuilderTextField(
                  name: "phoneNumber",
                  decoration: InputDecoration(labelText: "Phone Number"),
                  initialValue: "+4915238553536",
                ),
                FormBuilderTextField(
                  name: "password",
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  initialValue: "rolexamg",
                ),
                ElevatedButton(
                    child: Text("Sign Up"),
                    onPressed: () async {
                      if (_fbKey.currentState!.saveAndValidate()) {
                        print(_fbKey.currentState?.value);
                        final values = _fbKey.currentState!.value;
                        authController.createUser(
                            values["name"],
                            values["email"],
                            values["password"],
                            null,
                            values["phoneNumber"]);
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
