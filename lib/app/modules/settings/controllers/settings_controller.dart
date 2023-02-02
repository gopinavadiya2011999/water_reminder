import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
class SettingsController extends GetxController {
  User? user;
  @override
  Future<void> onInit() async {
    super.onInit();
    user = FirebaseAuth.instance.currentUser;

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
