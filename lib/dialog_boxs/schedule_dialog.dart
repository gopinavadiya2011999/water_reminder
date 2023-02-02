import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

scheduleDialogDialog(context, User? users,
    {DateTime? time, String? fromEdit, bool? onOff}) {

  bool added = false;
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
                      hr =hour
                          .toString()
                          .length ==
                          1
                          ? '0${hour}'
                          :  hour.toString();
                    },
                    minutes: ({minute}) {
                      min = minute.toString().length == 1
                          ? '0${minute}'
                          :minute.toString();
                    },
                  ),
                  const SizedBox(height: 24),
                  inkWell(
                      onTap: () async {
                        added =true;
                        if(added){
                          UserModel userModel = await getUserData(id: users?.uid);
                          QuerySnapshot<Map<String, dynamic>> snapShots =
                          await FirebaseFirestore.instance
                              .collection('user')
                              .doc(users?.uid)
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
                          Iterable<QueryDocumentSnapshot<Map<String, dynamic>>>? data;

                          String selectedTime =
                          convertTimeStamp(timestamp: timestamp);
                          data= snapShots.docs.where((element) =>convertTimeStamp(
                              timestamp: element.get('time')) ==
                              selectedTime );

                          if (data!=null && data.isNotEmpty) {
                            showBottomLongToast(
                                'Selected time is already exist');
                          }
                          else {
                            if (dateTime.isBefore(TimeConverter(TimeOfDay(
                                hour: int.parse(sleepTime.first),
                                minute: int.parse(sleepTime.last)))) ||
                                dateTime.isAfter(TimeConverter(TimeOfDay(
                                    hour: int.parse(WakeUpTime.first),
                                    minute: int.parse(WakeUpTime.last))))) {
                              reminderModel.time = timestamp;
                              reminderModel.onOff = onOff!=null?onOff:false;
                              if (fromEdit != null) {
                                FirebaseFirestore.instance
                                    .collection('user')
                                    .doc(users?.uid)
                                    .collection('reminder')
                                    .doc(fromEdit)
                                    .update(reminderModel.toMap());
                              } else {
                                FirebaseFirestore.instance
                                    .collection('user')
                                    .doc(users?.uid)
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
                        }


                        Get.back();
                        Get.to(ScheduleReminder());
                        added=false;
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

getUserData({String? id}) async {
  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('user')
      .doc(id)
      .collection('user-info')
      .get();
  return UserModel(
      waterGoal: snapshot.docs.first['water_goal'],
      gender: snapshot.docs.first['gender'],
      weight: snapshot.docs.first['weight'],
      userId: snapshot.docs.first.id,
      wakeUpTime: snapshot.docs.first['wakeup_time'],
      bedTime: snapshot.docs.first['bed_time'],
      drinkableWater: snapshot.docs.first['drinkableWater'],
      time: snapshot.docs.first['time'],
      notification: snapshot.docs.first['notification']);
}

getWaterData({String? id}) async {
  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('user')
      .doc(id)
      .collection('water_records')
      .get();

  return snapshot.docs.length;
}
