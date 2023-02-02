import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:waterreminder/constant/color_constant.dart';
import 'package:waterreminder/constant/text_style_constant.dart';
import 'package:waterreminder/widgets/weight_picker.dart';
import 'package:waterreminder/widgets/weight_type_picker.dart';

timeView(
    {required BuildContext context,
    required Function({int? hour}) hours,
    required Function({int? minute}) minutes,
    required Function({String? dayNight}) dayNightTime,
    DateTime? time}) {


  RxString wakeUpType = time != null
      ? DateFormat('a').format(time).toString().obs
      : DateFormat('a').format(DateTime.now()).toString().obs;
  final RxInt currentHour = time != null
      ? int.parse(DateFormat('HH').format(time).toString() == "00"
              ? '11'
              : DateFormat('HH').format(time).toString())
          .obs
      : int.parse(DateTime.now().hour.toString()).obs;
  final RxInt currentMinute = time != null
      ? int.parse(DateFormat('mm').format(time).toString() == "00"
              ? '60'
              : DateFormat('mm').format(time).toString())
          .obs
      : int.parse(DateTime.now().minute.toString()).obs;

  return Container(
    height: 25.h,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Obx(() => NumberPicker(
            value: currentHour.value,
            minValue: wakeUpType.value == 'AM' ? 01 : 12,
            zeroPad: true,
            time: true,
            twoDot: true,
            itemHeight: 8.h,
            itemWidth: 25.w,
            maxValue: wakeUpType.value == 'AM' ? 11 : 23,
            onChanged: (value) {
              currentHour.value = value;
              hours(hour: currentHour.value);
            })),
        Obx(
          () => Flexible(
            child: NumberPicker(
                value: currentMinute.value,
                minValue: 1,
                zeroPad: true,
                time: true,
                itemHeight: 8.h,
                itemWidth: 19.w,
                maxValue: 60,
                onChanged: (value) {
                  currentMinute.value = value;
                  minutes(minute: currentMinute.value);
                }),
          ),
        ),
        const SizedBox(width: 5),
        Obx(
          () => Flexible(
            child: WheelChooser(
              listWidth: 10.h,
              horizontal: false,
              itemSize: (8.5).h,
              selectTextStyle:
                  TextStyleConstant.blue50.copyWith(fontSize: 30.sp),
              unSelectTextStyle: TextStyleConstant.blue50
                  .copyWith(fontSize: 30.sp)
                  .copyWith(color: ColorConstant.greyAF.withOpacity(.75)),
              startPosition: wakeUpType.value == 'AM' ? 0 : 1,
              onValueChanged: (s) {
                wakeUpType.value = s;
                if (wakeUpType.value == 'AM') {
                  currentHour.value = 01;
                } else {
                  currentHour.value = 12;
                }
                dayNightTime(dayNight: s);
              },
              datas: ['AM', 'PM'],
            ),
          ),
        ),
      ],
    ),
  );
}
