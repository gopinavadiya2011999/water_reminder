import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:waterreminder/app/modules/login/views/login_view.dart';
import 'package:waterreminder/constant/toast.dart';
import 'package:waterreminder/widgets/custom_button.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';
import 'package:waterreminder/widgets/custom_text_field.dart';

import '../../../../constant/color_constant.dart';
import '../../../../constant/text_style_constant.dart';
import '../../../../widgets/custom_image.dart';
import '../../../../widgets/system_overlay_style.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  final String? email;

  ResetPasswordView({Key? key, this.email}) : super(key: key);

  final resetController = Get.put(ResetPasswordController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: resetController,
      builder: (controller) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          systemOverlayStyle: systemOverlayStyle(),
        ),
        body: WillPopScope(
          onWillPop: () async {
            Get.deleteAll();
            return true;
          },
          child: Stack(fit: StackFit.expand, children: [
            customImage(context),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 3.h),
                  SizedBox(
                    width: 20.h,
                    child: Text('Reset Password',
                        maxLines: 2,
                        style: TextStyleConstant.titleStyle.copyWith(
                            color: ColorConstant.black24,
                            fontSize: 17.sp,
                            wordSpacing: 2,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sora')),
                  ),
                  const SizedBox(height: 8),
                  Text(
                      "Your new password must be different  from previous used password.",
                      style: TextStyleConstant.grey12),
                  SizedBox(height: 3.h),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        customTextField(
                            errorText: resetController.pwdValid.value,
                            validator: (password) {
                              resetController.pwdValid.value = '';
                              if (password!.isEmpty) {
                                resetController.pwdValid.value =
                                    "Please enter new password";
                              } else if (password.length < 8) {
                                resetController.pwdValid.value =
                                    "Please enter at least 8 characters";
                              }
                              resetController.update();
                              return null;
                            },
                            obscureText: true,
                            labelText: 'New Password',
                            hintText: 'New password',
                            controller: resetController.passwordController),
                        customTextField(
                            errorText: resetController.cpValid.value,
                            validator: (password) {
                              resetController.cpValid.value = '';
                              if (password!.isEmpty) {
                                resetController.cpValid.value =
                                    "Please enter confirm password";
                              } else if (password.length < 8) {
                                resetController.cpValid.value =
                                    "Please enter at least 8 characters";
                              } else if (password !=
                                  resetController.passwordController.text
                                      .trim()) {
                                resetController.cpValid.value =
                                    "Both password doesn't match";
                              }
                              resetController.update();
                              return null;
                            },
                            obscureText: true,
                            labelText: 'Confirm Password',
                            hintText: 'Confirm Password',
                            controller: resetController.cpController),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.5.h),
                  inkWell(
                      child: customButton(
                          inifinity: true,
                          buttonText: 'Reset Password',
                          context: context,
                          plusButton: true),
                      onTap: () {
                        checkValidation(context);
                      }),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  void checkValidation(BuildContext context) {
    dismissKeyboard(context);
    // if (_formKey.currentState!.validate() &&
    //     resetController.cpValid.value.isEmpty &&
    //     resetController.pwdValid.value.isEmpty) {
    //   if (resetController.userModel
    //       .where((element) => element.email == email!.trim())
    //       .toList()
    //       .isNotEmpty) {
    //     FirebaseFirestore.instance
    //         .collection('user')
    //         .doc(resetController.userModel
    //             .where((element) => element.email == email)
    //             .first
    //             .userId)
    //         .update({'password': resetController.cpController.text.trim()});
    //     showBottomLongToast("Your password has been updated successfully");
    //      Get.offAll(LoginView());
    //   }
    // }
  }
}
