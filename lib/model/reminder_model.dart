

import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel{
  bool? onOff;
  Timestamp? time;

  ReminderModel({ this.onOff,this.time});

  Map<String,dynamic>toMap(){
    return {'time':time,'onOff':onOff};
  }

  factory ReminderModel.fromMap(map){
    return ReminderModel(onOff: map['onOff'],
    time: map['time']);
  }
}