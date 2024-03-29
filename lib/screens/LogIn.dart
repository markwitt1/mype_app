import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/auth_controller.dart';

class LogIn extends HookWidget {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  String getValue(String key) => _fbKey.currentState?.value[key];
  final Function() goToSignUp;
  LogIn({Key? key, required this.goToSignUp}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authController = useProvider(authControllerProvider);
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
                    initialValue: kReleaseMode ? "" : "test@flutter.fl"),
                FormBuilderTextField(
                  name: "password",
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  initialValue: kReleaseMode ? "" : "rolexamg",
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
                  onPressed: goToSignUp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
