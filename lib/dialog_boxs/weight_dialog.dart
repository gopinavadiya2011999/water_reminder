import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterreminder/app/modules/account/controllers/account_controller.dart';
import 'package:waterreminder/widgets/custom_button.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';
import 'package:waterreminder/widgets/weight_view.dart';
import 'package:yodo1mas/Yodo1MAS.dart';

import '../ads/ads_data.dart';

void weightDialog(context, AccountController accountController, String? id) {

  showDialog(
    context: context,
    builder: (context) {
      String weights = accountController.weight.value.split(' ').first;
      String weightTypes = (accountController.weight.value.split(' ').last!='kg'||accountController.weight.value.split(' ').last!= 'lbs')?
          'kg'
          :accountController.weight.value.split(' ').last;
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
                weights = weight.toString().length == 1
                    ? '0${weight}'
                    :weight.toString();
              },
              weightTypeFunc: ({weightType}) {
                weightTypes = weightType.toString();
              },
            ),
            const SizedBox(height: 8),
            inkWell(
                onTap: () {
                  bool? adsOpen = CommonHelper.interstitialAds();

                  if (adsOpen == null || adsOpen) {
                    Yodo1MAS.instance.showInterstitialAd();
                  }

                  accountController.weight.value = weights + " " + weightTypes;

                  accountController.update();
                  FirebaseFirestore.instance
                      .collection('user')
                      .doc(accountController.user?.uid)
                      .collection('user-info')
                      .doc(id)
                      .update({'weight': accountController.weight.value});

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
