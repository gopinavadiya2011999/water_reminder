import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:waterreminder/app/modules/bottom_tab/views/bottom_tab_view.dart';
import 'package:waterreminder/model/user_model.dart';



class NotificationLogic {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
          'Water Reminder', 'Don\'t forget to drink water',
          importance: Importance.max, priority: Priority.max),
    );
  }

  static Future init(BuildContext context,String uid) async {

    print("%%%%%%%%%");
    tz.initializeTimeZones();
    final android = AndroidInitializationSettings('app_icon');
    final settings = InitializationSettings(android: android);
    await _notifications.initialize(settings,onSelectNotification: (payload) {

      Get.to(BottomTabView()) ;
      try {

        WaterRecords waterModel = WaterRecords();
        waterModel.time = Timestamp.fromDate(DateTime.now()).toString();
        waterModel.waterMl = '200';
        FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .update({'time_records':WaterRecords.toJson(waterModel)});
        Fluttertoast.showToast(msg: "Addition Successful");
      } catch (e) {

        Fluttertoast.showToast(msg: e.toString());
        print(e);
      }
      onNotifications.add(payload);
    });
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime dateTime,
  }) async {

    print("(((((*****)))))");
    // if (dateTime.isBefore(DateTime.now())) {
    //   dateTime = dateTime.add(Duration(days: 1));
    // }
    _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      await _notificationDetails(),
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
