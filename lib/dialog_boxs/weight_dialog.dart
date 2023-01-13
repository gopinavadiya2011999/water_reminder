import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterreminder/app/modules/account/controllers/account_controller.dart';
import 'package:waterreminder/toast.dart';
import 'package:waterreminder/widgets/custom_button.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';
import 'package:waterreminder/widgets/weight_view.dart';

void weightDialog(context, AccountController accountController) {
  showDialog(
    context: context,
    builder: (context) {
      String weights = '';
      String weightTypes = 'kg';
      return AlertDialog(
        shape: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            weightView(
              weight: accountController.weight,
              context: context,
              weightFunc: ({int? weight}) {
                weights = weight.toString();
              },
              weightTypeFunc: ({weightType}) {
                weightTypes = weightType.toString();
              },
            ),
            const SizedBox(height: 8),
            inkWell(
                onTap: () async {
                  accountController.weight.value =
                      weights + " " + weightTypes;
                  accountController.update();
                  FirebaseFirestore.instance
                      .collection('user')
                      .doc(accountController.userData.first.userId)
                      .update({'weight': accountController.weight.value});
                  accountController.userData = await getPrefData();
                  accountController.update();
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
