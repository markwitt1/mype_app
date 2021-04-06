/* import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../controllers/AuthController.dart';
import 'package:devicelocale/devicelocale.dart';

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  PhoneNumber phoneNumber = PhoneNumber();
  String _verifyCode;
  String _countryCode;
  bool loading;
  bool sent;
  String verifyId;

  @override
  void initState() {
    setState(() {
      loading = false;
      sent = false;
    });
    Devicelocale.currentLocale.then((value) {
      setState(() {
        _countryCode = value.split(
          "_",
        )[1];
        phoneNumber = PhoneNumber(isoCode: _countryCode);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: loading
                ? [CircularProgressIndicator()]
                : sent
                    ? [
                        TextField(
                          onChanged: (value) => setState(() {
                            _verifyCode = value;
                          }),
                        ),
                        RaisedButton(
                            child: Text("Verify"),
                            onPressed: () async {
                              PhoneAuthCredential phoneAuthCredential =
                                  PhoneAuthProvider.credential(
                                      verificationId: verifyId,
                                      smsCode: _verifyCode);
                              await Get.find<AuthController>().createUser(
                                  nameController.text,
                                  emailController.text,
                                  passwordController.text,
                                  phoneAuthCredential,
                                  phoneNumber.phoneNumber);
                              await FirebaseAuth.instance
                                  .signInWithCredential(phoneAuthCredential);
                            })
                      ]
                    : <Widget>[
                        TextFormField(
                          decoration: InputDecoration(hintText: "Full Name"),
                          controller: nameController,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          decoration: InputDecoration(hintText: "Email"),
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        InternationalPhoneNumberInput(
                          onInputChanged: ((PhoneNumber value) {
                            setState(() {
                              phoneNumber = value;
                            });
                          }),
                          initialValue: phoneNumber,
                          onSaved: (val) => setState(() {
                            phoneNumber = val;
                          }),
                          selectorConfig: SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                              countryComparator: (c1, c2) {
                                if (c2.alpha2Code == _countryCode) return 1;
                                return -1;
                              }),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          decoration: InputDecoration(hintText: "Password"),
                          obscureText: true,
                          controller: passwordController,
                        ),
                        FlatButton(
                          child: Text("Sign Up"),
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: phoneNumber.phoneNumber,
                              verificationCompleted:
                                  (PhoneAuthCredential credential) {},
                              verificationFailed: (FirebaseAuthException e) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(e.message),
                                ));
                                setState(() {
                                  loading = false;
                                  sent = false;
                                });
                              },
                              codeAutoRetrievalTimeout:
                                  (String verificationId) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text("timeout"),
                                ));
                                setState(() {
                                  loading = false;
                                  sent = false;
                                });
                              },
                              codeSent:
                                  (String verificationId, int resendToken) {
                                setState(() {
                                  verifyId = verificationId;
                                  sent = true;
                                  loading = false;
                                });
                              },
                            );
                          },
                        )
                      ],
          ),
        ),
      ),
    );
  }
}
 */

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SignUp extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: FormBuilder(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FormBuilderTextField(name: "name"),
                FormBuilderTextField(name: "email"),
                //FormBuilderPhoneField(name: "phoneNumber"),
                FormBuilderTextField(name: "phoneNumber"),
                FormBuilderTextField(
                  name: "password",
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                ),
                ElevatedButton(
                    child: Text("Sign Up"),
                    onPressed: () async {
                      if (_fbKey.currentState!.saveAndValidate()) {
                        print(_fbKey.currentState?.value);
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
