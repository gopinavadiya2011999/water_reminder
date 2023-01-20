
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterreminder/model/user_model.dart';
import 'package:waterreminder/toast.dart';

class ChangePasswordController extends GetxController {
  RxList<UserModel> userData = <UserModel>[].obs;
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
  @override
  Future<void> onInit() async {
    super.onInit();
    clearController();
    userData = RxList(await getPrefData());
  }

  @override
  void onReady() {

    print("(((((");
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    clearController();
  }

  void increment() => count.value++;
}
