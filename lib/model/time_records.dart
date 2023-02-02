import 'package:waterreminder/widgets/custom_pop_up.dart';

class TimeRecords {

  String? time;
  String? ml;
  CustomPopupMenuController popUpController = CustomPopupMenuController();
  TimeRecords({this.time, this.ml});
}

// List<TimeRecords> timeList = [
//   TimeRecords(time: '10:11 AM',ml: "200ml"),
//   TimeRecords(time: '11:30 AM',ml: '200ml'),
//   TimeRecords(time: '12:45 AM',ml: '200ml')
// ];