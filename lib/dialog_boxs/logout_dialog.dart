import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterreminder/app/modules/splash/views/splash_view.dart';
import 'package:waterreminder/constant/color_constant.dart';
import 'package:waterreminder/constant/text_style_constant.dart';
import 'package:waterreminder/main.dart';
import 'package:waterreminder/widgets/custom_divider.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';

logOutDialog(context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        actionsPadding: EdgeInsets.zero,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              customDivider(
                  color: ColorConstant.grey80.withOpacity(.3),
                  context: context,
                  width: double.infinity),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    logOutAlertButton(
                        buttonText: 'Cancel',
                        onTap: () => Navigator.pop(context)),
                    Container(
                        width: 1, color: ColorConstant.grey80.withOpacity(.5)),
                    logOutAlertButton(
                        buttonText: 'Logout',
                        onTap: () {
                          box.write('login', false);
                          box.write('save','');
                          Get.deleteAll();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SplashScreen()),
                              (route) => false);
                        }),
                  ],
                ),
              )
            ],
          )
        ],
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Logout", style: TextStyleConstant.blue20),
            const SizedBox(height: 24),
            Text("Are you sure do you want to logout?",
                style: TextStyleConstant.white16
                    .copyWith(color: ColorConstant.black24))
          ],
        ),
      );
    },
  );
}

logOutAlertButton(
    {required GestureTapCallback onTap, required String buttonText}) {
  return Expanded(
    child: inkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style:
              TextStyleConstant.titleStyle.copyWith(color: ColorConstant.black),
        ),
      ),
    ),
  );
}
