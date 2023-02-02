import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:waterreminder/constant/color_constant.dart';
import 'package:waterreminder/constant/text_style_constant.dart';
import 'package:waterreminder/no_internet/check_network.dart';

import 'package:waterreminder/constant/toast.dart';
import 'package:waterreminder/widgets/custom_back_button.dart';
import 'package:waterreminder/widgets/custom_button.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';
import 'package:waterreminder/widgets/custom_text_field.dart';
import 'package:waterreminder/widgets/system_overlay_style.dart';
import 'package:yodo1mas/Yodo1MAS.dart';

import '../../../../ads/ads_data.dart';
import '../../../../main.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  ChangePasswordView({Key? key}) : super(key: key);
  final changePwdController = Get.put(ChangePasswordController());

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        changePwdController.clearController();
        return true;
      },
      child: CheckNetwork(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
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
                            bool? adsOpen = CommonHelper.interstitialAds();

                            if (adsOpen == null || adsOpen) {
                              Yodo1MAS.instance.showInterstitialAd();

                            }
                            dismissKeyboard(context);
                            changePwdController.clearController();
                            Navigator.pop(context);
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
            body: WillPopScope(
              onWillPop: ()async {
                bool? adsOpen = CommonHelper.interstitialAds();

                if (adsOpen == null || adsOpen) {
                  Yodo1MAS.instance.showInterstitialAd();

                }
                return true;
              },
              child: Container(
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
                                  "Please enter at least 8 characters";
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
                                  "Please enter at least 8 characters";
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
                                  "Please enter at least 8 characters";
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
                      cp.value
                          ? progressView()
                          : inkWell(
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
              ),
            )),
      ),
    );
  }

  RxBool cp = false.obs;

  Future<void> checkValidation(context) async {
    String? password = box.read('password');
    dismissKeyboard(context);
    if (_formKey.currentState!.validate() &&
        changePwdController.newPwdController.text.isNotEmpty &&
        changePwdController.passwordController.text.isNotEmpty &&
        changePwdController.confirmNewPwdController.text.isNotEmpty) {
      cp = true.obs;
      changePwdController.update();
      if (password != null &&
          password != changePwdController.passwordController.text.trim()) {
        cp = false.obs;
        changePwdController.update();
        showBottomLongToast("Current password doesn't match older password");
      } else if (password != null &&
          password == changePwdController.confirmNewPwdController.text.trim()) {
        cp = false.obs;
        changePwdController.update();
        showBottomLongToast(
            "Your password is same as older password please enter new password");
      } else {
        final cred = await EmailAuthProvider.credential(
            email: changePwdController.user!.email.toString(),
            password: password!);
        await changePwdController.user
            ?.reauthenticateWithCredential(cred)
            .then((value) async {
          await changePwdController.user
              ?.updatePassword(
                  changePwdController.confirmNewPwdController.text.trim())
              .then((_) {
            box.write('password',
                changePwdController.confirmNewPwdController.text.trim());
            cp = false.obs;
            changePwdController.update();
            showBottomLongToast('Password updated successfully');
            Get.back();
            Get.deleteAll();
          }).catchError((error) {
            cp = false.obs;
            changePwdController.update();
            showBottomLongToast(error.toString());
          });
        }).catchError((err) {
          cp = false.obs;
          changePwdController.update();
          if (err ==
              '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.') {
            showBottomLongToast(
                "Current password doesn't match older password");
          } else {
            showBottomLongToast(err.toString());
          }
        });
      }
    }
  }
}
