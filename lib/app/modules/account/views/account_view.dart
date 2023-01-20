import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:waterreminder/app/modules/AccountDetail/views/account_detail_view.dart';
import 'package:waterreminder/app/modules/schedule_reminder/views/schedule_reminder_view.dart';
import 'package:waterreminder/constant/text_style_constant.dart';
import 'package:waterreminder/dialog_boxs/logout_dialog.dart';
import 'package:waterreminder/dialog_boxs/schedule_dialog.dart';
import 'package:waterreminder/dialog_boxs/weight_dialog.dart';
import 'package:waterreminder/schedule_reminder.dart';
import 'package:waterreminder/widgets/custom_button.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';
import 'package:waterreminder/widgets/system_overlay_style.dart';
import '../../../../constant/color_constant.dart';
import '../../../../dialog_boxs/gender_dialog.dart';
import '../../../../dialog_boxs/sleep_time_dialog.dart';
import '../../../../dialog_boxs/water_dialog_view.dart';
import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  AccountView({Key? key}) : super(key: key);

  final accountController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(
      init: accountController,
      builder: (controller) => Scaffold(
        backgroundColor: ColorConstant.white,
        appBar: appBar(context),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: ColorConstant.whiteD9.withOpacity(.3),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: (1.5).h),
                if(accountController.userData.isNotEmpty)
                _listView(context),
                SizedBox(height: (2.9).h),
                inkWell(
                    child: customButton(
                        plusButton: true,
                        padding: EdgeInsets.symmetric(
                            horizontal: (2.5).h, vertical: (2.3).h),
                        buttonText: 'Schedule Reminder',
                        context: context),
                    onTap: () async {
                      QuerySnapshot<Map<String, dynamic>> snapShots =
                          await FirebaseFirestore.instance
                              .collection('user')
                              .doc(accountController.userData.first.userId)
                              .collection('reminder')
                              .get();
                      if (snapShots.docs.isEmpty) {
                        scheduleDialogDialog(context,
                            userModel: accountController.userData.first);
                      } else {
                        Get.to(ScheduleReminder(
                            userModel: accountController.userData.first));
                      }
                    }),
                SizedBox(height: 7.h),
                _logOut(context),
                SizedBox(height: (1.5).h),

              ],
            ),
          ),
        ),
      ),
    );
  }

  _customBoxView(
      {required GestureTapCallback onEditTap,
      required String title,
      required String value}) {
    return inkWell(
      onTap: onEditTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
            color: ColorConstant.white,
            border: Border.all(color: ColorConstant.grey80.withOpacity(.14)),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyleConstant.titleStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: (15.5).sp,
                        color: ColorConstant.black24)),
                SizedBox(height: (0.2).h),
                Text(
                  value,
                  style: TextStyleConstant.grey14
                      .copyWith(fontFamily: 'Sora', fontSize: (11.5).sp),
                )
              ],
            )),
            Image.asset('assets/edit.png',
                cacheWidth: 16, cacheHeight: 17, color: ColorConstant.greyAF)
          ],
        ),
      ),
    );
  }

  appBar(context) {
    return AppBar(
        title: Container(
            color: ColorConstant.white,
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Text('Account',
                        textAlign: TextAlign.center,
                        style: TextStyleConstant.titleStyle)),
                inkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => AccountDetailView()));
                    },
                    child: SvgPicture.asset('assets/settings.svg'))
              ],
            )),
        elevation: 0,
        automaticallyImplyLeading: false,
        systemOverlayStyle: systemOverlayStyle(),
        backgroundColor: ColorConstant.white);
  }

  _listView(context) {
    return Column(children: [
      _customBoxView(
          title: 'Gender',
          value: accountController.userData.first.gender!,
          onEditTap: () {
            openGenderDialog(context, accountController);
          }),
      _customBoxView(
          title: 'Weight',
          value: accountController.weight.value,
          onEditTap: () {
            weightDialog(context, accountController);
          }),
      _customBoxView(
          title: 'Water Intake Goal',
          value: accountController.waterGoal.value,
          onEditTap: () {
            waterDialog(context: context, accountController: accountController);
          }),
      _customBoxView(
          title: 'Sleep Time',
          value: accountController.sleepTime.value,
          onEditTap: () {
            sleepTimeDialog(context, accountController, sleepTime: true);
          }),
      _customBoxView(
          title: 'Wake Up Time',
          value: accountController.wakeUpTime.value,
          onEditTap: () {
            sleepTimeDialog(context, accountController, sleepTime: false);
          }),
    ]);
  }

  _logOut(context) {
    return inkWell(
      onTap: () {
        logOutDialog(context);
      },
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Logout',
                style: TextStyleConstant.white16
                    .copyWith(color: ColorConstant.black24)),
            Image.asset(
              'assets/logout.png',
              cacheHeight: 18,
              cacheWidth: 18,
              fit: BoxFit.fill,
            )
          ],
        ),
      ),
    );
  }
}
