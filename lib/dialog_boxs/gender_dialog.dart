import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterreminder/app/modules/account/controllers/account_controller.dart';
import 'package:waterreminder/app/modules/home/views/home_view.dart';
import 'package:waterreminder/constant/color_constant.dart';
import 'package:waterreminder/constant/text_style_constant.dart';
import 'package:waterreminder/model/gender_model.dart';
import 'package:waterreminder/toast.dart';
import 'package:waterreminder/widgets/custom_button.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';
import 'package:waterreminder/widgets/gender_view.dart';

void openGenderDialog(context, AccountController accountController) {
  showDialog(
    context: context,
    builder: (context) {
      return GetBuilder<AccountController>(
        init: accountController,
        builder: (controller) {
          return AlertDialog(
            shape: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8)),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                genderView(
                  accountController:accountController,
                  context: context,
                  onTap: ({int? index}) {
                    for (int i = 0; i < genderList.length; i++) {
                      genderList[i].selected.value = false;
                      accountController.update();
                    }
                    genderList[index!].selected.value = true;
                    accountController.gender.value=genderList[index].name!;
                    accountController.update();

                  },
                ),
                const SizedBox(height: 20),
                inkWell(
                    onTap: () {
                      genderList.forEach((element) async {
                        if (element.selected.value) {
                          accountController.gender.value = element.name!;
                          accountController.update();
                        }

                        FirebaseFirestore.instance.collection('user').doc(accountController.userData.first.userId).update({
                          'gender':accountController.gender.value
                        });
                          accountController.userData =await  getPrefData();
                        accountController.update();

                      });
                      emitter.emit('getUsers');
                      Get.back();
                    },
                    child: customButton(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.height / 11,
                            vertical: MediaQuery.of(context).size.width / 25),
                        plusButton: true,
                        buttonText: 'Save',
                        context: context)),
              ],
            ),
          );
        },
      );
    },
  );
}

customAvatar(
    {required BuildContext context,
    required String name,
    required String image,
    required bool button}) {
  return Column(
    children: [
      Text(name,
          style: TextStyleConstant.grey14.copyWith(
              fontFamily: 'Sora',
              color: button ? ColorConstant.blueFE : ColorConstant.greyAF)),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color:
                    button ? ColorConstant.blueFE : ColorConstant.transparent)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            image,
            cacheWidth: MediaQuery.of(context).size.width ~/ 3.5,
            cacheHeight: MediaQuery.of(context).size.height ~/ 7,
            fit: BoxFit.fill,
          ),
        ),
      ),
    ],
  );
}
