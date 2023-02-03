import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:waterreminder/constant/color_constant.dart';
import 'package:waterreminder/constant/text_style_constant.dart';
import 'package:waterreminder/no_internet/check_network.dart';
import 'package:waterreminder/widgets/custom_drop_down_popup.dart';
import 'package:waterreminder/widgets/custom_pop_up.dart';
import 'package:waterreminder/widgets/system_overlay_style.dart';
import 'dart:math' as math;
import '../controllers/report_controller.dart';

class ReportView extends GetView<ReportController> {
  ReportView({Key? key}) : super(key: key);

  final reportController = Get.put(ReportController());

  final shadowColor = const Color(0xFFCCCCCC);
  final dataList = [
    _BarData(ColorConstant.blueFF, 18, 18),
    _BarData(ColorConstant.greyAF, 17, 8),
    _BarData(ColorConstant.bluF7, 10, 15),
    _BarData(ColorConstant.black, 2.5, 5),
    _BarData(ColorConstant.blueFe, 2, 2.5),
    _BarData(ColorConstant.grey80, 2, 2),
  ];

  BarChartGroupData generateBarGroup(
    int x,
    Color color,
    double value,
    double shadowValue,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: color,
          width: 6,
        ),
        // BarChartRodData(
        //   toY: shadowValue,
        //   color: shadowColor,
        //   width: 6,
        // ),
      ],
      showingTooltipIndicators: touchedGroupIndex.value == x ? [0] : [],
    );
  }

  RxInt touchedGroupIndex = (-1).obs;

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
                                padding: const EdgeInsets.all(24),
                                child: AspectRatio(
                                  aspectRatio: 1.4,
                                  child: BarChart(
                                    BarChartData(
                                      alignment: BarChartAlignment.spaceBetween,
                                      borderData: FlBorderData(
                                        show: true,
                                        border: Border.symmetric(
                                          horizontal: BorderSide(
                                            color: ColorConstant.greyCD,
                                          ),
                                        ),
                                      ),
                                      titlesData: FlTitlesData(
                                        show: true,
                                        leftTitles: AxisTitles(
                                          drawBehindEverything: true,
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 30,
                                            getTitlesWidget: (value, meta) {
                                              return Text(
                                                value.toInt().toString(),
                                                textAlign: TextAlign.left,
                                              );
                                            },
                                          ),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 36,
                                            getTitlesWidget: (value, meta) {
                                              final index = value.toInt();
                                              return SideTitleWidget(
                                                axisSide: meta.axisSide,
                                                child: _IconWidget(
                                                  color: dataList[index].color,
                                                  isSelected:
                                                      touchedGroupIndex.value ==
                                                          index,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        rightTitles: AxisTitles(),
                                        topTitles: AxisTitles(),
                                      ),
                                      gridData: FlGridData(
                                        show: true,
                                        drawVerticalLine: false,
                                        getDrawingHorizontalLine: (value) =>
                                            FlLine(
                                          color: ColorConstant.greyCD,
                                          strokeWidth: 1,
                                        ),
                                      ),
                                      barGroups:
                                          dataList.asMap().entries.map((e) {
                                        final index = e.key;
                                        final data = e.value;
                                        return generateBarGroup(
                                          index,
                                          ColorConstant.blueFe,
                                          data.value,
                                          data.shadowValue,
                                        );
                                      }).toList(),
                                      maxY: 20,
                                      minY: 0,
                                      barTouchData: BarTouchData(
                                        enabled: true,
                                        handleBuiltInTouches: false,
                                        touchTooltipData: BarTouchTooltipData(
                                          tooltipBgColor: Colors.transparent,
                                          tooltipMargin: 0,
                                          getTooltipItem: (
                                            BarChartGroupData group,
                                            int groupIndex,
                                            BarChartRodData rod,
                                            int rodIndex,
                                          ) {
                                            return BarTooltipItem(
                                              rod.toY.toString(),
                                              TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: rod.color,
                                                fontSize: 18,
                                                shadows: const [
                                                  Shadow(
                                                    color: Colors.black26,
                                                    blurRadius: 12,
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        touchCallback: (event, response) {
                                          if (event
                                                  .isInterestedForInteractions &&
                                              response != null &&
                                              response.spot != null) {
                                            // setState(() {
                                            touchedGroupIndex.value = response
                                                .spot!.touchedBarGroupIndex;
                                            reportController.update();
                                            // });
                                          } else {
                                            // setState(() {
                                            touchedGroupIndex.value = -1;
                                            reportController.update();
                                            // });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
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
            if (snapshotData.data!.docs
                    .where((element) =>
                        element.get('time') != null &&
                        DateFormat('dd/MM/yyyy').format(DateTime.now()) ==
                            DateFormat('dd/MM/yyyy').format(
                                DateTime.fromMicrosecondsSinceEpoch(element
                                    .get('time')
                                    .microsecondsSinceEpoch)))
                    .toList()
                    .length !=
                0) {
              drinkableWater = (snapshotData.data!.docs
                  .where((element) =>
                      element.get('time') != null &&
                      DateFormat('dd/MM/yyyy').format(DateTime.now()) ==
                          DateFormat('dd/MM/yyyy').format(
                              DateTime.fromMicrosecondsSinceEpoch(
                                  element.get('time').microsecondsSinceEpoch)))
                  .toList()
                  .length);
            }
            // else if(snapshotData.data!.docs
            //     .where((element) =>
            // element.get('time') != null &&
            //     DateFormat('dd/MM/yyyy').format(DateTime.now()) ==
            //         DateFormat('dd/MM/yyyy').format(
            //             DateTime.fromMicrosecondsSinceEpoch(element
            //                 .get('time')
            //                 .microsecondsSinceEpoch)))
            //     .toList()
            //     .length !=
            //     0){
            //
            // }
            else {
              drinkableWater = 0;
            }
            return CircularPercentIndicator(
                radius: 16.5.h,
                // animation: true,
                animationDuration: 1200,
                lineWidth: 28,
                startAngle: 20,
                percent: (int.parse((drinkableWater * 200).toString()) /
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
                    : 1,
                center: Align(
                  alignment: Alignment.center,
                  child: Text(
                    " ${((drinkableWater * 200) / int.parse(snapshot['water_goal'].toString().split('ml').first.trim()) * 100).floor()}%",
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
              },
              showArrow: false,
              pressType: PressType.singleClick)),
        ]);
  }
}

class _BarData {
  const _BarData(this.color, this.value, this.shadowValue);

  final Color color;
  final double value;
  final double shadowValue;
}

class _IconWidget extends ImplicitlyAnimatedWidget {
  const _IconWidget({
    required this.color,
    required this.isSelected,
  }) : super(duration: const Duration(milliseconds: 300));
  final Color color;
  final bool isSelected;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _IconWidgetState();
}

class _IconWidgetState extends AnimatedWidgetBaseState<_IconWidget> {
  Tween<double>? _rotationTween;

  @override
  Widget build(BuildContext context) {
    final rotation = math.pi * 4 * _rotationTween!.evaluate(animation);
    final scale = 1 + _rotationTween!.evaluate(animation) * 0.5;
    return Transform(
      transform: Matrix4.rotationZ(rotation).scaled(scale, scale),
      origin: const Offset(14, 14),
      child: Column(
        children: [
          // Icon(
          //   widget.isSelected ? Icons.face_retouching_natural : Icons.face,
          //   color: widget.color,
          //   size: 28,
          // ),
          RotatedBox(
              quarterTurns: /*widget.isSelected ?0:*/ -1, child: Text("Mon"))
        ],
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _rotationTween = visitor(
      _rotationTween,
      widget.isSelected ? 1.0 : 0.0,
      (dynamic value) => Tween<double>(
        begin: value as double,
        end: widget.isSelected ? 1.0 : 0.0,
      ),
    ) as Tween<double>?;
  }
}
