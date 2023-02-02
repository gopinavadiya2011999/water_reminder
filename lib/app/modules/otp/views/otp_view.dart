import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:waterreminder/app/modules/reset_password/views/reset_password_view.dart';
import 'package:waterreminder/widgets/custom_image.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';

import '../../../../constant/color_constant.dart';
import '../../../../constant/text_style_constant.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/system_overlay_style.dart';
import '../controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  final String? email ;
  OtpView({Key? key,this. email}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final otpController = Get.put(OtpController());
    return GetBuilder(
      init: otpController,
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
                      width: 15.h,
                      child: Text('enter the OTP',
                          maxLines: 2,
                          style: TextStyleConstant.titleStyle.copyWith(
                              color: ColorConstant.black24,
                              fontSize: 17.sp,
                              wordSpacing: 2,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sora')),
                    ),
                    const SizedBox(height: 8),
                    Text("An 4 digit code sent to your email address",
                        style: TextStyleConstant.grey12),
                    SizedBox(height: 10.h),
                    Container(
                      height: 6.5.h,
                      child: OtpTextField(
                        fieldWidth: 6.h,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        numberOfFields: 4,
                        filled: true,
                        fillColor: ColorConstant.transparent,
                        margin: EdgeInsets.symmetric(horizontal: 2.5.h),
                        showCursor: true,

                        cursorColor: ColorConstant.blueFE,
                        showFieldAsBox: true,
                        borderRadius: BorderRadius.circular(15),
                        borderColor: ColorConstant.greyAF.withOpacity(0.5),
                        focusedBorderColor:
                            ColorConstant.greyAF.withOpacity(0.7),
                        styles: [
                          TextStyleConstant.grey16,
                          TextStyleConstant.grey16,
                          TextStyleConstant.grey16,
                          TextStyleConstant.grey16
                        ],
                        //showFieldAsBox: false,
                        borderWidth: 2,

                        onCodeChanged: (String code) {},
                        onSubmit: (String verificationCode) {}, // end onSubmit
                      ),
                    ),
                    SizedBox(height: 4.5.h),
                    inkWell(
                        child: customButton(
                            inifinity: true,
                            buttonText: 'Submit',
                            context: context,
                            plusButton: true),
                        onTap: () {
                          Get.to(ResetPasswordView(email:email));
                          // checkValidation(context);
                        }),
                    SizedBox(height: 3.h),
                    Align(
                      alignment: Alignment.center,
                      child: inkWell(
                        onTap: () {
                          // Get.to(LoginView());
                          // forgotController.emailController.clear();
                          // Get.deleteAll();
                        },
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: "If you didn't receive a code, ",
                              style: TextStyleConstant.black13),
                          TextSpan(
                              text: 'Resend',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Get.to(LoginView());
                                  // Get.deleteAll();
                                  // forgotController.emailController.clear();
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
          )),
    );
  }
}
