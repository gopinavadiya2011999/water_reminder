import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:waterreminder/constant/toast.dart';

import '../../../../model/user_model.dart';

class ResetPasswordController extends GetxController {
  TextEditingController cpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxString cpValid = ''.obs;
  RxString pwdValid = ''.obs;

  final count = 0.obs;
  @override
  Future<void> onInit() async {

    super.onInit();

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
