import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:waterreminder/constant/color_constant.dart';
import 'package:waterreminder/constant/text_style_constant.dart';
import 'package:waterreminder/no_internet/check_network.dart';
import 'package:waterreminder/widgets/custom_drop_down_popup.dart';
import 'package:waterreminder/widgets/custom_pop_up.dart';
import 'package:waterreminder/widgets/system_overlay_style.dart';
import 'dart:math' as math;
import '../controllers/report_controller.dart';

class ChartData {
  ChartData({this.y, this.xData});

  final double? y;
  final String? xData;
}

class ReportView extends GetView<ReportController> {
  ReportView({Key? key}) : super(key: key);

  final reportController = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: GetBuilder(
          init: reportController,
          builder: (reportController) {
            if (reportController.user != null) {
              return CheckNetwork(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('user')
                        .doc(reportController.user?.uid)
                        .collection('user-info')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 1.5.h),
                              _progressRow(),
                              SizedBox(height: 2.h),
                              _progressBar(
                                  snapshot: snapshot.data?.docs.first,
                                  context: context),
                              SizedBox(height: 2.h),
                              _chartRow(),
                              SizedBox(height: 2.h),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 24, bottom: 24, right: 20, left: 10),
                                child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('user')
                                        .doc(reportController.user!.uid)
                                        .collection('water_records')
                                        .orderBy('time')
                                        .snapshots(),
                                    builder: (context, snapshotData) {
                                      if (snapshotData.hasData) {
                                        if (reportController.chartValue ==
                                            'Last Week') {
                                          reportController.chartData.clear();

                                          if (differenceInDays(snapshotData) !=
                                              null) {
                                            differenceInDays(snapshotData)
                                                .forEach((element) {
                                              reportController.chartData.add(ChartData(
                                                  xData: DateFormat('EE')
                                                      .format(DateTime
                                                          .fromMicrosecondsSinceEpoch(
                                                              element
                                                                  .get('time')
                                                                  .microsecondsSinceEpoch)),
                                                  y: double.parse(
                                                      element['waterMl']
                                                          .split('ml')
                                                          .first)));
                                            });
                                          }
                                        } else if (reportController
                                                .chartValue ==
                                            'Last Month') {
                                          reportController.chartData.clear();
                                          if (differenceInMonth(snapshotData) !=
                                              null) {
                                            differenceInMonth(snapshotData)
                                                .forEach((element) {
                                              reportController.chartData.add(ChartData(
                                                  xData: DateFormat('MMMM')
                                                      .format(DateTime
                                                          .fromMicrosecondsSinceEpoch(
                                                              element
                                                                  .get('time')
                                                                  .microsecondsSinceEpoch)),
                                                  y: double.parse(
                                                      element['waterMl']
                                                          .split('ml')
                                                          .first)));
                                            });
                                          }
                                        } else if (reportController
                                                .chartValue ==
                                            'Last Year') {
                                          reportController.chartData.clear();
                                          if (differenceInYear(snapshotData) !=
                                              null) {
                                            differenceInYear(snapshotData)
                                                .forEach((element) {
                                              reportController.chartData.add(ChartData(
                                                  xData: DateFormat('yyyy')
                                                      .format(DateTime
                                                          .fromMicrosecondsSinceEpoch(
                                                              element
                                                                  .get('time')
                                                                  .microsecondsSinceEpoch)),
                                                  y: double.parse(
                                                      element['waterMl']
                                                          .split('ml')
                                                          .first)));
                                            });
                                          }
                                        }

                                        return reportController
                                                .chartData.isNotEmpty
                                            ? SfCartesianChart(
                                                primaryXAxis:
                                                    CategoryAxis(
                                                  // isVisible: false,
                                                  majorTickLines:
                                                      const MajorTickLines(
                                                          width: 0),
                                                  majorGridLines:
                                                      const MajorGridLines(
                                                          width: 0),
                                                ),
                                                title: ChartTitle(
                                                    text: 'ml',
                                                    alignment:
                                                        ChartAlignment
                                                            .near,
                                                    textStyle: TextStyleConstant
                                                        .blue20
                                                        .copyWith(
                                                            fontSize:
                                                                10.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal)),
                                                series: <
                                                    CartesianSeries>[
                                              ColumnSeries<ChartData, String>(
                                                  dataSource:
                                                      reportController
                                                          .chartData,
                                                  color:
                                                      ColorConstant
                                                          .blueFe,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: Radius
                                                              .circular(
                                                                  15),
                                                          topRight:
                                                              Radius.circular(
                                                                  15)),
                                                  xValueMapper:
                                                      (ChartData data,
                                                              _) =>
                                                          data.xData,
                                                  yValueMapper: (ChartData
                                                              data,
                                                          _) =>
                                                      data.y /* maxBy(snapshotData.data!.docs.map((e) => double.parse(e['totalWaterMl'].split(' ').first)), (e) =>  e)*/,
                                                  width: 0.25,
                                                  spacing: 0.4),
                                            ])
                                            : Center(
                                                child: Text(
                                                    "No ${reportController.chartValue.value.toLowerCase()} record found",
                                                style: TextStyleConstant.black13),
                                              );
                                      }
                                      return Container();
                                    }),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  appBar(context) {
    return AppBar(
        title: Container(
            color: ColorConstant.white,
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Text('Report',
                textAlign: TextAlign.center,
                style: TextStyleConstant.titleStyle)),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        systemOverlayStyle: systemOverlayStyle(),
        backgroundColor: ColorConstant.white);
  }

