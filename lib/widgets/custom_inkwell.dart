import 'package:flutter/material.dart';
import 'package:waterreminder/constant/color_constant.dart';

inkWell({required Widget child,required GestureTapCallback onTap}){
  return InkWell(
    splashColor: ColorConstant.transparent,
    highlightColor: ColorConstant.transparent,
    focusColor: ColorConstant.transparent,
     overlayColor: MaterialStateProperty.all(ColorConstant.transparent),
    onTap: onTap,
    child: child,
  );
}