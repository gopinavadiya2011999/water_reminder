import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterreminder/app/modules/account/controllers/account_controller.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';
import 'package:waterreminder/widgets/water_view.dart';
import 'package:yodo1mas/testmasfluttersdktwo.dart';
import '../ads/ads_data.dart';
import '../widgets/custom_button.dart';

void waterDialog(
    {required BuildContext context,
    required AccountController accountController, String? id}) {
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
              water: accountController.waterGoal,
              context: context,
              selectedMl: ({waterMl}) {

                accountController.waterGoal.value =
                    waterMl.toString() + " " + 'ml';
                accountController.update();
              },
            ),
            const SizedBox(height: 8),
            inkWell(
                onTap: ()  {
                  bool? adsOpen = CommonHelper.interstitialAds();

                  if (adsOpen == null || adsOpen) {
                    Yodo1MAS.instance.showInterstitialAd();
                  }
                  FirebaseFirestore.instance
                      .collection('user')
                      .doc(accountController.user?.uid)
                      .collection('user-info')
                      .doc(id)
                      .update(
                          {'water_goal': accountController.waterGoal.value});

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
