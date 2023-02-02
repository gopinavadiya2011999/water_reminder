import 'dart:convert';


import 'package:cloud_firestore/cloud_firestore.dart';

import '../custom_pop_up.dart';

class UserModel {
  String? email;
  String? userId;
  String? userName;
  String? time;
  String? gender;
  bool ?notification;
  String? weight;
  String? bedTime;
  String? wakeUpTime;
  String? waterGoal;
  String? drinkableWater;
  // List<WaterRecords>? timeRecords;


  UserModel({this.email,
    this.userId,
     this.notification,
    // this.timeRecords,
    this.drinkableWater,
    this.userName,
    this.time,
    this.gender,
    this.weight,
    this.bedTime,
    this.wakeUpTime,
    this.waterGoal});

  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
        email: jsonData['email'],
        userId: jsonData['userId'],
      notification: jsonData['notification'],
        userName: jsonData['userName'],
        time: jsonData['time'],
        gender: jsonData['gender'],
        weight: jsonData['weight'],
        bedTime: jsonData['bedTime'],
        wakeUpTime: jsonData['wakeUpTime'],
        waterGoal: jsonData['waterGoal'],
        drinkableWater: jsonData['drinkableWater'],
       /* timeRecords: jsonData['timeRecords'] == null
            ? null
            : List<WaterRecords>.from(
            jsonData['timeRecords'].map((e) => WaterRecords.fromJson(e)))*/);
  }

  static Map<String, dynamic> toMap(UserModel userModel) =>
      {
        'email': userModel.email,
        'userId': userModel.userId,
        'userName': userModel.userName,
        'time': userModel.time,
        'gender': userModel.gender,
        'weight': userModel.weight,
        'notification':userModel.notification,
        'bedTime': userModel.bedTime,
        'wakeUpTime': userModel.wakeUpTime,
        'waterGoal': userModel.waterGoal,
        'drinkableWater': userModel.drinkableWater,
       /* 'timeRecords': userModel.timeRecords == null
            ? null
            : List<dynamic>.from(
            userModel.timeRecords!.map((e) => WaterRecords.toJson(e)))*/
      };

  static String encode(List<UserModel> userModel) =>
      json.encode(
        userModel
            .map<Map<String, dynamic>>((user) => UserModel.toMap(user))
            .toList(),
      );

  static List<UserModel> decode(String users) =>
      (json.decode(users) as List<dynamic>)
          .map<UserModel>((item) => UserModel.fromJson(item))
          .toList();
}

class WaterRecords {
  Timestamp? time;
  String? timeId;
  String? waterMl;


  WaterRecords({this.time, this.timeId, this.waterMl});

  factory WaterRecords.fromJson(Map<String, dynamic> jsonData) =>
      WaterRecords(

          time: jsonData['time'] == null ? null : jsonData['time'],
          waterMl: jsonData['timeId'] == null ? null : jsonData['timeId'],
          timeId: jsonData['waterMl'] == null ? null : jsonData['waterMl']);

  static Map<String, dynamic> toJson(WaterRecords timeRecords) =>
      {

        'time': timeRecords.time == null ? null : timeRecords.time,
        'timeId': timeRecords.timeId == null ? null : timeRecords.timeId,
        'waterMl': timeRecords.waterMl == null ? null : timeRecords.waterMl,
      };

  static String encode(List<WaterRecords> waterRecords) =>
      json.encode(waterRecords
          .map<Map<String, dynamic>>((water) => WaterRecords.toJson(water))
          .toList());

  static List<WaterRecords> decode(String water) =>
      (json.decode(water) as List<dynamic>).map<WaterRecords>((e) =>
          WaterRecords.fromJson(e)).toList();
}


