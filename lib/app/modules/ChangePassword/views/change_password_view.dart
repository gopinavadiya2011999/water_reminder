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

  TextEditingController passwordController = TextEditingController();
  TextEditingController newPwdController = TextEditingController();
  TextEditingController confirmNewPwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        dismissKeyboard(context);
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
            child: Column(
              children: [
                const SizedBox(height: 14),
                customTextField(
                    labelText: 'Current Password',
                    hintText: 'Password',
                    controller: passwordController),
                customTextField(
                    labelText: 'New Password',
                    hintText: 'Confirm Password',
                    controller: newPwdController),
                customTextField(
                    labelText: 'Confirm New Password',
                    hintText: 'Confirm New Password',
                    controller: confirmNewPwdController),
                const SizedBox(height: 30),
                customButton(
                  padding:  EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.height / 15,
                      vertical:  MediaQuery.of(context).size.width / 25),
                    buttonText: "Update Password",
                    context: context,
                    plusButton: true)
              ],
            ),
          )),
    );
  }
}
