import 'package:get/get.dart';
import '../AuthController.dart';

class LaunchBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}
