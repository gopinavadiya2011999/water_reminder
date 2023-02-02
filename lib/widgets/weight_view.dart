import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
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
              value: weight != null && weight.value!=" kg"
                  ? int.parse(weight.value.split(' ').first.toString())

                  : currentWeight.value,
              minValue: 1,
              zeroPad: true,
              itemHeight: 9.h,
              itemWidth: 33.w,
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
            itemSize: 9.h,
            listWidth: 10.h,
            selectTextStyle: TextStyleConstant.blue50.copyWith(fontSize: 31.5.sp),
            unSelectTextStyle: TextStyleConstant.blue50.copyWith(
                color: ColorConstant.greyAF.withOpacity(.75), fontSize: 31.5.sp),
            startPosition: weight != null
                ? ((weight.value.split(' ').last.toString() == 'kg') ? 0 : 1)
                : 0,
            onValueChanged: (s) => weightTypeFunc(weightType: s),
            datas: ['kg', 'lbs'],
          ),
        )
      ],
    ),
  );
}
