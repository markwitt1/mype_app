import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/friend_requests_controller.dart';
import 'package:mype_app/repositories/user_repository.dart';
import 'package:mype_app/screens/Home.dart';
import 'package:mype_app/screens/LogIn.dart';
import 'controllers/auth_controller.dart';
import 'models/user_model/user_model.dart';

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
    final userRepo = useProvider(userRepositoryProvider);
    final friendRequestsController =
        useProvider(friendRequestsControllerProvider);

    void initDynamicLinks() async {
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        final Uri? deepLink = dynamicLink?.link;

        if (deepLink != null) {
          User? user = await userRepo.getUserByCode(
              deepLink.path.substring(deepLink.path.lastIndexOf('/') + 1));
          if (user != null) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Freund hinzufügen"),
                content:
                    Text("Möchten Sie ${user.name} als Freund hinzufügen?"),
                actions: [
                  ElevatedButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  ElevatedButton(
                      child: Text("Yes"),
                      onPressed: () {
                        friendRequestsController.sendFriendRequest(user.id!);
                        Navigator.of(context).pop();
                      })
                ],
              ),
            );
          }
        }
      }, onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      });

      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = data?.link;

      if (deepLink != null) {
        Navigator.pushNamed(context, deepLink.path);
      }
    }

    useEffect(() {
      initDynamicLinks();
    });
    if (firebaseUser != null) {
      return Home();
    }
    return LogIn();
  }
}
