import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/auth_controller.dart';

import 'SignUp.dart';

class LogIn extends HookWidget {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  String getValue(String key) => _fbKey.currentState?.value[key];
  @override
  Widget build(BuildContext context) {
    final authController = context.read(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Log In"),
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
                  name: "email",
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Email Address"),
                ),
                FormBuilderTextField(
                  name: "password",
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                ),
                ElevatedButton(
                  child: Text("Log In"),
                  onPressed: () async {
                    if (_fbKey.currentState!.saveAndValidate()) {
                      print(_fbKey.currentState?.value);
                      final values = _fbKey.currentState!.value;
                      authController.login(values["email"], values["password"]);
                    }
                  },
                ),
                TextButton(
                  child: Text("Create an account"),
                  onPressed: () async {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => SignUp()));
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
