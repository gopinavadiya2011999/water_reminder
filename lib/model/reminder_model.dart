

import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel{
  String ? timeStamp ;
  bool? onOff;
  Timestamp? time;

  ReminderModel({this.timeStamp, this.onOff,this.time});

  Map<String,dynamic>toMap(){
    return {'time':time,'timeStamp':timeStamp,'onOff':onOff};
  }

  factory ReminderModel.fromMap(map){
    return ReminderModel(timeStamp: map['timeStamp'],onOff: map['onOff'],
    time: map['time']);
  }
}