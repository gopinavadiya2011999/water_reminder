import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterreminder/constant/color_constant.dart';
import 'package:waterreminder/constant/text_style_constant.dart';
import 'package:waterreminder/widgets/weight_picker.dart';
import 'package:waterreminder/widgets/weight_type_picker.dart';

waterView(
    {required BuildContext context,
    required Function({int? waterMl}) selectedMl,
    RxString? water}) {
  final RxInt currentValueWater = 2000.obs;
  return SizedBox(
    height: MediaQuery.of(context).size.height / 3,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(
          () => NumberPicker(
              value: water != null
                  ? int.parse(water.value.removeAllWhitespace
                      .split('ml')
                      .first
                      .toString())
                  : currentValueWater.value,
              minValue: 1,
              zeroPad: true,
              itemHeight: 70,
              itemWidth: MediaQuery.of(context).size.width / 2,
              maxValue: 9000,
              onChanged: (value) {
                currentValueWater.value = value;
                selectedMl(waterMl: currentValueWater.value);
              }),
        ),
        Flexible(
          child: WheelChooser(
            horizontal: false,
            itemSize: 70,
            listWidth: MediaQuery.of(context).size.width / 5,
            listHeight: MediaQuery.of(context).size.height / 1.5,
            selectTextStyle: TextStyleConstant.blue50.copyWith(fontSize: 38),
            unSelectTextStyle: TextStyleConstant.blue50
                .copyWith(color: ColorConstant.greyAF.withOpacity(.75)),
            startPosition: 0,
            onValueChanged: (s) => print(s),
            datas: const ['ml'],
          ),
        ),
      ],
    ),
  );
}
