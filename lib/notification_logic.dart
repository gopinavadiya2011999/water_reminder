import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:uuid/uuid.dart';
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

  static Future init(BuildContext context, String uid, UserModel? userModel) async {
    tz.initializeTimeZones();
    final android = AndroidInitializationSettings('app_icon');
    final settings = InitializationSettings(android: android);
    await _notifications.initialize(settings, onSelectNotification: (payload) {


        if ((int.parse(userModel!.waterGoal.toString().split('ml').first.trim()) !=
            int.parse(
                userModel.waterGoal.toString().split('ml').first.trim()) )&&
           ( int.parse(userModel.drinkableWater.toString()) <=
                int.parse(
                    userModel.waterGoal.toString().split('ml').first.trim()))) {
          Uuid uuid = const Uuid();

          WaterRecords waterModel = WaterRecords();
          waterModel.time = Timestamp.fromDate(DateTime.now()).toString();
          waterModel.waterMl = '200';
          waterModel.timeId=uuid.v1() + DateTime.now().millisecondsSinceEpoch.toString();
          FirebaseFirestore.instance.collection('user').doc(uid).update({
            'drinkableWater': (int.parse(userModel.drinkableWater!) + 200).toString(),
                });

          FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .collection('water_records')
              .doc()
              .set(WaterRecords.toJson(waterModel));
          Fluttertoast.showToast(msg: "Addition Successful");
        }
      onNotifications.add(payload);
        Get.to(BottomTabView());
    });
  }

  @pragma('vm:entry-point')
  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime dateTime,
  }) async {
    if (dateTime.isBefore(DateTime.now())) {
      dateTime = dateTime.add(Duration(days: 1));
    }
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
