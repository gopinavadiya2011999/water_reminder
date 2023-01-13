import 'package:flutter/material.dart';

import '../constant/color_constant.dart';

customDivider({Color ?color,required BuildContext context, EdgeInsetsGeometry? margin,double? width}) {
  return Container(
    margin: margin ?? EdgeInsets.zero,
    height: 1,
   // width: width??MediaQuery.of(context).size.width / 5,
    color:color?? ColorConstant.greyAF,
  );
}
