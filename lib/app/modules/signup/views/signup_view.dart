import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:waterreminder/app/modules/login/views/login_view.dart';
import 'package:waterreminder/app/modules/selection/views/selection_view.dart';
import 'package:waterreminder/main.dart';
import 'package:waterreminder/no_internet/check_network.dart';
import 'package:waterreminder/toast.dart';
import 'package:waterreminder/widgets/capitalize_sentence.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';
import '../controllers/signup_controller.dart';
import 'package:waterreminder/constant/text_style_constant.dart';
import 'package:waterreminder/widgets/custom_button.dart';
import 'package:waterreminder/widgets/custom_image.dart';
import 'package:waterreminder/widgets/custom_text_field.dart';
import 'package:waterreminder/widgets/system_overlay_style.dart';
import '../../../../constant/color_constant.dart';

class SignUpView extends GetView<SignupController> {
  SignUpView({Key? key}) : super(key: key);
  final signupController = Get.put(SignupController());

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignupController>(
      init: signupController,
      builder: (controller) => CheckNetwork(
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          // appBar: AppBar(
          //   toolbarHeight: 0,
          //   elevation: 0,
          //   systemOverlayStyle: systemOverlayStyle(),
          // ),
          body: Stack(
            fit: StackFit.loose,
            children: [


              if (MediaQuery.of(context).viewInsets.bottom == 0.0)
                customImage(context),
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height:6.5.h),
                        Text('Welcome to Water Reminder',
                            maxLines: 2,
                            style: TextStyleConstant.titleStyle.copyWith(
                                color: ColorConstant.black24,
                                fontSize: 25,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Sora')),
                        const SizedBox(height: 8),
                        Text(
                            "Enter your name, email and password you’d like to use to sign in to Water Reminder.",
                            style: TextStyleConstant.grey12),
                        SizedBox(height: MediaQuery.of(context).size.height / 50),
                        Form(
                          key: _formKey,
                          child: Column(children: [
                            customTextField(
                                keyboardType: TextInputType.emailAddress,

                                errorText: signupController.emailValid.value,
                                validator: (email) {
                                  signupController.emailValid.value = '';
                                  if (email!.isEmpty) {
                                    signupController.emailValid.value =
                                        "Please enter email";
                                  } else if (!RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(email)) {
                                    signupController.emailValid.value =
                                        'Please enter valid email';
                                  }

                                  signupController.update();
                                  return null;
                                },
                                labelText: 'Email',
                                hintText: 'example@gmail.com',
                                controller: signupController.emailController),
                            customTextField(
                                errorText: signupController.nameValid.value,
                                validator: (name) {
                                  signupController.nameValid.value = '';
                                  if (name!.isEmpty) {
                                    signupController.nameValid.value =
                                        "Please enter full name";
                                  }
                                  signupController.update();
                                  return null;
                                },
                                labelText: 'Name',
                                hintText: 'Full name',
                                controller: signupController.nameController),
                            customTextField(
                                errorText: signupController.passwordValid.value,
                                validator: (password) {
                                  signupController.passwordValid.value = '';
                                  if (password!.isEmpty) {
                                    signupController.passwordValid.value =
                                        "Please enter password";
                                  } else if (password.length < 8) {
                                    signupController.passwordValid.value =
                                        "Please enter at least 8 characters";
                                  }

                                  signupController.update();
                                  return null;
                                },
                                obscureText: true,
                                labelText: 'Password',
                                hintText: 'Password',
                                controller: signupController.passwordController),
                            customTextField(
                                obscureText: true,
                                errorText: signupController.cPasswordValid.value,
                                validator: (cPassword) {
                                  signupController.cPasswordValid.value = '';
                                  if (cPassword!.isEmpty) {
                                    signupController.cPasswordValid.value =
                                        "Please enter confirm password";
                                  } else if (cPassword.length < 8) {
                                    signupController.passwordValid.value =
                                        "Please enter at least 8 characters";
                                  } else if (signupController
                                          .confirmPwdController.text !=
                                      signupController.passwordController.text) {
                                    signupController.cPasswordValid.value =
                                        "Both password doesn't match";
                                  }
                                  signupController.update();
                                  return null;
                                },
                                labelText: 'Confirm password',
                                hintText: 'Confirm password',
                                controller:
                                    signupController.confirmPwdController),
                          ]),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height / 22),
                        isSignUp.value
                            ? progressView()
                            : inkWell(
                                child: customButton(
                                    inifinity: true,
                                    buttonText: 'Sign Up',
                                    context: context,
                                    plusButton: true),
                                onTap: () {
                                  _checkValidation(context);
                                },
                              ),
                        SizedBox(height: MediaQuery.of(context).size.height / 30),
                        inkWell(
                          onTap: () {
                            Get.to(LoginView());
                            Get.deleteAll();
                          },
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: "Have an account? ",
                                style: TextStyleConstant.black13),
                            TextSpan(
                                text: 'Login here',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(LoginView());
                                    Get.deleteAll();
                                  },
                                style: TextStyleConstant.black13
                                    .copyWith(color: ColorConstant.blueFE)),

                          ])),
                        ),
                        SizedBox(height: 10)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  RxBool isSignUp = false.obs;

  Future<void> _checkValidation(context) async {
    dismissKeyboard(context);
    if (_formKey.currentState!.validate() &&
        signupController.emailValid.value.isEmpty &&
        signupController.nameValid.value.isEmpty &&
        signupController.passwordValid.value.isEmpty &&
        signupController.cPasswordValid.value.isEmpty) {
      isSignUp = true.obs;
      signupController.update();
      await auth
          .createUserWithEmailAndPassword(
              email: signupController.emailController.text.trim(),
              password: signupController.passwordController.text.trim())
          .then((value) async {
        User? user = auth.currentUser;
        await FirebaseFirestore.instance.collection('user').doc(user?.uid).set({
          'email': user!.email,
          'userId': user.uid,
          'userName':
              capitalizeAllSentence(signupController.nameController.text.trim())
        });
        box.write('password', signupController.passwordController.text.trim());

        isSignUp = false.obs;
        signupController.update();
        showBottomLongToast("Account created successfully.");
        Get.to(SelectionView());
      }).catchError((e) {
        isSignUp = false.obs;
        signupController.update();
        if (e.toString() ==
            "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
          showBottomLongToast('Email already in use');
        } else if (e.toString() ==
            ' [firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.') {
          showBottomLongToast(
              'We have blocked all requests from this device due to unusual activity.Try again later.');
        } else {
          showBottomLongToast(e.toString());
        }
      });
    }
  }
}
