import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectionController extends GetxController {
  RxInt   curr = 0.obs;
  PageController pageController = PageController();
  User? user;

  @override
  void onInit() {
    user = FirebaseAuth.instance.currentUser;

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
