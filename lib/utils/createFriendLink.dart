import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Future<String> createFriendLink(String code) async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    //TODO: better Id creation
    uriPrefix: "https://mype.page.link",
    link: Uri.parse('https://mype.app/add/$code'),
    iosParameters: IosParameters(
        bundleId: "me.markwitt.mype_app",
        fallbackUrl: Uri.parse("http://markwitt.me")),
    androidParameters: AndroidParameters(
        packageName: 'me.markwitt.mype_app',
        fallbackUrl: Uri.parse("http://markwitt.me")),
  );
  final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
  return shortDynamicLink.shortUrl.toString();
}