  int drinkableWater = 0;
  double lastWeekPer = 0;
  double lastMonthPer = 0;

  _progressBar(
      {required BuildContext context,
      DocumentSnapshot<Map<String, dynamic>>? snapshot}) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(reportController.user!.uid)
            .collection('water_records')
            .orderBy('time')
            .snapshots(),
        builder: (context, snapshotData) {
          if (snapshotData.hasData) {
            ///Today's progress
            if (reportController.progressValue == "Today's" &&

                     differenceInToday(snapshotData)!=null) {
              drinkableWater = (differenceInToday(snapshotData)
                  .length);
            }

            ///Last week Progress
            else if (reportController.progressValue == "Last Week" &&
                differenceInDays(snapshotData)!=null) {
              lastWeekData(snapshotData);
            }

            ///Last Month Progress
            else if (reportController.progressValue == "Last Month" &&
                differenceInMonth(snapshotData) != null) {
              lastMonthData(snapshotData);
            } else {
              drinkableWater = 0;
            }
            return CircularPercentIndicator(
                radius: 16.5.h,
                // animation: true,
                animationDuration: 1200,
                lineWidth: 28,
                startAngle: 20,
                percent: reportController.progressValue == "Last Week"
                    ? (lastWeekPer <= 1 ? lastWeekPer : 1)
                    : reportController.progressValue == "Last Month"
                        ? (lastMonthPer <= 1 ? lastMonthPer : 1)
                        : ((int.parse((drinkableWater * 200).toString()) /
                                    int.parse(snapshot!['water_goal']
                                        .toString()
                                        .split('ml')
                                        .first
                                        .trim())) <=
                                1
                            ? int.parse((drinkableWater * 200).toString()) /
                                int.parse(snapshot['water_goal']
                                    .toString()
                                    .split('ml')
                                    .first
                                    .trim())
                            : 1),
                center: Align(
                  alignment: Alignment.center,
                  child: Text(
                    reportController.progressValue == "Last Week"
                        ? "${(lastWeekPer * 100).floor()}%"
                        : reportController.progressValue == "Last Month"
                            ? "${(lastMonthPer * 100).floor()}%"
                            : "${((drinkableWater * 200) / int.parse(snapshot!['water_goal'].toString().split('ml').first.trim()) * 100).floor()}%",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyleConstant.blue50.copyWith(fontSize: 38.sp),
                  ),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: ColorConstant.bluF7,
                progressColor: ColorConstant.blueFE);
          }
          return Container();
        });
  }

  _progressRow() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Water Consumed",
              style: TextStyleConstant.blue50.copyWith(fontSize: 14.sp)),
          Obx(() => CustomDropDownPopup(
              menuItem: reportController.progressReport,
              barrierColor: Colors.transparent,
              child: Row(
                children: [
                  Text(reportController.progressValue.value,
                      style: TextStyleConstant.black22.copyWith(
                          fontWeight: FontWeight.w600, fontSize: 13.sp)),
                  Icon(Icons.keyboard_arrow_down_outlined),
                ],
              ),
              onTap: ({item}) {
                reportController.progressValue.value = item!;
                reportController.update();
              },
              showArrow: false,
              pressType: PressType.singleClick)),
        ]);
  }

  _chartRow() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Water Consumed",
              style: TextStyleConstant.blue50.copyWith(fontSize: 14.sp)),
          Obx(() => CustomDropDownPopup(
              menuItem: reportController.chartReport,
              barrierColor: Colors.transparent,
              child: Row(
                children: [
                  Text(reportController.chartValue.value,
                      style: TextStyleConstant.black22.copyWith(
                          fontWeight: FontWeight.w600, fontSize: 13.sp)),
                  Icon(Icons.keyboard_arrow_down_outlined),
                ],
              ),
              onTap: ({item}) {
                reportController.chartValue.value = item!;
                reportController.update();
              },
              showArrow: false,
              position:PreferredPosition.bottom ,
              pressType: PressType.singleClick)),
        ]);
  }

  lastWeekData(snapshotData) {
    final values = <String, double>{};
    for (int i = 0; i < differenceInDays(snapshotData).toList().length; i++) {
      final item = differenceInDays(snapshotData).toList()[i];
      final itemName = DateFormat('yyyy-MM-dd')
          .parse((DateTime.fromMicrosecondsSinceEpoch(
                  item.get('time').microsecondsSinceEpoch)
              .toString()))
          .toString();
      String qty = double.parse(item['percentage']).toStringAsExponential(1);
      double previousValue = 0;
      if (values.containsKey(itemName)) {
        previousValue = values[itemName]!;
      }
      previousValue = previousValue + double.parse(qty);
      values[itemName] = previousValue;
    }

    Iterable<double> result = values.values;

    double sum = result.sum;
    lastWeekPer = ((sum / 7));
  }

  void lastMonthData(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshotData) {
    final values = <String, double>{};

    for (int i = 0; i < differenceInMonth(snapshotData).length; i++) {
      final item = differenceInMonth(snapshotData)[i];
      final itemName = DateFormat('yyyy-MM-dd')
          .parse((DateTime.fromMicrosecondsSinceEpoch(
                  item.get('time').microsecondsSinceEpoch)
              .toString()))
          .toString();
      String qty = double.parse(item['percentage']).toStringAsExponential(1);
      double previousValue = 0;
      if (values.containsKey(itemName)) {
        previousValue = values[itemName]!;
      }
      previousValue = previousValue + double.parse(qty);
      values[itemName] = previousValue;
    }

    Iterable<double> result = values.values;
    print(result);
    double sum = result.sum;

    lastMonthPer = sum / 12;
  }

  differenceInToday(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshotData) {
    if(snapshotData.data!.docs
        .where((element) =>
    element.get('time') != null &&
        DateFormat('dd/MM/yyyy').format(DateTime.now()) ==
            DateFormat('dd/MM/yyyy').format(
                DateTime.fromMicrosecondsSinceEpoch(element
                    .get('time')
                    .microsecondsSinceEpoch)))
        .toList().length!=0){

      return  snapshotData.data!.docs
          .where((element) =>
      element.get('time') != null &&
          DateFormat('dd/MM/yyyy').format(DateTime.now()) ==
              DateFormat('dd/MM/yyyy').format(
                  DateTime.fromMicrosecondsSinceEpoch(element
                      .get('time')
                      .microsecondsSinceEpoch)))
          .toList();
    }
    return null;
  }
}

