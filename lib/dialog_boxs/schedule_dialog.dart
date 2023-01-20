import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:waterreminder/model/reminder_model.dart';
import 'package:waterreminder/model/user_model.dart';
import 'package:waterreminder/schedule_reminder.dart';
import 'package:waterreminder/toast.dart';
import 'package:waterreminder/widgets/custom_button.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';
import 'package:waterreminder/widgets/time_view.dart';

scheduleDialogDialog(context, {required UserModel userModel, DateTime? time,String? fromEdit, bool? onOff }) {

  showDialog(
      context: context,
      builder: (context) {
        String hr = DateTime.now().hour.toString();
        String min = DateTime.now().minute.toString();
        String dn = DateFormat('a').format(DateTime.now()).toString();
        DateTime dateTime = DateTime.now();
        return StatefulBuilder(builder: (context, setState) {
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
                    time: time,
                    context: context,
                    dayNightTime: ({dayNight}) {
                      if (dayNight.toString() == 'AM') {
                        hr = '01';
                      } else {
                        hr = '12';
                      }
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
                      onTap:  ()async {
                        QuerySnapshot<Map<String, dynamic>> snapShots =
                            await FirebaseFirestore.instance
                                .collection('user')
                                .doc(userModel.userId)
                                .collection('reminder')
                                .get();

                        dateTime = DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            int.parse(hr),
                            int.parse(min));
                        Timestamp timestamp = Timestamp.fromDate(dateTime);
                        ReminderModel reminderModel = ReminderModel();
                        List<String> sleepTime = userModel.bedTime!
                            .toString()
                            .split(' ')
                            .first
                            .split(':');
                        List<String> WakeUpTime = userModel.wakeUpTime!
                            .toString()
                            .split(' ')
                            .first
                            .split(':');
                        if (snapShots.docs.isNotEmpty) {
                          snapShots.docs.forEach((element) {
                            String selectedTime =
                                convertTimeStamp(timestamp: timestamp);
                            if (convertTimeStamp(
                                    timestamp: element.get('time')) ==
                                selectedTime) {

                              showBottomLongToast(
                                  'Selected time is already exist');
                            } else {


                                if (dateTime.isBefore(TimeConverter(TimeOfDay(
                                    hour: int.parse(sleepTime.first),
                                    minute: int.parse(sleepTime.last)))) ||
                                    dateTime.isAfter(TimeConverter(TimeOfDay(
                                        hour: int.parse(WakeUpTime.first),
                                        minute: int.parse(WakeUpTime.last))))) {
                                  reminderModel.time = timestamp;
                                  reminderModel.onOff =onOff?? false;
                                  if(fromEdit!=null){
                                    FirebaseFirestore.instance
                                        .collection('user')
                                        .doc(userModel.userId)
                                        .collection('reminder')
                                        .doc(fromEdit)
                                        .update(reminderModel.toMap());
                                  }
                                  else{
                                    FirebaseFirestore.instance
                                        .collection('user')
                                        .doc(userModel.userId)
                                        .collection('reminder')
                                        .doc()
                                        .set(reminderModel.toMap());
                                  }
                                  showBottomLongToast("Reminder added");

                                } else {
                                  showBottomLongToast(
                                      'Please select reminder after wake and before sleep time');
                                }

                            }
                          });
                        }else{

                            if (dateTime.isBefore(TimeConverter(TimeOfDay(
                                hour: int.parse(sleepTime.first),
                                minute: int.parse(sleepTime.last)))) ||
                                dateTime.isAfter(TimeConverter(TimeOfDay(
                                    hour: int.parse(WakeUpTime.first),
                                    minute: int.parse(WakeUpTime.last))))) {
                              reminderModel.time = timestamp;
                              reminderModel.onOff = false;
                              if(fromEdit!=null){
                                print("^^^^^ ${timestamp}");
                                FirebaseFirestore.instance
                                    .collection('user')
                                    .doc(userModel.userId)
                                    .collection('reminder')
                                    .doc(fromEdit)
                                    .update(reminderModel.toMap());
                              }
                              else{
                                FirebaseFirestore.instance
                                    .collection('user')
                                    .doc(userModel.userId)
                                    .collection('reminder')
                                    .doc()
                                    .set(reminderModel.toMap());
                              }
                              showBottomLongToast("Reminder added");

                            } else {
                              showBottomLongToast(
                                  'Please select reminder after wake and before sleep time');
                            }

                        }


                        Get.back();
                        Get.to(ScheduleReminder(userModel: userModel));
                      },
                      child: customButton(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.height / 11,
                              vertical: MediaQuery.of(context).size.width / 25),
                          plusButton: true,
                          buttonText: 'Save',
                          context: context)),
                ],
              ),
            ),
          );
        });
      });
}

convertTimeStamp({required Timestamp timestamp}) {
  DateTime dateTime =
      DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);
  String formattedTime = DateFormat.jm().format(dateTime);
  return formattedTime;
}

DateTime TimeConverter(TimeOfDay time) {
  return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
      time.hour, time.minute);
}
