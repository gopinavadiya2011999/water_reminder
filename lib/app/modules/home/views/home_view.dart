import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/eventify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';
import 'package:waterreminder/ads/ads_data.dart';
import 'package:waterreminder/dialog_boxs/edit_dialog.dart';
import 'package:waterreminder/model/user_model.dart';
import 'package:waterreminder/toast.dart';
import 'package:waterreminder/widgets/custom_button.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';
import 'package:waterreminder/widgets/system_overlay_style.dart';
import 'package:yodo1mas/Yodo1MAS.dart';
import 'package:yodo1mas/Yodo1MasBannerAd.dart';
import '../../../../constant/color_constant.dart';
import '../../../../constant/text_style_constant.dart';
import '../../../../custom_pop_up.dart';
import '../../../../main.dart';
import '../../../../no_internet/check_network.dart';
import '../../../../ads/timer_service.dart';
import '../../settings/views/settings_view.dart';
import '../controllers/home_controller.dart';

EventEmitter emitter = EventEmitter();

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: homeController,
      builder: (controller) => CheckNetwork(
        child: Scaffold(
          backgroundColor: ColorConstant.white,
          appBar: AppBar(

            automaticallyImplyLeading: false,
            title: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('user')
                    .doc(homeController.user?.uid)
                    .collection('user-info')
                    .snapshots(),
                builder: (BuildContext context, snapshot) {
                  return Container(
                      color: ColorConstant.white,
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (homeController.user != null &&
                              snapshot.data != null)
                            Image.asset(
                                snapshot.data?.docs.first.get('gender') ==
                                        'Female'
                                    ? 'assets/female.png'
                                    : snapshot.data?.docs.first
                                                .get('gender') ==
                                            'Male'
                                        ? 'assets/male_small.png'
                                        : 'assets/other_small.png',
                                cacheHeight: 40,
                                cacheWidth: 40,
                                fit: BoxFit.fill),
                          Text('Water Reminder',
                              style: TextStyleConstant.titleStyle),
                          inkWell(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .push(MaterialPageRoute(
                                        builder: (context) =>
                                            SettingsView()));
                              },
                              child: SvgPicture.asset('assets/settings.svg'))
                        ],
                      ));
                }),
            elevation: 0,

           // systemOverlayStyle: systemOverlayStyle(),
            backgroundColor: ColorConstant.transparent,
          ),
          body: homeController.user != null
              ? StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('user')
                      .doc(homeController.user?.uid)
                      .collection('user-info')
                      .snapshots(),
                  builder: (context, snapshot) {
                    // if (snapshot.connectionState ==
                    //     ConnectionState.waiting) {
                    //   return Center(
                    //     child: CircularProgressIndicator(
                    //       valueColor: AlwaysStoppedAnimation<Color>(
                    //           ColorConstant.blueFE),
                    //     ),
                    //   );
                    // }

                    if (snapshot.hasData) {
                      return Container(
                        height: double.infinity,
                        width: double.infinity,
                        padding: const EdgeInsets.only(bottom: 8),
                        color: ColorConstant.whiteD9.withOpacity(.3),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              if (homeController.user != null)
                                Column(
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 20),
                                        child: bannerAds()),
                                    if (snapshot.data != null)
                                      _progressBar(
                                          snapshot: snapshot.data?.docs.first,
                                          context: context),
                                    SizedBox(height: 2.5.h),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 20),
                                        child: bannerAds()),
                                    inkWell(
                                        child: customButton(
                                            buttonText: "Add Water",
                                            context: context),
                                        onTap: () {
                                          addWater(
                                              id: snapshot
                                                  .data?.docs.first.id,
                                              snapshot:
                                                  snapshot.data!.docs.first);
                                        }),
                                  ],
                                ),
                              SizedBox(height: 3.3.h),
                              _listView(context,
                                  snapshots: snapshot.data!.docs.first)
                            ],
                          ),
                        ),
                      );
                    }

                    return Container();
                  })
              : Container(),
        ),
      ),
    );
  }

  double getPercentage(snapshot) {
    return int.parse(snapshot!['drinkableWater'].toString()) /
        int.parse(snapshot!['water_goal'].toString().split('ml').first.trim());
  }

  _progressBar(
      {required BuildContext context,
      DocumentSnapshot<Map<String, dynamic>>? snapshot}) {
    return CircularPercentIndicator(
        radius: 16.5.h,
        // animation: true,
        animationDuration: 1200,
        lineWidth: 28,
        startAngle: 20,
        percent: getPercentage(snapshot) <= 1 ? getPercentage(snapshot) : 1,
        center: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width / 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "200 ml",
                  style: TextStyleConstant.grey14,
                ),
                RichText(
                    text: TextSpan(
                        style: TextStyleConstant.black24.copyWith(fontSize: 22),
                        children: [
                      TextSpan(
                          text: snapshot!['drinkableWater'],
                          style: TextStyleConstant.black24.copyWith(
                              fontSize: 22, color: ColorConstant.blueFE)),
                      const TextSpan(text: '/'),
                      TextSpan(text: snapshot['water_goal']),
                    ])),
                Divider(
                    height: 2, thickness: 1.2, color: ColorConstant.whiteD9),
                const SizedBox(height: 5),
                Text(
                  "You have completed ${(int.parse(snapshot['drinkableWater'].toString()) / int.parse(snapshot['water_goal'].toString().split('ml').first.trim()) * 100).floor()}% of your daily drink target",
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: TextStyleConstant.grey14.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        backgroundColor: ColorConstant.bluF7,
        progressColor: ColorConstant.blueFE);
  }

  _listView(context,
      {required QueryDocumentSnapshot<Map<String, dynamic>> snapshots}) {
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Today's Record",
                  style: TextStyleConstant.titleStyle,
                  textAlign: TextAlign.start),
              const SizedBox(height: 16),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('user')
                      .doc(homeController.user!.uid)
                      .collection('water_records')
                      .orderBy('time')
                      .snapshots(),
                  builder: (context, snapshot) {
                    // if (snapshot.connectionState == ConnectionState.waiting) {
                    //   return Center(
                    //     child: CircularProgressIndicator(
                    //       valueColor: AlwaysStoppedAnimation<Color>(
                    //           ColorConstant.blueFE),
                    //     ),
                    //   );
                    // }

                    if (snapshot.data != null && snapshot.data!.docs.isEmpty) {
                      return _noData(context);
                    }
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                           if (snapshot.data!.docs[index].get('time') != null &&
                              DateFormat('dd/MM/yyyy').format(DateTime.now()) !=
                                  DateFormat('dd/MM/yyyy').format(
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          snapshot.data!.docs[index]
                                              .get('time')
                                              .microsecondsSinceEpoch))) {
                            FirebaseFirestore.instance
                                .collection('user')
                                .doc(homeController.user?.uid)
                                .collection('water_records')
                                .doc(snapshot.data!.docs[index].id)
                                .delete();
                            FirebaseFirestore.instance
                                .collection('user')
                                .doc(homeController.user?.uid)
                                .collection('user-info')
                                .doc(snapshots.id)
                                .update({'drinkableWater': "0"});
                          }
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            color: ColorConstant.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('assets/glass.png',
                                    cacheHeight: 34,
                                    cacheWidth: 21,
                                    fit: BoxFit.fill),
                                const SizedBox(width: 10),
                                Text(
                                    snapshot.data!.docs[index].get('time') !=
                                            null
                                        ? DateFormat('HH:mm a').format(
                                            DateTime.fromMicrosecondsSinceEpoch(
                                                snapshot.data!.docs[index]
                                                    .get('time')
                                                    .microsecondsSinceEpoch))
                                        : '',
                                    style: TextStyleConstant.black24
                                        .copyWith(fontSize: 18)),
                                const Spacer(),
                                Text(
                                    snapshot.data!.docs[index]['waterMl'] ?? "",
                                    style: TextStyleConstant.grey14.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(width: 10),
                                CustomPopupMenu(
                                  showArrow: false,
                                  horizontalMargin: 40,
                                  barrierColor: Colors.transparent,
                                  onTap: ({String? item}) {
                                    if (item == 'Delete') {
                                      if (snapshots['drinkableWater']
                                              .toString() !=
                                          '0') {
                                        FirebaseFirestore.instance
                                            .collection('user')
                                            .doc(homeController.user?.uid)
                                            .collection('user-info')
                                            .doc(snapshots.id)
                                            .update({
                                          'drinkableWater': (int.parse(
                                                      snapshots[
                                                              'drinkableWater']
                                                          .toString()) -
                                                  200)
                                              .toString(),
                                          // 'time_records': FieldValue
                                          //     .arrayRemove(snapshot
                                          //         .timeRecords!
                                          //         .where((element) =>
                                          //             snapshot
                                          //                 .timeRecords![
                                          //                     index]
                                          //                 .timeId ==
                                          //             element.timeId)
                                          //         .map<
                                          //                 Map<String,
                                          //                     dynamic>>(
                                          //             (water) =>
                                          //                 WaterRecords
                                          //                     .toJson(
                                          //                         water))
                                          //         .toList())
                                        });

                                        FirebaseFirestore.instance
                                            .collection('user')
                                            .doc(homeController.user?.uid)
                                            .collection('water_records')
                                            .doc(snapshot.data!.docs[index].id)
                                            .delete();
                                        showBottomLongToast(
                                            "Water record deleted");
                                      }
                                    } else {
                                      editDialog(context,
                                          userId: homeController.user?.uid,
                                          waterId:
                                              snapshot.data!.docs[index].id,
                                          time: DateFormat('HH:mm a').format(
                                              DateTime.fromMicrosecondsSinceEpoch(
                                                  snapshot.data!.docs[index]
                                                      .get('time')
                                                      .microsecondsSinceEpoch)));
                                    }
                                  },
                                  pressType: PressType.singleClick,
                                  position:
                                      snapshot.data!.docs.length - 1 == index
                                          ? PreferredPosition.top
                                          : PreferredPosition.bottom,
                                  //  controller: waterRecords.popUpController,
                                  child: Icon(Icons.more_vert_outlined,
                                      color: ColorConstant.grey80),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return Container();
                  })
            ],
          ),
        ));
  }

  _noData(context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      color: ColorConstant.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/smiley.png', cacheHeight: 64, cacheWidth: 64),
          const SizedBox(height: 16),
          SizedBox(
            width: 189,
            child: Text("You don’t have any drink record",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyleConstant.grey16.copyWith(fontSize: 20)),
          ),
        ],
      ),
    );
  }

  User? user;

  double idealIntake = 0;
  double intakePercentage = 0;
  int length = 0;

  RxBool enter = false.obs;
  WaterRecords waterRecords = WaterRecords();

   addWater(
      {DocumentSnapshot<Map<String, dynamic>>? snapshot, String? id})  {

     bool? adsOpen = CommonHelper.interstitialAds();

    if (adsOpen == null || adsOpen) {

    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    //  print("ads open %%% ${adsOpen}");

      Yodo1MAS.instance.showInterstitialAd();
    addWaterCode(snapshot: snapshot, id: id);
   }
  //else{
   // addWaterCode(snapshot: snapshot, id: id);
  //}
    print("&&&&&");
   // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    print("&&&&&");

   }

  void addWaterCode(
      {DocumentSnapshot<Map<String, dynamic>>? snapshot, String? id}) {
    if ((int.parse(snapshot!['drinkableWater'].toString()) !=
            int.parse(
                snapshot['water_goal'].toString().split('ml').first.trim())) &&
        (int.parse(snapshot['drinkableWater'].toString()) <=
            int.parse(
                snapshot['water_goal'].toString().split('ml').first.trim()))) {
      Uuid uuid = const Uuid();
      if (enter.value == false) {
        enter.value = true;
        waterRecords.time = Timestamp.now();
        waterRecords.timeId =
            uuid.v1() + DateTime.now().millisecondsSinceEpoch.toString();
        waterRecords.waterMl = '200ml';

        FirebaseFirestore.instance
            .collection('user')
            .doc(homeController.user?.uid)
            .collection('water_records')
            .doc()
            .set(WaterRecords.toJson(waterRecords));
        FirebaseFirestore.instance
            .collection('user')
            .doc(homeController.user?.uid)
            .collection('user-info')
            .doc(id)
            .update({
          /* snapshot['time_records']!
               .map<Map<String, dynamic>>((water) => WaterRecords.toJson(water))
               .toList()*/
          'drinkableWater':
              (int.parse(snapshot['drinkableWater'].toString()) + 200)
                  .toString(),
        });

        enter.value = false;
        showBottomLongToast("Addition Successful");
      }
    } else {
      showBottomLongToast('You have completed your goal');
    }
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);


  }
}
// String readTimestamp(int timestamp) {
//   var now = new DateTime.now();
//   var format = new DateFormat('HH:mm a');
//   var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
//   var diff = date.difference(now);
//   var time = '';
//
//   if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
//     time = format.format(date);
//   } else {
//     if (diff.inDays == 1) {
//       time = diff.inDays.toString() + 'DAY AGO';
//     } else {
//       time = diff.inDays.toString() + 'DAYS AGO';
//     }
//   }
//
//   return time;
// }
