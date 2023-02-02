import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPwdController = TextEditingController();
  RxString emailValid = ''.obs;
  RxString passwordValid = ''.obs;
  RxString nameValid = ''.obs;
  RxString cPasswordValid = ''.obs;
  final count = 0.obs;

  @override
  void onInit() {
    passwordController.text = '';
    nameController..text;
    emailController..text;
    confirmPwdController.text;
    passwordValid.value = '';
    emailValid.value = '';
    nameValid.value = '';
    cPasswordValid.value = '';

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
}
