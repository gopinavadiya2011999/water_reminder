import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:waterreminder/app/modules/account/controllers/account_controller.dart';
import 'package:waterreminder/app/modules/account/views/account_view.dart';
import 'package:waterreminder/toast.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';
import 'package:waterreminder/widgets/water_view.dart';
import '../widgets/custom_button.dart';

void waterDialog(
    {required BuildContext context,
    required AccountController accountController}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            waterView(
              water:accountController.waterGoal,
              context: context,
              selectedMl: ({waterMl}) {
                accountController.waterGoal.value = waterMl.toString()+" "+'ml';
                accountController.update();
              },
            ),
            const SizedBox(height: 8),
            inkWell(
                onTap: () async {
                  FirebaseFirestore.instance
                      .collection('user')
                      .doc(accountController.userData.first.userId)
                      .update({
                    'water_goal': accountController.waterGoal.value
                  });
                  emitter.emit('add');
                  accountController.userData=await getPrefData();
                  Get.back();
                },
                child: customButton(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height / 11,
                        vertical: MediaQuery.of(context).size.width / 25),
                    plusButton: true,
                    buttonText: 'Save',
                    context: context))
          ],
        ),
      );
    },
  );
}
