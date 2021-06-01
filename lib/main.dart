import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/components/UserDialog.dart';
import 'package:mype_app/controllers/friend_requests_controller.dart';
import 'package:mype_app/controllers/user_controller.dart';
import 'package:mype_app/repositories/custom_exception.dart';
import 'package:mype_app/repositories/user_repository.dart';
import 'package:mype_app/screens/Home.dart';
import 'package:mype_app/screens/LogIn.dart';
import 'package:mype_app/screens/SignUp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/auth_controller.dart';
import 'controllers/friends_controller.dart';
import 'models/user_model/user_model.dart';
import 'repositories/shared_prefs.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

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
    final firebaseUser = useProvider(authControllerProvider.state);
    final userRepo = useProvider(userRepositoryProvider);
    final friendRequestsController =
        useProvider(friendRequestsControllerProvider);
    final friendsController = useProvider(friendsControllerProvider);
    final userController = useProvider(userControllerProvider);

    final signUpPage = useState(true);

    void initDynamicLinks() async {
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        final Uri? deepLink = dynamicLink?.link;

        if (deepLink != null) {
          User? user = await userRepo.getUserByCode(
              deepLink.path.substring(deepLink.path.lastIndexOf('/') + 1));
          if (user != null) {
            showUserDialog(context, user);
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

    void showFriendRequest(RemoteMessage message) async {
      if (message.data["type"] == "incomingFriendRequest") {
        await friendsController.getFriends();
        await friendRequestsController.getFriendRequests();
        final fromUser =
            await friendsController.getUser(message.data["fromUser"]);
        if (fromUser != null) {
          showUserDialog(context, fromUser);
        }
      }
    }

    void initFCM() async {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print("opened push notification");
        showFriendRequest(message);
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
        showFriendRequest(message);
      });

      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.', // description
        importance: Importance.max,
      );

      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    useEffect(() {
      initDynamicLinks();
      initFCM();
      SharedPreferences.getInstance()
          .then((value) => sharedPrefs.state = value);
    }, []);

    return ProviderListener(
        onChange: (_, StateController<CustomException?> e) {
          if (e.state != null)
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    e.state!.message != null ? e.state!.message! : "Error!")));
        },
        provider: exceptionProvider,
        child: (firebaseUser != null)
            ? Home()
            : signUpPage.value
                ? SignUp(goToLogin: () => signUpPage.value = false)
                : LogIn(goToSignUp: () => signUpPage.value = true));
  }
}
