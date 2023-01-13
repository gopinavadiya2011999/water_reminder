
import 'package:flutter/material.dart';
import 'package:waterreminder/constant/color_constant.dart';

customBackButton() {

  return Container(
    padding: const EdgeInsets.only(left: 5,right: 7,top: 6,bottom: 6),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ColorConstant.white,
        border:Border.all(color: ColorConstant.greyAF.withOpacity(.29))

    ),
    child: Icon(Icons.arrow_back_ios_new,

        size:18,color: ColorConstant.black24 ),
  );
}
