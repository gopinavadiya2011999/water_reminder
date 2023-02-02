import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:waterreminder/app/modules/bottom_tab/views/bottom_tab_view.dart';
import 'package:waterreminder/constant/text_style_constant.dart';
import 'package:waterreminder/main.dart';
import 'package:waterreminder/model/gender_model.dart';
import 'package:waterreminder/model/on_boarding_model.dart';
import 'package:waterreminder/model/user_model.dart';
import 'package:waterreminder/no_internet/check_network.dart';
import 'package:waterreminder/constant/toast.dart';
import 'package:waterreminder/widgets/custom_back_button.dart';
import 'package:waterreminder/widgets/custom_image.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';
import 'package:waterreminder/widgets/gender_view.dart';
import 'package:waterreminder/widgets/system_overlay_style.dart';
import 'package:waterreminder/widgets/time_view.dart';
import 'package:waterreminder/widgets/water_view.dart';
import 'package:waterreminder/widgets/weight_view.dart';

import '../../../../constant/color_constant.dart';
import '../controllers/selection_controller.dart';

class SelectionView extends GetView<SelectionController> {
  SelectionView({Key? key}) : super(key: key);

  String weights = '03';
  String weightTypes = 'kg';
  String bedTimeHour = DateTime.now().hour.toString();

  String bedTimeMinute = DateTime.now().minute.toString();

  String bedTimeType = DateFormat('a').format(DateTime.now()).toString();

