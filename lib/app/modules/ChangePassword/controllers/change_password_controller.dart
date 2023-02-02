
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterreminder/main.dart';

class ChangePasswordController extends GetxController {
  RxString currentPwdValid = ''.obs;
  RxString newPwd = ''.obs;
  RxString confirmNewPwdValid = ''.obs;

  TextEditingController passwordController = TextEditingController();
  TextEditingController newPwdController = TextEditingController();
  TextEditingController confirmNewPwdController = TextEditingController();
  clearController(){

    passwordController.clear();
    newPwdController.clear();
    confirmNewPwdController.clear();
    currentPwdValid.value='';
    newPwd.value='';
    confirmNewPwdValid.value='';
  }
  final count = 0.obs;
  User? user;
  @override
  void onInit()  {
    user = auth.currentUser;


    super.onInit();
  }

  @override
  void onReady() {

    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    clearController();
  }

  void increment() => count.value++;
}
