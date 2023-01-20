import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterreminder/model/user_model.dart';
import 'package:waterreminder/toast.dart';

class ForgotPasswordController extends GetxController {
  //TODO: Implement ForgotPasswordController
  TextEditingController emailController = TextEditingController();
  RxString emailValid = ''.obs;
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
