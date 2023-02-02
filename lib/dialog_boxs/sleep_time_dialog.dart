import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterreminder/ads/ads_data.dart';
import 'package:waterreminder/app/modules/account/controllers/account_controller.dart';
import 'package:waterreminder/widgets/custom_button.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';
import 'package:waterreminder/widgets/time_view.dart';
import 'package:yodo1mas/testmasfluttersdktwo.dart';

sleepTimeDialog(context, AccountController accountController,
    {required bool sleepTime, String? id}) {
  DateTime formattedTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      int.parse(sleepTime
          ? accountController.sleepTime.value.split(":").first
          : accountController.wakeUpTime.value.split(":").first),
      int.parse(sleepTime
          ? accountController.sleepTime.value.split(":").last.split(" ").first
          : accountController.wakeUpTime.value
              .split(":")
              .last
              .split(" ")
              .first));
  showDialog(
      context: context,
      builder: (context) {
        String hr = sleepTime
            ? accountController.sleepTime.value.split(":").first
            : accountController.wakeUpTime.value.split(":").first;
        String min = sleepTime
            ? accountController.sleepTime.value.split(":").last.split(' ').first
            : accountController.wakeUpTime.value
                .split(":")
                .last
                .split(' ')
                .first;
        String dn = sleepTime
            ? accountController.sleepTime.value.split(":").last.split(' ').last
            : accountController.wakeUpTime.value
                .split(":")
                .last
                .split(' ')
                .last;

        return AlertDialog(
          shape: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8)),
          contentPadding: EdgeInsets.zero,
          content: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 27),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                timeView(
                  time: formattedTime,
                  context: context,
                  dayNightTime: ({dayNight}) {
                    if (dayNight == 'AM') {
                      hr = '01';
                    } else {
                      hr = '12';
                    }

                    dn = dayNight!;
                  },
                  hours: ({hour}) {
                    hr =hour.toString().length == 1
                        ? '0${hour}'
                        : hour.toString();
                  },
                  minutes: ({minute}) {
                    min = minute.toString().length == 1
                        ? '0${minute}'
                        : minute.toString();
                  },
                ),
                const SizedBox(height: 24),
                inkWell(
                    onTap: () async {
                      bool? adsOpen = CommonHelper.interstitialAds();

                      if (adsOpen == null || adsOpen) {
                        Yodo1MAS.instance.showInterstitialAd();
                      }
                      if (sleepTime) {
                        accountController.sleepTime.value =
                            hr + ":" + min + " " + dn;
                        accountController.update();
                        FirebaseFirestore.instance
                            .collection('user')
                            .doc(accountController.user?.uid)
                            .collection('user-info')
                            .doc(id)
                            .update({
                          'bed_time': accountController.sleepTime.value
                        });
                      } else {
                        accountController.wakeUpTime.value =
                            hr + ":" + min + " " + dn;
                        accountController.update();
                        FirebaseFirestore.instance
                            .collection('user')
                            .doc(accountController.user?.uid)
                            .collection('user-info')
                            .doc(id)
                            .update({
                          'wakeup_time': accountController.wakeUpTime.value
                        });
                      }

                      Get.back();
                    },
                    child: customButton(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.height / 11,
                            vertical: MediaQuery.of(context).size.width / 25),
                        plusButton: true,
                        buttonText: 'Save',
                        context: context)),
              ],
            ),
          ),
        );
      });
}
