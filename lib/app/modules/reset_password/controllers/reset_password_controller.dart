import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:waterreminder/toast.dart';

import '../../../../model/user_model.dart';

class ResetPasswordController extends GetxController {
  TextEditingController cpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxString cpValid = ''.obs;
  RxString pwdValid = ''.obs;
  List<UserModel> userModel = [];

  final count = 0.obs;
  @override
  Future<void> onInit() async {

    super.onInit();
    userModel = await getUserData();

    print("user moderl :: ${userModel.map((e) => e.email)}");

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
