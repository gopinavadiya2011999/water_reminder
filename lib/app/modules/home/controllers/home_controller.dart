import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:waterreminder/main.dart';
import 'package:waterreminder/model/user_model.dart';


class HomeController extends GetxController {
  List<WaterRecords> waterRecords = [];

  User? user;

  @override
 onInit()  {
    super.onInit();

    user = auth.currentUser;
    update();
  }
}

class ItemModel {
  String? text;
  String? icon;
  RxBool isSelected = false.obs;

  ItemModel({this.text, this.icon, required this.isSelected});
}
