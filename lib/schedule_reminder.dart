import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:waterreminder/app/modules/bottom_tab/views/bottom_tab_view.dart';
import 'package:waterreminder/constant/color_constant.dart';
import 'package:waterreminder/constant/text_style_constant.dart';
import 'package:waterreminder/custom_pop_up.dart';
import 'package:waterreminder/dialog_boxs/schedule_dialog.dart';
import 'package:waterreminder/model/reminder_model.dart';
import 'package:waterreminder/model/user_model.dart';
import 'package:waterreminder/notification_logic.dart';
import 'package:waterreminder/toast.dart';
import 'package:waterreminder/widgets/custom_back_button.dart';
import 'package:waterreminder/widgets/system_overlay_style.dart';
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

    NotificationLogic.init(
        context, widget.userModel!.userId!, widget.userModel);
    listenNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton:  inkWell(
          onTap: () =>
              scheduleDialogDialog(context, userModel: widget.userModel!),
          child: Container(
              height:7.h,
              width: 60.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: ColorConstant.blueFE),
              margin: EdgeInsets.only(bottom: 20),
              child: Text('Schedule Reminder',
                  textAlign: TextAlign.center,
                  style: TextStyleConstant.white16)),
        ),
        // extendBodyBehindAppBar: false,
        appBar: appBar(context),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('user')
                    .doc(widget.userModel!.userId)
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

                      on = data.docs[index].get('onOff');
                      if (on) {
                        NotificationLogic.showNotification(
                            dateTime: dateTime,
                            id: 0,
                            title: 'Water Reminder',
                            body: "Don\'t forget to drink water");
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
                                            .doc(widget.userModel!.userId)
                                            .collection('reminder')
                                            .doc(data.docs[index].id)
                                            .update(reminder.toMap());
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
                                          .doc(widget.userModel!.userId)
                                          .collection('reminder')
                                          .doc(data.docs[index].id)
                                          .delete();
                                      showBottomLongToast("Reminder deleted");
                                    } else {
                                      scheduleDialogDialog(context,
                                          userModel: widget.userModel!,onOff:data.docs[index].get('onOff'),time: dateTime,fromEdit: data.docs[index].id);
                                    }
                                  },
                                  pressType: PressType.singleClick,
                                  position: (index!=0 &&
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
        systemOverlayStyle: systemOverlayStyle(),
        backgroundColor: ColorConstant.white);
  }
}
