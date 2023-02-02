import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterreminder/widgets/custom_button.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';
import 'package:waterreminder/widgets/time_view.dart';

import '../toast.dart';

editDialog(context, {String? time, String? userId, required String waterId}) {
  DateTime formattedTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      int.parse(time!.split(":").first),
      int.parse(time.split(":").last.split(" ").first));

  showDialog(
      context: context,
      builder: (context) {
        String hr = time.toString().split(':').first.toString();
        String min =
            time.toString().split(':').last.split(' ').first.toString();
        String dn = time.toString().split(':').last.split(' ').last.toString();

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
                    hr =hour
                        .toString()
                        .length ==
                        1
                        ? '0${hour}'
                        :  hour.toString();
                  },
                  minutes: ({minute}) {
                    min =minute.toString().length == 1
                        ? '0${minute}'
                        : minute.toString();
                  },
                ),
                const SizedBox(height: 24),
                inkWell(
                    onTap: () {
                     DateTime dateTime = DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          int.parse(hr),
                          int.parse(min));
                      Timestamp timestamp = Timestamp.fromDate(dateTime);
                      FirebaseFirestore.instance
                          .collection('user')
                          .doc(userId)
                          .collection('water_records')
                          .doc(waterId)
                          .update({'time':timestamp });
                      showBottomLongToast("Water updated successfully");

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
