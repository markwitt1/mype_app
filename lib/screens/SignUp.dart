import 'package:firebase_auth/firebase_auth.dart';
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

  @override
  void initState() {
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
            children: <Widget>[
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
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: phoneNumber.phoneNumber,
                    verificationCompleted: (PhoneAuthCredential credential) {
                      Get.find<AuthController>().createUser(
                          nameController.text,
                          emailController.text,
                          passwordController.text,
                          credential,
                          phoneNumber.phoneNumber);
                    },
                    verificationFailed: (FirebaseAuthException e) {},
                    codeSent: (String verificationId, int resendToken) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text("Enter Code sent via SMS"),
                          content: TextField(
                            onChanged: (value) => setState(() {
                              _verifyCode = value;
                            }),
                          ),
                          actions: [
                            FlatButton(
                              child: Text("Verify"),
                              onPressed: () {
                                PhoneAuthCredential phoneAuthCredential =
                                    PhoneAuthProvider.credential(
                                        verificationId: verificationId,
                                        smsCode: _verifyCode);
                                Get.find<AuthController>().createUser(
                                    nameController.text,
                                    emailController.text,
                                    passwordController.text,
                                    phoneAuthCredential,
                                    phoneNumber.phoneNumber);
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            )
                          ],
                        ),
                      );
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
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
