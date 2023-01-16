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
    required Function({String? dayNight}) dayNightTime}) {
  RxString wakeUpType =DateFormat('a').format(DateTime.now()).toString().obs;
  final RxInt currentHour = int.parse(/*DateTime.now().hour.toString()*/DateFormat.jm().format(DateTime.now()).split(":").first).obs;
  final RxInt currentMinute = int.parse(DateTime.now().minute.toString()).obs;


  return Container(
    height:25.h,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Obx(() => NumberPicker(
            value:currentHour.value,
            minValue:/*wakeUpType.value=='AM'? 01:12*/01,
            zeroPad: true,
            time: true,
            twoDot: true,
            itemHeight: 8.h,
            itemWidth:26.w,
            maxValue:/*wakeUpType.value=='AM'?*/ 12/*:23*/,
            onChanged: (value) {
              currentHour.value = value;
              hours(hour:currentHour.value);
            })),
        Obx(
          () => NumberPicker(
              value: currentMinute.value,
              minValue: 0,
              zeroPad: true,

              time: true,
              itemHeight: 8.h,
              itemWidth:19.w,
              maxValue: 60,
              onChanged: (value) {
                currentMinute.value = value;
                minutes(minute: currentMinute.value);
              }),
        ),
        const SizedBox(width: 5),
        Obx(() =>
          Expanded(
            child: WheelChooser(
              horizontal: false,
              itemSize:(8.5).h,

              selectTextStyle: TextStyleConstant.blue50.copyWith(fontSize: 35.sp),
              unSelectTextStyle: TextStyleConstant.blue50.copyWith( fontSize: 35.sp)
                  .copyWith(color: ColorConstant.greyAF.withOpacity(.75)),
              startPosition:  wakeUpType.value=='AM'? 0:1,
              onValueChanged: (s) {
                wakeUpType.value=s;
                // if(wakeUpType.value=='AM'){
                //   currentHour.value=01;
                // }
                // else{
                //   currentHour.value=12;
                // }
                dayNightTime(dayNight: s);
              },
              datas: [
               'AM',
                'PM'
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
