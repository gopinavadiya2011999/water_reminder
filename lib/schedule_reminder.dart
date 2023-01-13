import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:waterreminder/app/modules/AccountDetail/views/account_detail_view.dart';
import 'package:waterreminder/app/modules/bottom_tab/views/bottom_tab_view.dart';
import 'package:waterreminder/constant/color_constant.dart';
import 'package:waterreminder/constant/text_style_constant.dart';
import 'package:waterreminder/model/user_model.dart';
import 'package:waterreminder/notification_logic.dart';
import 'package:waterreminder/widgets/custom_back_button.dart';
import 'package:waterreminder/widgets/system_overlay_style.dart';
import 'main.dart';
import 'widgets/custom_inkwell.dart';

class ScheduleReminder extends StatefulWidget {
  final UserModel? userModel;

  const ScheduleReminder({Key? key, this.userModel}) : super(key: key);

  @override
  State<ScheduleReminder> createState() => _ScheduleReminderState();
}

class _ScheduleReminderState extends State<ScheduleReminder> {
  bool on = true;

  void listenNotifications() {
    NotificationLogic.onNotifications.listen((value) {});
  }

  void onClickedNotification(String? payload) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => BottomTabView()));
  }

  @override
  void initState() {
    super.initState();
    registerNotification();
    // if (widget.userModel!.token != null) {
    //   NotificationLogic.init(context, widget.userModel!.userId!);
    // }
  }


  FirebaseMessaging _messaging = FirebaseMessaging.instance;

  //register notification on firebase
  void registerNotification() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,

      badge: true,
      provisional: true,
      sound: true,
    );


    Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
     print("%%%% ${message.data}");
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      print("MESSAGE:: ${message.data}");

    });
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

        firebaseMessagingBackgroundHandler(message);
        RemoteNotification? remoteNotification = message.notification;
          AndroidNotification? android = message.notification?.android;

          if (remoteNotification != null && android != null && !kIsWeb) {
            flutterLocalNotificationsPlugin.show(
                remoteNotification.hashCode,
                remoteNotification.title,
                remoteNotification.body,

                NotificationDetails(
                    android: AndroidNotificationDetails('other_notifications',
                        'Other Notifications',
                        icon: 'ic_launcher_round',
                        enableVibration: true,
                        playSound: true,
                        importance: Importance.high,
                        priority: Priority.high,
                        ticker: 'ticker'),
                    iOS: IOSNotificationDetails()));

            const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('app_icon');
            IOSInitializationSettings initializationSettingsIOS =
            IOSInitializationSettings(
                onDidReceiveLocalNotification:
                onDidReceiveLocalNotification);
            final InitializationSettings initializationSettings =
            InitializationSettings(

                android: initializationSettingsAndroid,
                iOS: initializationSettingsIOS);
            flutterLocalNotificationsPlugin.initialize(initializationSettings,
                onSelectNotification: onSelectNotification);


          }

      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<dynamic> onSelectNotification(String? payload) async {
    print("payload:: ${payload}");
  }

  Future<dynamic> onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    print('receive Notification');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        child: Icon(Icons.add),
      ),
      body:inkWell(

        child: Center(
          child:Text("Send Notification")
        ), onTap: () {   NotificationLogic.showNotification(
          dateTime: DateTime.now(),
          id: 0,
          title: 'Water Reminder',
          body: "Don\'t forget to drink water"); },
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
                inkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: customBackButton(),
                ),
                Text('Schedule Reminder', style: TextStyleConstant.titleStyle),
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
}
