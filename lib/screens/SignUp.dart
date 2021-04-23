import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/auth_controller.dart';
import 'windows/PhoneWindow.dart';

import 'LogIn.dart';

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
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Email Address"),
                  initialValue: "test@flutter.fl",
                ),
                //FormBuilderPhoneField(name: "phoneNumber"),
                FormBuilderTextField(
                  name: "phoneNumber",
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Phone Number (with Country Code)"),
                  initialValue: "+12345678910",
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
                      final PhoneAuthCredential? phoneAuthCredential =
                          await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PhoneWindow(
                            phoneNumber: values["phoneNumber"],
                          ),
                        ),
                      );
                      if (phoneAuthCredential != null) {
                        authController.createUser(
                            values["name"],
                            values["email"],
                            values["password"],
                            phoneAuthCredential,
                            values["phoneNumber"]);
                      }
                    }
                  },
                ),
                TextButton(
                  child: Text("Log in with existing account"),
                  onPressed: () async {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => LogIn()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
