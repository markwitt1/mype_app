import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/auth_controller.dart';

class SignUp extends HookWidget {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  String getValue(String key) => _fbKey.currentState?.value[key];
  final Function() goToLogin;
  SignUp({Key? key, required this.goToLogin}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authController = useProvider(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Column(
        children: [
          Flexible(
            child: FormBuilder(
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
                        initialValue: kReleaseMode ? "" : "Mark Test",
                      ),
                      FormBuilderTextField(
                        name: "email",
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: "Email Address"),
                        initialValue: kReleaseMode ? "" : "test@flutter.fl",
                      ),
                      FormBuilderTextField(
                        name: "phoneNumber",
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: "Phone Number (with Country Code)"),
                        initialValue: kReleaseMode ? "" : "+12345678910",
                      ),
                      FormBuilderTextField(
                        name: "password",
                        decoration: InputDecoration(labelText: "Password"),
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        initialValue: kReleaseMode ? "" : "rolexamg",
                      ),
                      ElevatedButton(
                        child: Text("Sign Up"),
                        onPressed: () async {
                          if (_fbKey.currentState!.saveAndValidate()) {
                            print(_fbKey.currentState?.value);
                            final values = _fbKey.currentState!.value;
                            /*                       final PhoneAuthCredential? phoneAuthCredential =
                            await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PhoneWindow(
                              phoneNumber: values["phoneNumber"],
                            ),
                          ),
                        ); */
                            //if (phoneAuthCredential != null) {
                            authController.createUser(
                                values["name"],
                                values["email"],
                                values["password"],
                                null,
                                //phoneAuthCredential,
                                values["phoneNumber"]);
                            // }
                          }
                        },
                      ),
                      TextButton(
                          child: Text("Log in with existing account"),
                          onPressed: goToLogin),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "Privacy Notice: Your Phone number will be stored on Google servers to let your contacts be able to find and add you.",
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