  String wakeUpHour = DateTime.now().hour.toString();
  String wakeUpMinute = DateTime.now().minute.toString();
  String wakeUpType = DateFormat('a').format(DateTime.now()).toString();
  String waterGoal = '2000 ml';
  String gender = 'Male';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectionController>(
        init: selectionController,
        builder: (controller) {
          return CheckNetwork(
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  if (selectionController.curr.value !=
                      onBoardingModel.length - 1) {
                    selectionController.pageController
                        .jumpToPage(selectionController.curr.value + 1);
                  } else {
                    try {
                      FirebaseFirestore.instance
                          .collection('user')
                          .doc(selectionController.user?.uid)
                          .collection('user-info')
                          .doc()
                          .set({
                        'drinkableWater': '0',
                        'time': DateTime.now().millisecondsSinceEpoch.toString(),
                        'weight': weights + " " + weightTypes,
                        'notification': true,
                        'bed_time':
                            bedTimeHour + ":" + bedTimeMinute + " " + bedTimeType,
                        'wakeup_time':
                            wakeUpHour + ":" + wakeUpMinute + " " + wakeUpType,
                        'gender': gender,
                        'water_goal': waterGoal,
                      }, SetOptions(merge: true));
                      box.write('login', true);
                      showBottomLongToast("Account Created Successfully");
                      Get.offAll(BottomTabView());
                    } catch (e) {
                      showBottomLongToast('Something Went Wrong');
                    }
                  }
                },
                child: const Icon(Icons.arrow_forward_ios, size: 18),
              ),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: containerList(context: context),
                elevation: 0,
                 systemOverlayStyle: systemOverlayStyle(),
                backgroundColor: ColorConstant.white,
              ),
              body: Stack(
                children: [
                  Positioned.fill(
                    child: ExpandablePageView.builder(
                      scrollDirection: Axis.horizontal,
                      reverse: false,
                      controller: selectionController.pageController,
                      onPageChanged: (int num) {
                        selectionController.curr.value = num;
                        selectionController.update();
                      },
                      itemCount: onBoardingModel.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: MediaQuery.of(context).size.height / 45),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width / 10),
                              child: Text(onBoardingModel[index].text!,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: TextStyleConstant.black22),
                            ),
                            SizedBox(
                                height: MediaQuery.of(context).size.height / 30),
                            Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(
                                    horizontal: index == 0
                                        ? MediaQuery.of(context).size.width / 16
                                        : 0),
                                child: index == 0
                                    ? genderView(
                                        context: context,
                                        onTap: ({int? index}) {
                                          for (int i = 0;
                                              i < genderList.length;
                                              i++) {
                                            genderList[i].selected.value = false;
                                            selectionController.update();
                                          }
                                          genderList[index!].selected.value =
                                              true;
                                          selectionController.update();
                                          genderList.forEach((element) {
                                            if (element.selected.value) {
                                              gender = element.name!;
                                            }
                                          });
                                        },
                                      )
                                    : index == 1
                                        ? weightView(
                                            context: context,
                                            weightFunc: ({int? weight}) {
                                              weights = weight.toString();
                                            },
                                            weightTypeFunc: ({weightType}) {
                                              weightTypes = weightType!;
                                            },
                                          )
                                        : index == 2
                                            ? timeView(
                                                time: DateTime(
                                                    DateTime.now().year,
                                                    DateTime.now().month,
                                                    DateTime.now().day,
                                                    int.parse(
                                                        bedTimeHour.toString()),
                                                    int.parse(bedTimeMinute
                                                        .toString())),
                                                context: context,
                                                dayNightTime: ({dayNight}) {
                                                  if (dayNight == 'AM') {
                                                    bedTimeHour = '01';
                                                  } else {
                                                    bedTimeHour = '12';
                                                  }
                                                  bedTimeType = dayNight!;
                                                },
                                                hours: ({hour}) {
                                                  bedTimeHour =
                                                      hour.toString().length == 1
                                                          ? '0${hour}'
                                                          : hour.toString();
                                                },
                                                minutes: ({minute}) {
                                                  bedTimeMinute =
                                                      minute.toString().length ==
                                                              1
                                                          ? '0${minute}'
                                                          : minute.toString();
                                                },
                                              )
                                            : index == 3
                                                ? timeView(
                                                    time: DateTime(
                                                        DateTime.now().year,
                                                        DateTime.now().month,
                                                        DateTime.now().day,
                                                        int.parse(wakeUpHour
                                                            .toString()),
                                                        int.parse(wakeUpMinute
                                                            .toString())),
                                                    context: context,
                                                    dayNightTime: ({dayNight}) {
                                                      if (dayNight == 'AM') {
                                                        wakeUpHour = '01';
                                                      } else {
                                                        wakeUpHour = '12';
                                                      }
                                                      wakeUpType = dayNight!;
                                                    },
                                                    hours: ({hour}) {
                                                      wakeUpHour = hour
                                                                  .toString()
                                                                  .length ==
                                                              1
                                                          ? '0${hour}'
                                                          : hour.toString();
                                                    },
                                                    minutes: ({minute}) {
                                                      wakeUpMinute = minute
                                                                  .toString()
                                                                  .length ==
                                                              1
                                                          ? '0${minute}'
                                                          : minute.toString();
                                                    },
                                                  )
                                                : index == 4
                                                    ? waterView(
                                                        water:
                                                            RxString(waterGoal),
                                                        context: context,
                                                        selectedMl: ({waterMl}) {
                                                          waterGoal =
                                                              waterMl.toString() +
                                                                  " " +
                                                                  'ml';
                                                        },
                                                      )
                                                    : Container())
                          ],
                        );
                      },
                    ),
                  ),
                  customImage(context),
                ],
              ),
            ),
          );
        });
  }

  final selectionController = Get.put(SelectionController());

  containerList({required BuildContext context}) {
    return Row(
      children: [
        if (selectionController.curr.value != 0)
          inkWell(
            onTap: () {
              if (selectionController.curr.value != onBoardingModel.length) {
                selectionController.pageController
                    .jumpToPage(selectionController.curr.value - 1);
              }
            },
            child: customBackButton(),
          ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            height: 4,
            width: double.infinity,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: onBoardingModel.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    selectionController.curr.value = index - 1;
                    if (selectionController.curr.value !=
                        onBoardingModel.length - 1) {
                      selectionController.pageController
                          .jumpToPage(selectionController.curr.value + 1);
                    } else {
                      selectionController.pageController.jumpToPage(0);
                    }
                  },
                  child: Container(
                      width: 20,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectionController.curr.value == index
                              ? ColorConstant.transparent
                              : ColorConstant.greyAF,
                        ),
                        color: selectionController.curr.value == index
                            ? ColorConstant.blueFE
                            : ColorConstant.greyAF,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 5)),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
