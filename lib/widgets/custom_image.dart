import 'package:flutter/material.dart';
import 'package:waterreminder/constant/color_constant.dart';

customImage(context){
  return   Positioned(
      bottom: 0,
      right: 0,
      height: MediaQuery.of(context).size.height / 2.9,
      left: 0,
      child: Image.asset(
        'assets/tringles.png',
        color: ColorConstant.grey80.withOpacity(.19),
        fit: BoxFit.fill,
      ));
}