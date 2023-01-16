import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterreminder/constant/color_constant.dart';
import 'package:waterreminder/constant/text_style_constant.dart';
import 'package:waterreminder/widgets/weight_picker.dart';
import 'package:waterreminder/widgets/weight_type_picker.dart';

weightView(
    {required BuildContext context,
    required Function({int? weight}) weightFunc,
    RxString? weight,
    required Function({String? weightType}) weightTypeFunc}) {
  final RxInt currentWeight = 3.obs;
  return SizedBox(
    width: double.infinity,
    height: MediaQuery.of(context).size.height / 3,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(
          () => NumberPicker(
              value: weight != null
                  ? int.parse(weight.value.split(' ').first.toString())
                  : currentWeight.value,
              minValue: 1,
              zeroPad: true,
              itemHeight: 82,
              itemWidth: MediaQuery.of(context).size.width / 2.5,
              maxValue: 100,
              onChanged: (value) {
                currentWeight.value = value;
                if (weight != null) {
                  weight.value = value.toString();
                }
                weightFunc(weight: value);
              }),
        ),
        Flexible(
          child: WheelChooser(
            horizontal: false,
            itemSize: 82,
            listWidth: MediaQuery.of(context).size.width / 5,
            listHeight: MediaQuery.of(context).size.height / 1.5,
            selectTextStyle: TextStyleConstant.blue50,
            unSelectTextStyle: TextStyleConstant.blue50
                .copyWith(color: ColorConstant.greyAF.withOpacity(.75)),
            startPosition: weight != null
                ? ((weight.value.split(' ').last.toString() == 'kg') ? 0 : 1)
                : 0,
            onValueChanged: (s) => weightTypeFunc(weightType: s),
            datas: ['kg', 'lbs'],
          ),
        ),
      ],
    ),
  );
}