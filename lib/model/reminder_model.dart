

import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel{
  Timestamp ? timeStamp ;
  bool? onOff;

  ReminderModel({this.timeStamp, this.onOff});

  Map<String,dynamic>toMap(){
    return {'time':timeStamp,'onOff':onOff};
  }

  factory ReminderModel.fromMap(map){
    return ReminderModel(timeStamp: map['time'],onOff: map['onOff']);
  }
}