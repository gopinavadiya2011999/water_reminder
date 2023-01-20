import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:waterreminder/app/modules/bottom_tab/views/bottom_tab_view.dart';
import 'package:waterreminder/app/modules/forgot_password/views/forgot_password_view.dart';
import 'package:waterreminder/app/modules/signup/views/signup_view.dart';
import 'package:waterreminder/constant/text_style_constant.dart';
import 'package:waterreminder/main.dart';
import 'package:waterreminder/model/user_model.dart';
import 'package:waterreminder/toast.dart';
import 'package:waterreminder/widgets/custom_button.dart';
import 'package:waterreminder/widgets/custom_image.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';
import 'package:waterreminder/widgets/custom_text_field.dart';
import 'package:waterreminder/widgets/system_overlay_style.dart';

import '../../../../constant/color_constant.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);
  final loginController = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: loginController,
      builder: (controller) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          systemOverlayStyle: systemOverlayStyle(),
        ),
        body: Stack(
          children: [
            customImage(context),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 3.h),
                  Text('Welcome back to Water Reminder',
                      maxLines: 2,
                      style: TextStyleConstant.titleStyle.copyWith(
                          color: ColorConstant.black24,
                          fontSize: 17.sp,
                          wordSpacing: 2,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Sora')),
                  const SizedBox(height: 8),
                  Text(
                      "Enter your email and password you’d like to use to login to Water Reminder.",
                      style: TextStyleConstant.grey12),
                  SizedBox(height: MediaQuery.of(context).size.height / 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        customTextField(
                            errorText: loginController.emailValid.value,
                            validator: (email) {
                              loginController.emailValid.value = '';
                              if (email!.isEmpty) {
                                loginController.emailValid.value =
                                    "Please enter email";
                              }
                              /*else if (loginController.userModel
                              .where((element) =>
                          element.email ==
                              loginController.emailController.text)
                              .toList()
                              .isEmpty) {
                            loginController.emailValid.value =
                            'Please enter valid email';
                          }*/

                              loginController.update();
                              return null;
                            },
                            labelText: 'Email',
                            hintText: 'example@gmail.com',
                            controller: loginController.emailController),
                        customTextField(
                            errorText: loginController.passwordValid.value,
                            validator: (password) {
                              loginController.passwordValid.value = '';
                              if (password!.isEmpty) {
                                loginController.passwordValid.value =
                                    "Please enter password";
                              }
                              if (password.length < 8) {
                                loginController.passwordValid.value =
                                    "Please Enter at least 8 characters";
                              }
                              loginController.update();
                              return null;
                            },
                            obscureText: true,
                            labelText: 'Password',
                            hintText: 'Password',
                            controller: loginController.passwordController),
                      ],
                    ),
                  ),
                  inkWell(
                    onTap: () {
                      Get.deleteAll();
                      Get.to(ForgotPasswordView());
                    },
                    child: Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Text('Forgot Password ?',
                          textAlign: TextAlign.end,
                          style: TextStyleConstant.black13),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 22),
                  inkWell(
                      child: customButton(
                          inifinity: true,
                          buttonText: 'Login',
                          context: context,
                          plusButton: true),
                      onTap: () {
                        checkValidation(context);
                      }),
                  SizedBox(height: MediaQuery.of(context).size.height / 30),
                  inkWell(
                    onTap: () {
                      Get.to(SignUpView());
                      loginController.emailController.clear();
                      loginController.passwordController.clear();
                      Get.deleteAll();
                    },
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyleConstant.black13),
                      TextSpan(
                          text: 'Sign Up here',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(SignUpView());
                              loginController.emailController.clear();
                              loginController.passwordController.clear();
                              Get.deleteAll();
                            },
                          style: TextStyleConstant.black13
                              .copyWith(color: ColorConstant.blueFE))
                    ])),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkValidation(context) async {
    dismissKeyboard(context);
    if (_formKey.currentState!.validate() &&
        loginController.emailValid.value.isEmpty &&
        loginController.passwordValid.value.isEmpty) {
      loginController.userModel.clear();
      loginController.userModel = await getUserData();
      loginController.update();
      if (loginController.userModel.isNotEmpty) {
        UserModel? userEmailExist = loginController.userModel
                .where((element) =>
                    element.email ==
                    loginController.emailController.text.trim())
                .isNotEmpty
            ? loginController.userModel
                .where((element) =>
                    element.email ==
                    loginController.emailController.text.trim())
                .first
            : null;

        if (userEmailExist != null) {
          if (userEmailExist.password !=
              loginController.passwordController.text.trim()) {
            showBottomLongToast("Invalid password");
          } else {
            String encodeData = UserModel.encode([
              UserModel(
                  waterGoal: userEmailExist.waterGoal,
                  password: userEmailExist.password,
                  bedTime: userEmailExist.bedTime,
                  userName: userEmailExist.userName,
                  userId: userEmailExist.userId,
                  email: userEmailExist.email,
                  time: userEmailExist.time,
                  weight: userEmailExist.weight,
                  gender: userEmailExist.gender,
                  wakeUpTime: userEmailExist.wakeUpTime,
                  drinkableWater: userEmailExist.drinkableWater)
            ]);

            box.write('save', encodeData);
            box.write('login', true);
            showBottomLongToast("Login successful");
            Get.offAll(BottomTabView());
          }
        } else {
          showBottomLongToast("This credential do not match to our records");
        }
      }
    }
  }
}
