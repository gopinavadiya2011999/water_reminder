
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterreminder/model/user_model.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxString emailValid = ''.obs;
  RxString passwordValid = ''.obs;
    List<UserModel> userModel = [];


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
