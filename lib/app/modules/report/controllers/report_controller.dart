
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:waterreminder/main.dart';

import '../../../../model/report_dialog_list.dart';
import '../views/report_view.dart';

class ReportController extends GetxController {
  User? user;
  List<ReportDialogModel> progressReport = [
    ReportDialogModel(text: "Today's".obs, selected: true.obs),
    ReportDialogModel(selected: false.obs, text: "Last Week".obs),
    ReportDialogModel(text: "Last Month".obs, selected: false.obs)
  ];
  List<ReportDialogModel> chartReport = [
    ReportDialogModel(selected: false.obs, text: "Last Week".obs),
    ReportDialogModel(text: "Last Month".obs, selected: false.obs),
    ReportDialogModel(text: "Last Year".obs, selected: true.obs)
  ];
  RxString progressValue = "Today's".obs;
  RxString chartValue = "Last Week".obs;
  final count = 0.obs;

  final List<ChartData> chartData = [];

  @override
  void onInit() {
    super.onInit();

    user = auth.currentUser;

    update();
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
