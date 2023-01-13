import 'package:flutter/material.dart';
import 'package:waterreminder/dialog_boxs/gender_dialog.dart';
import 'package:waterreminder/model/gender_model.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';

genderView({required BuildContext context,required Function({int? index}) onTap})
{
  return   Wrap(
    runSpacing: 24,
    spacing: MediaQuery.of(context).size.width / 15,
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: List.generate(genderList.length, (index) {
      return inkWell(
       onTap:()=> onTap(index: index),

        child: customAvatar(
            button: genderList[index].selected.value,
            context: context,
            name: genderList[index].name!,
            image: genderList[index].image!),
      );
    }),
  );

}