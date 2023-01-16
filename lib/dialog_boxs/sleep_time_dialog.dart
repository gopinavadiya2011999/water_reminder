import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:waterreminder/app/modules/account/controllers/account_controller.dart';
import 'package:waterreminder/toast.dart';
import 'package:waterreminder/widgets/custom_button.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';
import 'package:waterreminder/widgets/time_view.dart';

sleepTimeDialog(context, AccountController accountController,
    {required bool sleepTime}) {
  showDialog(
      context: context,
      builder: (context) {
        String hr = DateFormat.jm().format(DateTime.now()).split(":").first;
        String min = DateTime.now().minute.toString();
        String dn = DateFormat('a').format(DateTime.now()).toString();

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
                  context: context,
                  dayNightTime: ({dayNight}) {
                    // if (dayNight == 'AM') {
                    //   hr = '01';
                    // } else {
                    //   hr = '12';
                    // }

                    dn = dayNight!;
                  },
                  hours: ({hour}) {
                    hr = hour.toString();
                  },
                  minutes: ({minute}) {
                    min = minute.toString();
                  },
                ),
                const SizedBox(height: 24),
                inkWell(
                    onTap: () async {
                      if (sleepTime) {
                        accountController.sleepTime.value =
                            hr + ":" + min + " " + dn;
                        accountController.update();
                        FirebaseFirestore.instance
                            .collection('user')
                            .doc(accountController.userData.first.userId)
                            .update({
                          'bed_time': accountController.sleepTime.value
                        });
                      } else {
                        accountController.wakeUpTime.value =
                            hr + ":" + min + " " + dn;
                        accountController.update();
                        FirebaseFirestore.instance
                            .collection('user')
                            .doc(accountController.userData.first.userId)
                            .update({
                          'wakeup_time': accountController.wakeUpTime.value
                        });
                      }

                      accountController.userData = await getPrefData();
                      accountController.update();
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
