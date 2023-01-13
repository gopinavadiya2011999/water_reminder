import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterreminder/app/modules/ChangePassword/views/change_password_view.dart';
import 'package:waterreminder/constant/color_constant.dart';
import 'package:waterreminder/constant/text_style_constant.dart';
import 'package:waterreminder/widgets/custom_back_button.dart';
import 'package:waterreminder/widgets/custom_inkwell.dart';

import '../../../../widgets/system_overlay_style.dart';
import '../controllers/account_detail_controller.dart';

class AccountDetailView extends GetView<AccountDetailController> {
  AccountDetailView({Key? key}) : super(key: key);

  final cartController = Get.put(AccountDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          systemOverlayStyle: systemOverlayStyle(),
          backgroundColor: ColorConstant.white,
          title: Container(
              color: ColorConstant.white,
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,

                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  inkWell(
                    onTap: (){Navigator.pop(context);},
                    child: customBackButton(),
                  ),
                  Expanded(
                      child: Text('Settings',
                          style: TextStyleConstant.titleStyle,
                          textAlign: TextAlign.center)),
                ],
              ))),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            customRow(
              backTap: (){},
                title: 'Notification',
                image: 'assets/notification.png',
                isSwitch: true),
            customRow(
                title: 'Change Password',
                image: 'assets/lock.png',
                backTap: () {
                  Navigator.of(context, rootNavigator: true)
                      .push(MaterialPageRoute(
                      builder: (context) =>
                       ChangePasswordView()));
                }),
            customRow(
                title: 'About Us', backTap: () {}, image: 'assets/person.png'),
            customRow(
                title: 'Privacy Policy',
                image: 'assets/person.png',
                backTap: () {}),
          ],
        ),
      ),
    );
  }

  customRow({
    required String image,
    required String title,
    required GestureTapCallback backTap,
    bool isSwitch = false,
  }) {
    return inkWell(
      onTap: backTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Image.asset(image, cacheWidth: 16, cacheHeight: 20),
              const SizedBox(width: 10),
              Text(title,
                  style: TextStyleConstant.white16.copyWith(
                      fontWeight: FontWeight.w500, color: ColorConstant.black24)),
            ]),
            isSwitch
                ? Obx(() => SizedBox(
                      width: 40,
                      height: 30,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Switch(
                          value: controller.notificationSwitch.value,
                          onChanged: (val) {
                            controller.notificationSwitch.value = val;
                          },
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          activeColor: ColorConstant.blueFE,
                        ),
                      ),
                    ))
                : Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.arrow_forward_ios_outlined,
                      size: 10, color: ColorConstant.black24),
                )
          ],
        ),
      ),
    );
  }
}
