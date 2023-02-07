import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:uuid/uuid.dart';
import 'package:waterreminder/app/modules/bottom_tab/views/bottom_tab_view.dart';
import 'package:waterreminder/model/user_model.dart';
import 'package:waterreminder/constant/toast.dart';

import 'dialog_boxs/schedule_dialog.dart';

class NotificationLogic {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'Water Reminder',
        'Don\'t forget to drink water',
        importance: Importance.max,
        priority: Priority.max,
        enableVibration: true,
        visibility: NotificationVisibility.public,
        playSound: true,
      ),
    );
  }

  static Future init({
    BuildContext? context,
    String? uid,
  }) async {
    UserModel? userModel;
    if (uid != null) {
      userModel = await getUserData(id: uid);
    }
    tz.initializeTimeZones();
    final android = AndroidInitializationSettings('app_icon');
    final settings = InitializationSettings(android: android);

    await _notifications.initialize(settings, onSelectNotification: (payload) {
      Uuid uuid = const Uuid();

      WaterRecords waterModel = WaterRecords();
      waterModel.time = Timestamp.now();
      waterModel.waterMl = '200ml';
      waterModel.totalWaterMl=userModel!.waterGoal!;
      waterModel.timeId =
          uuid.v1() + DateTime.now().millisecondsSinceEpoch.toString();
      if (userModel != null) {

        FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .collection('water_records')
            .doc()
            .set(WaterRecords.toJson(waterModel));
        showBottomLongToast("Addition Successful");
      }

      onNotifications.add(payload);
      Get.to(BottomTabView());
    });
  }

  @pragma('vm:entry-point')
  static Future showNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      //  required int sec,
      required DateTime dateTime}) async {
    // if (dateTime.isBefore(DateTime.now())) {
    //   dateTime = dateTime.add(Duration(days: 1));
    // }
    print("date time :: $dateTime");

    _notifications.zonedSchedule(
      UniqueKey().hashCode,
      title,
      body,
      _scheduleDaily(Time(dateTime.hour, dateTime.minute, dateTime.second)),
      /*  tz.TZDateTime.from(
         */ /*dateTime*/ /*
          */ /*DateTime.now().add(Duration(seconds: sec))*/ /*,
          tz.local),*/
      await _notificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    // _notifications.showDailyAtTime(id, title, body,
    //     // payload: {'rr':'Drink Water'},
    //     Time(int.parse(DateFormat('HH').format(dateTime)),
    //   int.parse(DateFormat('mm').format(dateTime)),
    //     int.parse(DateFormat('ss').format(dateTime)),
    // ),await _notificationDetails());

    // _notifications.zonedSchedule(
    //   UniqueKey().hashCode,
    //   title,
    //   body,
    //   tz.TZDateTime.from(
    //       dateTime
    //       /*DateTime.now().add(Duration(seconds: sec))*/,
    //       tz.local),
    //   await _notificationDetails(),
    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.absoluteTime,
    //   androidAllowWhileIdle: true,
    //   matchDateTimeComponents: DateTimeComponents.time,
    // );
  }

  static tz.TZDateTime _scheduleDaily(Time time) {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime schdeuledDate = tz.TZDateTime.from(
        DateTime(
            now.year, now.month, now.day, time.hour, time.minute, time.second),
        tz.local);
    return schdeuledDate.isBefore(now)
        ? schdeuledDate.add(const Duration(days: 1))
        : schdeuledDate;
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}

DateTime getDateFromStringNew(String dateString, {String? formatter}) {
  const String kMainSourceFormat = "yyyy-MM-dd'T'HH:mm:ss";
  if (formatter == null) {
    formatter = kMainSourceFormat;
  }
  return DateFormat(formatter).parse(dateString, true);
}
