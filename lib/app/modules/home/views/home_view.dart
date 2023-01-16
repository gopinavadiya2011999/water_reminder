import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:uuid/uuid.dart';
import 'package:waterreminder/model/time_records.dart';
import 'package:waterreminder/model/user_model.dart';
import 'package:waterreminder/toast.dart';
import 'package:waterreminder/widgets/custom_button.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';
import 'package:waterreminder/widgets/system_overlay_style.dart';
import '../../../../constant/color_constant.dart';
import '../../../../constant/text_style_constant.dart';
import '../../../../custom_pop_up.dart';
import '../../AccountDetail/views/account_detail_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: homeController,
      builder: (controller) => Scaffold(
        backgroundColor: ColorConstant.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Container(
              color: ColorConstant.white,
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/female.png',
                      cacheHeight: 40, cacheWidth: 40, fit: BoxFit.fill),
                  Text('Water Reminder', style: TextStyleConstant.titleStyle),
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
          systemOverlayStyle: systemOverlayStyle(),
          backgroundColor: ColorConstant.white,
        ),
        body: homeController.userData.isNotEmpty
            ? Obx(
                () => StreamBuilder<UserModel>(
                    initialData: homeController.userData.first,
                    stream: Stream.value(homeController.userData.first),
                    builder: (context, snapshot) {
                      return Container(
                        height: double.infinity,
                        width: double.infinity,
                        padding: const EdgeInsets.only(bottom: 20),
                        color: ColorConstant.whiteD9.withOpacity(.3),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              if (homeController.userData.isNotEmpty)
                                Column(
                                  children: [
                                    _progressBar(
                                        context: context,
                                        snapshot: snapshot.data),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                20),
                                    inkWell(
                                        child: customButton(
                                            buttonText: "Add Water",
                                            context: context),
                                        onTap: () {
                                          addWater(snapshot: snapshot.data);
                                        }),
                                  ],
                                ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 28),
                              _listView(context, snapshot: snapshot.data)
                            ],
                          ),
                        ),
                      );
                    }),
              )
            : Container(),
      ),
    );
  }

  double getPercentage(snapshot) {
    return int.parse(snapshot!.drinkableWater.toString()) /
        int.parse(snapshot.waterGoal.toString().split('ml').first.trim());
  }

  _progressBar({required BuildContext context, UserModel? snapshot}) {
    return CircularPercentIndicator(
        radius: MediaQuery.of(context).size.width / 2.8,
        animation: true,
        animationDuration: 1200,
        lineWidth: 28,
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
                          text: snapshot!.drinkableWater,
                          style: TextStyleConstant.black24.copyWith(
                              fontSize: 22, color: ColorConstant.blueFE)),
                      const TextSpan(text: '/'),
                      TextSpan(text: snapshot.waterGoal),
                    ])),
                Divider(
                    height: 2, thickness: 1.2, color: ColorConstant.whiteD9),
                const SizedBox(height: 5),
                Text(
                  "You have completed ${(int.parse(snapshot.drinkableWater.toString()) / int.parse(snapshot.waterGoal.toString().split('ml').first.trim()) * 100).floor()}% of your daily drink target",
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

  _listView(context, {UserModel? snapshot}) {
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
              if (snapshot!.timeRecords!.isEmpty)
                _noData(context)
              else
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.timeRecords!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
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
                              snapshot.timeRecords![index].time != null &&
                                      snapshot
                                          .timeRecords![index].time!.isNotEmpty
                                  ? readTimestamp(int.parse(snapshot
                                      .timeRecords![index].time!
                                      .toString()))
                                  : "",
                              style: TextStyleConstant.black24
                                  .copyWith(fontSize: 18)),
                          const Spacer(),
                          Text(snapshot.timeRecords![index].waterMl ?? "",
                              style: TextStyleConstant.grey14.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w400)),
                          const SizedBox(width: 10),
                        //  if(snapshot.timeRecords![index].popUpController!=null)
                          CustomPopupMenu(
                            showArrow: false,
                            horizontalMargin: 40,
                            barrierColor: Colors.transparent,
                            menuBuilder: () => Container(
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                    color: ColorConstant.grey80.withOpacity(.2),
                                    blurRadius: 5,
                                    spreadRadius: 3,
                                    offset: const Offset(0, 3))
                              ]),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: IntrinsicWidth(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: homeController.menuItems
                                        .map(
                                          (item) => GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () async {
                                              // snapshot.timeRecords![index]
                                              //     .popUpController
                                              //     .hideMenu();
                                              // homeController.update();
                                              homeController.menuItems
                                                  .forEach((element) {
                                                if (element.isSelected.value ==
                                                    true) {
                                                  element.isSelected.value =
                                                      false;
                                                }
                                              });

                                              item.isSelected.value =
                                                  !item.isSelected.value;

                                              if (item.text == 'Edit') {
                                                print("Edit click");

                                              }

                                              if (item.text == 'Delete') {
                                                if (snapshot.drinkableWater
                                                        .toString() !=
                                                    '0') {
                                                  FirebaseFirestore.instance
                                                      .collection('user')
                                                      .doc(homeController
                                                          .userData
                                                          .first
                                                          .userId)
                                                      .update({
                                                    'drinkableWater':
                                                        (int.parse(snapshot
                                                                    .drinkableWater
                                                                    .toString()) -
                                                                200)
                                                            .toString(),
                                                    'time_records': FieldValue
                                                        .arrayRemove(snapshot
                                                            .timeRecords!
                                                            .where((element) =>
                                                                snapshot
                                                                    .timeRecords![
                                                                        index]
                                                                    .timeId ==
                                                                element.timeId)
                                                            .map<
                                                                    Map<String,
                                                                        dynamic>>(
                                                                (water) =>
                                                                    WaterRecords
                                                                        .toJson(
                                                                            water))
                                                            .toList())
                                                  });

                                                  snapshot.timeRecords!
                                                      .removeWhere((element) =>
                                                          element.timeId ==
                                                          snapshot
                                                              .timeRecords![
                                                                  index]
                                                              .timeId);
                                                  homeController.update();
                                                  homeController.userData =
                                                      RxList(
                                                          await getPrefData());

                                                  homeController.update();
                                                }
                                              }
                                            },
                                            child: Obx(
                                              () => Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    18,
                                                color: item.isSelected.value
                                                    ? ColorConstant.blueFE
                                                    : ColorConstant.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Row(
                                                  children: <Widget>[
                                                    Image.asset(
                                                      item.icon!,
                                                      cacheHeight: 18,
                                                      cacheWidth: 16,
                                                      color: !item
                                                              .isSelected.value
                                                          ? ColorConstant.blueFE
                                                          : ColorConstant.white,
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 10),
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 10),
                                                        child: Text(
                                                          item.text!,
                                                          style: TextStyle(
                                                              color: !item
                                                                      .isSelected
                                                                      .value
                                                                  ? ColorConstant
                                                                      .blueFE
                                                                  : ColorConstant
                                                                      .white,
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'Sora',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                            pressType: PressType.singleClick,
                            position: snapshot.timeRecords!.length - 1 == index
                                ? PreferredPosition.top
                                : PreferredPosition.bottom,
                            controller:
                                snapshot.timeRecords![index].popUpController,
                            child: Icon(Icons.more_vert_outlined,
                                color: ColorConstant.grey80),
                          ),
                        ],
                      ),
                    );
                  },
                )
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

  RxBool enter = false.obs;

  Future<void> addWater({UserModel? snapshot}) async {
    if (int.parse(snapshot!.drinkableWater.toString()) !=
            int.parse(snapshot.waterGoal.toString().split('ml').first.trim()) &&
        int.parse(snapshot.drinkableWater.toString()) <=
            int.parse(snapshot.waterGoal.toString().split('ml').first.trim())) {
      Uuid uuid = const Uuid();
      if (enter.value == false) {
        enter.value = true;
        snapshot.timeRecords?.add(WaterRecords(
            waterMl: '200ml',
            timeId:
                uuid.v1() + DateTime.now().millisecondsSinceEpoch.toString(),
            time: DateTime.now().millisecondsSinceEpoch.toString()));
        FirebaseFirestore.instance
            .collection('user')
            .doc('${snapshot.userId}')
            .update({
          "time_records": snapshot.timeRecords!
              .map<Map<String, dynamic>>((water) => WaterRecords.toJson(water))
              .toList(),
          'drinkableWater':
              (int.parse(snapshot.drinkableWater.toString()) + 200).toString(),
        });

        homeController.userData = RxList(await getPrefData());
        homeController.update();
        enter.value = false;
      }
    } else {
      print("You can not drink more water");
    }
  }
}

enum MenuItemType { EDIT, DUPLICATE }

getMenuItemString(MenuItemType menuItemType) {
  switch (menuItemType) {
    case MenuItemType.EDIT:
      return "Edit";
    case MenuItemType.DUPLICATE:
      return "Duplicate";
  }
}
