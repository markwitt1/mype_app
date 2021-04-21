import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/screens/Home.dart';
import 'package:mype_app/screens/SignUp.dart';
import 'controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = useProvider(authControllerProvider.state);
    print(firebaseUser);
    if (firebaseUser != null) {
      return Home();
    }
    return SignUp();
  }
}