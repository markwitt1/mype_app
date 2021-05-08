import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/general_providers.dart';

class PhoneWindow extends HookWidget {
  final String phoneNumber;
  PhoneWindow({required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final error = useState(false);
    final verificationId = useState<String?>(null);
    final textController = useTextEditingController();
    final firebaseAuth = useProvider(firebaseAuthProvider);
    useEffect(() {
      firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          Navigator.of(context).pop(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          error.value = true;
        },
        codeSent: (String id, int? resendToken) {
          verificationId.value = id;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }, []);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Group"),
      ),
      body: Row(
        children: verificationId.value != null
            ? [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                        errorText: error.value ? "Verification failed" : null),
                  ),
                ),
                ElevatedButton(
                    child: Text("Verify"),
                    onPressed: () {
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationId.value!,
                              smsCode: textController.text);
                      Navigator.of(context).pop(credential);
                    })
              ]
            : [Center(child: CircularProgressIndicator())],
      ),
    );
  }
}
