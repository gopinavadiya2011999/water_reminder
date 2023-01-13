import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
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
  final RxInt currentHour = int.parse(DateTime.now().hour.toString()).obs;
  final RxInt currentMinute = int.parse(DateTime.now().minute.toString()).obs;
print("&&&${wakeUpType.value}");
  return SizedBox(
    height: MediaQuery.of(context).size.height / 3,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Obx(() => NumberPicker(
            value: currentHour.value,
            minValue: 1,
            zeroPad: true,
            time: true,
            twoDot: true,
            itemHeight: 70,
            itemWidth: MediaQuery.of(context).size.width / 4.6,
            maxValue:wakeUpType.value=='AM'? 12:24,
            onChanged: (value) {
              currentHour.value = value;
              hours(hour: currentHour.value);
            })),
        Obx(
          () => NumberPicker(
              value: currentMinute.value,
              minValue: 0,
              zeroPad: true,

              time: true,
              itemHeight: 70,
              itemWidth: MediaQuery.of(context).size.width / 5.8,
              maxValue: 60,
              onChanged: (value) {
                currentMinute.value = value;
                minutes(minute: currentMinute.value);
              }),
        ),
        const SizedBox(width: 5),
        Obx(() =>
          WheelChooser(
            horizontal: false,
            itemSize: 70,
             listWidth: MediaQuery.of(context).size.width / 4,
            listHeight: MediaQuery.of(context).size.height / 5,
            selectTextStyle: TextStyleConstant.blue50.copyWith(fontSize: 40),
            unSelectTextStyle: TextStyleConstant.blue50.copyWith( fontSize: 40)
                .copyWith(color: ColorConstant.greyAF.withOpacity(.75)),
            startPosition:  wakeUpType.value=='AM'? 0:1,
            onValueChanged: (s) {
              wakeUpType.value=s;
              dayNightTime(dayNight: s);
            },
            datas: [
             'AM',
              'PM'
            ],
          ),
        ),
      ],
    ),
  );
}
