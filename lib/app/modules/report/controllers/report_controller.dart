import 'package:get/get.dart';

import '../../../../model/report_dialog_list.dart';

class ReportController extends GetxController {
  List<ReportDialogModel> progressReport = [
    ReportDialogModel(text: "Today's".obs, selected: true.obs),
    ReportDialogModel(selected: false.obs, text: "Last Week".obs),
    ReportDialogModel(text: "Last Month".obs, selected: false.obs)
  ];
  List<RxString> chartReport = [  "Last Week".obs,"Last Month".obs,"Last Year".obs];
  RxString progressValue = "Today's".obs;
  RxString reportValue = "Last Week".obs;
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
