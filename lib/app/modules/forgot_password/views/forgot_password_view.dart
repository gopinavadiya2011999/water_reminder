import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:waterreminder/app/modules/login/views/login_view.dart';
import 'package:waterreminder/app/modules/otp/views/otp_view.dart';
import 'package:waterreminder/constant/color_constant.dart';
import 'package:waterreminder/constant/text_style_constant.dart';
import 'package:waterreminder/toast.dart';
import 'package:waterreminder/widgets/custom_button.dart';
import 'package:waterreminder/widgets/custom_image.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';
import 'package:waterreminder/widgets/custom_text_field.dart';
import 'package:waterreminder/widgets/system_overlay_style.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  ForgotPasswordView({Key? key}) : super(key: key);

  final forgotController = Get.put(ForgotPasswordController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: forgotController,
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
                    child: Text('Forgot Password ?',
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
                      "Don’t worry! It happens. Please enter the email address associated with your account.",
                      style: TextStyleConstant.grey12),
                  SizedBox(height: 3.h),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        customTextField(
                            errorText: forgotController.emailValid.value,
                            validator: (email) {
                              forgotController.emailValid.value = '';
                              if (email!.isEmpty) {
                                forgotController.emailValid.value =
                                    "Please enter email";
                              }
                              forgotController.update();
                              return null;
                            },
                            labelText: 'Email',
                            hintText: 'example@gmail.com',
                            controller: forgotController.emailController),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.5.h),
                  inkWell(
                      child: customButton(
                          inifinity: true,
                          buttonText: 'Send',
                          context: context,
                          plusButton: true),
                      onTap: () {
                        checkValidation(context);
                      }),
                  SizedBox(height: 3.h),
                  Align(
                    alignment: Alignment.center,
                    child: inkWell(
                      onTap: () {
                        Get.to(LoginView());
                        forgotController.emailController.clear();
                        Get.deleteAll();
                      },
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: "Back to ", style: TextStyleConstant.black13),
                        TextSpan(
                            text: 'Login',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(LoginView());
                                Get.deleteAll();
                                forgotController.emailController.clear();
                              },
                            style: TextStyleConstant.black13
                                .copyWith(color: ColorConstant.blueFE))
                      ])),
                    ),
                  )
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
    if (_formKey.currentState!.validate() &&
        forgotController.emailValid.value.isEmpty) {
      if (forgotController.userModel
          .where((element) =>
              element.email == forgotController.emailController.text.trim())
          .toList()
          .isNotEmpty) {
        Get.to(OtpView(email: forgotController.emailController.text.trim()));
      } else {
        showBottomLongToast('This credential do not match to our records');
      }
    }
  }
}