differenceInDays(snapshotData) {
  if (snapshotData.data!.docs
          .where((element) =>
              DateFormat("yyyy-MM-dd")
                  .parse(DateTime(DateTime.now().year, DateTime.now().month,
                          DateTime.now().day)
                      .toString())
                  .difference(DateFormat('yyyy-MM-dd').parse(
                      (DateTime.fromMicrosecondsSinceEpoch(
                              element.get('time').microsecondsSinceEpoch)
                          .toString())))
                  .inDays <=
              7)
          .toList()
          .length !=
      0) {
    return snapshotData.data!.docs
        .where((element) =>
            DateFormat("yyyy-MM-dd")
                .parse(DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day)
                    .toString())
                .difference(DateFormat('yyyy-MM-dd').parse(
                    (DateTime.fromMicrosecondsSinceEpoch(
                            element.get('time').microsecondsSinceEpoch)
                        .toString())))
                .inDays <=
            7)
        .toList();
  }
  return null;
}

differenceInMonth(snapshotData) {
  if (snapshotData.data!.docs
          .where((element) =>
              DateFormat("yyyy-MM").parse(
                  DateTime(DateTime.now().year, DateTime.now().month - 1)
                      .toString()) ==
              (DateFormat('yyyy-MM').parse((DateTime.fromMicrosecondsSinceEpoch(
                      element.get('time').microsecondsSinceEpoch)
                  .toString()))))
          .toList()
          .length !=
      0) {
    return snapshotData.data!.docs
        .where((element) =>
            DateFormat("yyyy-MM").parse(
                DateTime(DateTime.now().year, DateTime.now().month - 1)
                    .toString()) ==
            (DateFormat('yyyy-MM').parse((DateTime.fromMicrosecondsSinceEpoch(
                    element.get('time').microsecondsSinceEpoch)
                .toString()))))
        .toList();
  }
  return null;
}

differenceInYear(snapshotData) {
  if (snapshotData.data!.docs
          .where((element) =>
              DateFormat("yyyy").parse(
                  DateTime((DateTime.now().year - 1), DateTime.now().month)
                      .toString()) ==
              (DateFormat('yyyy').parse((DateTime.fromMicrosecondsSinceEpoch(
                      element.get('time').microsecondsSinceEpoch)
                  .toString()))))
          .toList()
          .length !=
      0) {
    return snapshotData.data!.docs
        .where((element) =>
            DateFormat("yyyy").parse(
                DateTime((DateTime.now().year - 1), DateTime.now().month)
                    .toString()) ==
            (DateFormat('yyyy').parse((DateTime.fromMicrosecondsSinceEpoch(
                    element.get('time').microsecondsSinceEpoch)
                .toString()))))
        .toList();
  }
  return null;
}
