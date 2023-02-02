import 'package:get/get.dart';

class ReportDialogModel {
  RxString? text;
  RxBool? selected = false.obs;

  ReportDialogModel({this.text, this.selected});
}

