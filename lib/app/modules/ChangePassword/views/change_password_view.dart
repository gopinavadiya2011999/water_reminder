import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:waterreminder/constant/color_constant.dart';
import 'package:waterreminder/constant/text_style_constant.dart';

import 'package:waterreminder/toast.dart';
import 'package:waterreminder/widgets/custom_back_button.dart';
import 'package:waterreminder/widgets/custom_button.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';
import 'package:waterreminder/widgets/custom_text_field.dart';
import 'package:waterreminder/widgets/system_overlay_style.dart';

import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  ChangePasswordView({Key? key}) : super(key: key);
  final changePwdController = Get.put(ChangePasswordController());

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        dismissKeyboard(context);
        return true;
      },
      child: WillPopScope(
        onWillPop: () async {
          changePwdController.clearController();
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                systemOverlayStyle: systemOverlayStyle(),
                backgroundColor: ColorConstant.white,
                title: Container(
                    color: ColorConstant.white,
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        inkWell(
                          onTap: () {
                            dismissKeyboard(context);
                            changePwdController.clearController();
                            Navigator.pop(context);
                          },
                          child: customBackButton(),
                        ),
                        Expanded(
                            child: Text('Change Password',
                                style: TextStyleConstant.titleStyle,
                                textAlign: TextAlign.center)),
                      ],
                    ))),
            body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    customTextField(
                        validator: (cp) {
                          changePwdController.currentPwdValid.value = '';
                          if (cp!.isEmpty) {
                            changePwdController.currentPwdValid.value =
                                "Please enter current password";
                            return;
                          } else if (cp.length < 8) {
                            changePwdController.currentPwdValid.value =
                                "Please Enter at least 8 characters";
                            return;
                          }
                          changePwdController.update();

                          return null;
                        },
                        obscureText: true,
                        errorText: changePwdController.currentPwdValid.value,
                        labelText: 'Current password',
                        hintText: 'Password',
                        controller: changePwdController.passwordController),
                    customTextField(
                        validator: (np) {
                          changePwdController.newPwd.value = '';
                          if (np.isEmpty) {
                            changePwdController.newPwd.value =
                                "Please enter new password";
                            return;
                          } else if (np.length < 8) {
                            changePwdController.newPwd.value =
                                "Please Enter at least 8 characters";
                            return;
                          }
                          changePwdController.update();

                          return null;
                        },
                        obscureText: true,
                        errorText: changePwdController.newPwd.value,
                        labelText: 'New password',
                        hintText: 'Confirm password',
                        controller: changePwdController.newPwdController),
                    customTextField(
                        validator: (cnp) {
                          changePwdController.confirmNewPwdValid.value = '';
                          if (cnp.isEmpty) {
                            changePwdController.confirmNewPwdValid.value =
                                "Please enter confirm new password";
                            return;
                          } else if (cnp.length < 8) {
                            changePwdController.confirmNewPwdValid.value =
                                "Please Enter at least 8 characters";
                            return;
                          } else if (cnp.toString() !=
                              changePwdController.newPwdController.text) {
                            changePwdController.confirmNewPwdValid.value =
                                "Both password doesn't match";
                            return;
                          }
                          changePwdController.update();

                          return null;
                        },
                        obscureText: true,
                        errorText: changePwdController.confirmNewPwdValid.value,
                        labelText: 'Confirm new password',
                        hintText: 'Confirm new password',
                        controller:
                            changePwdController.confirmNewPwdController),
                    const SizedBox(height: 30),
                    inkWell(
                        child: customButton(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.height / 15,
                                vertical:
                                    MediaQuery.of(context).size.width / 25),
                            buttonText: "Update Password",
                            context: context,
                            plusButton: true),
                        onTap: () {
                          checkValidation(context);
                        })
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void checkValidation(context) {
    dismissKeyboard(context);
    if (_formKey.currentState!.validate() &&
        changePwdController.newPwdController.text.isNotEmpty &&
        changePwdController.passwordController.text.isNotEmpty &&
        changePwdController.confirmNewPwdController.text.isNotEmpty) {
        if (changePwdController.userData.first.password !=
          changePwdController.passwordController.text.trim()) {
        showBottomLongToast("Current password doesn't match older password");
      } else {
        FirebaseFirestore.instance
            .collection('user')
            .doc(changePwdController.userData.first.userId)
            .update(
                {'password': changePwdController.newPwdController.text.trim()});
        showBottomLongToast("Password updated successfully");
        Get.back();
      }
    }
  }
}
