import 'package:flutter/material.dart';
import 'package:waterreminder/constant/color_constant.dart';
import 'package:waterreminder/constant/text_style_constant.dart';

customButton(
    {required String buttonText,
    bool plusButton = false,
    bool inifinity = false,
    EdgeInsetsGeometry? padding,
    required BuildContext context}) {
  return inifinity?
      Container(
        padding:    EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width / 20),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: ColorConstant.blueFE),
child: buttonView(plusButton, buttonText),
      ):Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50), color: ColorConstant.blueFE),
    padding:padding ??
            EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height / 22,
                vertical: MediaQuery.of(context).size.width / 24),
    child:buttonView(plusButton,buttonText)
  );
}

buttonView(plusButton,buttonText) {
  return  Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      if (!plusButton) Icon(Icons.add, size: 16, color: ColorConstant.white),
      if (!plusButton) const SizedBox(width: 14),
      Text(buttonText, style: TextStyleConstant.white16)
    ],
  );
}
