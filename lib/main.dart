import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/friend_requests_controller.dart';
import 'package:mype_app/repositories/custom_exception.dart';
import 'package:mype_app/repositories/user_repository.dart';
import 'package:mype_app/screens/Home.dart';
import 'package:mype_app/screens/LogIn.dart';
import 'package:mype_app/screens/SignUp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/auth_controller.dart';
import 'models/user_model/user_model.dart';
import 'repositories/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'MYPE', home: HomeScreen());
  }
}

class HomeScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final sharedPrefs = useProvider(sharedPrefsProvider);
    useEffect(() {
      SharedPreferences.getInstance()
          .then((value) => sharedPrefs.state = value);
    });
    final firebaseUser = useProvider(authControllerProvider.state);
    final userRepo = useProvider(userRepositoryProvider);
    final friendRequestsController =
        useProvider(friendRequestsControllerProvider);

    final signUpPage = useState(true);

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
    return ProviderListener(
      onChange: (_, StateController<CustomException?> e) {
        if (e.state != null)
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  e.state!.message != null ? e.state!.message! : "Error!")));
      },
      provider: exceptionProvider,
      child: Builder(
        builder: (_) {
          if (firebaseUser != null) {
            return Home();
          }
          if (signUpPage.value)
            return SignUp(
              goToLogin: () => signUpPage.value = false,
            );
          return LogIn(
            goToSignUp: () => signUpPage.value = true,
          );
        },
      ),
    );
  }
}
