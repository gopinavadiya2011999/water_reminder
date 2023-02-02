import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:waterreminder/constant/color_constant.dart';
import 'package:waterreminder/constant/text_style_constant.dart';
import 'package:waterreminder/widgets/custom_drop_down_popup.dart';
import 'package:waterreminder/widgets/custom_pop_up.dart';
import 'package:waterreminder/widgets/system_overlay_style.dart';

import '../controllers/report_controller.dart';

class ReportView extends GetView<ReportController> {
  ReportView({Key? key}) : super(key: key);

  final reportController = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: GetBuilder(
          init: reportController,
          builder: (reportController) {
            return Column(
              children: [
                SizedBox(height: 1.5.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Water Consumed",
                        style:
                            TextStyleConstant.blue50.copyWith(fontSize: 14.sp)),
                    Obx(
                      () => CustomDropDownPopup(
                          menuItem: reportController.progressReport,
                          barrierColor: Colors.transparent,
                          child: Row(
                            children: [

                              Text(reportController.progressValue.value,
                                  style: TextStyleConstant.black22.copyWith(
                                      fontWeight:
                                      FontWeight.w600,
                                      fontSize: 13.sp)),
                              Icon(Icons.keyboard_arrow_down_outlined),
                            ],
                          ),
                          onTap: ({item}) {
                            reportController.progressValue.value = item!;
                          },
                          showArrow: false,
                          pressType: PressType.singleClick),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  appBar(context) {
    return AppBar(
        title: Container(
            color: ColorConstant.white,
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Text('Report',
                textAlign: TextAlign.center,
                style: TextStyleConstant.titleStyle)),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        systemOverlayStyle: systemOverlayStyle(),
        backgroundColor: ColorConstant.white);
  }
}
