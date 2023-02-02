
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:waterreminder/app/modules/bottom_tab/views/bottom_tab_view.dart';
import 'package:waterreminder/app/modules/home/views/home_view.dart';
import 'package:waterreminder/constant/color_constant.dart';
import 'package:waterreminder/constant/text_style_constant.dart';
import 'package:waterreminder/custom_pop_up.dart';
import 'package:waterreminder/dialog_boxs/schedule_dialog.dart';
import 'package:waterreminder/main.dart';
import 'package:waterreminder/model/reminder_model.dart';
import 'package:waterreminder/model/user_model.dart';
import 'package:waterreminder/notification_logic.dart';
import 'package:waterreminder/toast.dart';
import 'package:waterreminder/widgets/custom_back_button.dart';
import 'package:waterreminder/widgets/system_overlay_style.dart';
import 'widgets/custom_inkwell.dart';

class ScheduleReminder extends StatefulWidget {
  const ScheduleReminder({Key? key}) : super(key: key);

  @override
  State<ScheduleReminder> createState() => _ScheduleReminderState();
}

class _ScheduleReminderState extends State<ScheduleReminder> {
  bool on = true;
  User? user;
  Rx<UserModel>? userModel = UserModel().obs;

  void listenNotifications() {
    NotificationLogic.onNotifications.listen((value) {
      print("value ::: $value");
    });
  }

  void onClickedNotification(String? payload) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => BottomTabView()));
  }

  @override
  initState() {
    super.initState();

    user = auth.currentUser;

    emitter.on('notify', this, (ev, context) async {

      switch (ev.eventName) {
        case 'notify':
          getUserModel();
          break;
      }
    });
    emitter.emit('notify');
    getUserModel();
    NotificationLogic.init(context: context, uid: user?.uid);

    listenNotifications();
  }

  getUserModel() async {
    userModel = Rx(await getUserData(id: user?.uid));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emitter.removeListener('notify', (ev, context) {
      switch (ev.eventName) {
        case 'notify':
          getUserModel();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore
    //     .instance
    //     .collection('user')
    //     .doc(user?.uid)
    //     .collection('user-info')
    //     .get().then((value) => {
    //       print("value :: ${value.docs.first['notification']}")
    // });
    // print("888888 :${snapshot.docs.first['notification']}");
    return Scaffold(

        // extendBodyBehindAppBar: false,
        appBar: appBar(context),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('user')
                    .doc(user?.uid)
                    .collection('reminder')
                    .orderBy('time')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(ColorConstant.blueFE),
                      ),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("Nothing to show"));
                  }
                  final data = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data!.docs.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(
                          data.docs[index].get('time').microsecondsSinceEpoch);

                      String formattedTime = DateFormat.jm().format(dateTime);

                      if (user != null &&
                          data.docs[index].get('onOff') &&
                          (userModel != null &&
                              userModel!.value.notification == true)) {
                        // print("${getDateFromStringNew(
                        //     DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime),
                        //     formatter: "dd/MM/yyyy HH:mm:ss")} *** ${getDateFromStringNew(
                        //     DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime),
                        //     formatter: "dd/MM/yyyy HH:mm:ss")}");

                        // if(dateTime.isBefore(DateTime.now())){
                        //   print("&&&&&&");
                        //    int sec  = (getDateFromStringNew(
                        //       DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()),
                        //       formatter: "dd/MM/yyyy HH:mm:ss")
                        //       .difference(getDateFromStringNew(
                        //       DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime),
                        //       formatter: "dd/MM/yyyy HH:mm:ss"))
                        //       .inSeconds)*86400;
                        //   // print("SEC:::${sec}");
                        //   NotificationLogic.showNotification(
                        //       sec:sec,
                        //       dateTime: dateTime,
                        //       id: 0,
                        //       title: 'Water Reminder',
                        //       body: "Don\'t forget to drink water");
                        // }
                        // else{

                          // int   selectedExpireSec = (getDateFromStringNew(
                          //     DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime),
                          //     formatter: "dd/MM/yyyy HH:mm:ss")
                          //     .difference(getDateFromStringNew(
                          //     DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()),
                          //     formatter: "dd/MM/yyyy HH:mm:ss"))
                          //     .inSeconds);

                          // print("selectedExpireSec : ${selectedExpireSec}");
                          NotificationLogic.showNotification(
                             // sec:selectedExpireSec,
                              dateTime: dateTime,
                              id: 0,
                              title: 'Water Reminder',
                              body: "Don\'t forget to drink water\nTap to drink water");
                      //  }

                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        decoration: BoxDecoration(
                            color: ColorConstant.white,
                            border: Border.all(
                                color: ColorConstant.grey80.withOpacity(.14)),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(formattedTime,
                                    style: TextStyleConstant.black13
                                        .copyWith(fontSize: 18)),
                                Text(
                                  "Everyday",
                                  style: TextStyleConstant.grey14.copyWith(
                                      fontFamily: 'Sora', letterSpacing: -0.3),
                                )
                              ],
                            ),
                            Spacer(),
                            Row(
                              children: [
                                SizedBox(
                                  width: 40,
                                  height: 30,
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Switch(
                                      onChanged: (value) {
                                        ReminderModel reminder =
                                            ReminderModel();
                                        reminder.onOff = value;
                                        reminder.time =
                                            data.docs[index].get('time');
                                        FirebaseFirestore.instance
                                            .collection('user')
                                            .doc(user?.uid)
                                            .collection('reminder')
                                            .doc(data.docs[index].id)
                                            .update(reminder.toMap());
                                        emitter.emit('notify');
                                      },
                                      activeColor: ColorConstant.blueFE,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      value: data.docs[index].get('onOff'),
                                    ),
                                  ),
                                ),
                                CustomPopupMenu(
                                  showArrow: false,
                                  horizontalMargin: 40,
                                  barrierColor: Colors.transparent,
                                  onTap: ({String? item}) {
                                    if (item == 'Delete') {
                                      FirebaseFirestore.instance
                                          .collection('user')
                                          .doc(user?.uid)
                                          .collection('reminder')
                                          .doc(data.docs[index].id)
                                          .delete();
                                      emitter.emit('notify');

                                      showBottomLongToast("Reminder deleted");
                                    } else {
                                      scheduleDialogDialog(context, user,
                                          onOff: data.docs[index].get('onOff'),
                                          time: dateTime,
                                          fromEdit: data.docs[index].id);
                                      emitter.emit('notify');
                                    }
                                  },
                                  pressType: PressType.singleClick,
                                  position: (index != 0 &&
                                          snapshot.data!.docs.length - 1 ==
                                              index)
                                      ? PreferredPosition.top
                                      : PreferredPosition.bottom,
                                  child: Icon(Icons.more_vert_outlined,
                                      color: ColorConstant.grey80),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            inkWell(
              onTap: () => scheduleDialogDialog(context, user),
              child: SafeArea(
                child: Container(
                    height: 7.h,
                    width: 60.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: ColorConstant.blueFE),
                    margin: EdgeInsets.only(bottom: 10,top: 10),
                    child: Text('Schedule Reminder',
                        textAlign: TextAlign.center,
                        style: TextStyleConstant.white16)),
              ),
            ),
          ],
        ));
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
                Expanded(
                    child: Text('Schedule Reminders',
                        textAlign: TextAlign.center,
                        style: TextStyleConstant.titleStyle)),
              ],
            )),
        elevation: 0,
        automaticallyImplyLeading: false,
        // systemOverlayStyle: systemOverlayStyle(),
        backgroundColor: ColorConstant.white);
  }
}
