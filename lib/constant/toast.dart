import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showBottomLongToast(String value) {
  Fluttertoast.showToast(
      msg: value,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1);
}

Future<void> dismissKeyboard(BuildContext context) async =>
    FocusScope.of(context).unfocus();

String readTimestamp(int timestamp) {
  var now = DateTime.now();
  var format = DateFormat('hh:mm a');
  var date = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
  var diff = date.difference(now);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else {
    if (diff.inDays == 1) {
      time = '${diff.inDays}DAY AGO';
    } else {
      time = '${diff.inDays}DAYS AGO';
    }
  }

  return time;
}


// getUserData() async {
//  List<UserModel> userModel = [];
//   QuerySnapshot<Map<String, dynamic>> snapshot =
//       await FirebaseFirestore.instance.collection('user').get();
//   snapshot.docs.map((element) {
//     userModel.add(UserModel(
//       waterGoal: element['water_goal'],
//       gender: element['gender'],
//       weight: element['weight'],
//       wakeUpTime: element['wakeup_time'],
//       bedTime: element['bed_time'],
//       drinkableWater: element['drinkableWater'],
//       time: element['time'],
//       // timeRecords:element['time_records']!=null?List<WaterRecords>.from(element['time_records'].map((items) {
//       //   if (items != null) {
//       //     return WaterRecords(
//       //         waterMl: items['waterMl'],
//       //         time: items['time'],
//       //         timeId: items['timeId']);
//       //   }
//       //   return [];
//       // })):[],
//       userName: element['user_name'],
//       userId: element['user_id'],
//       email: element['email'],
//     ));
//   }).toList();
//   return userModel;
// }
