import 'package:get/get.dart';
import 'package:waterreminder/model/user_model.dart';
import 'package:waterreminder/toast.dart';

class HomeController extends GetxController {
  List<WaterRecords> waterRecords = [];
  RxList<UserModel> userData = <UserModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    userData = RxList(await getPrefData());
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
}

class ItemModel {
  String? text;
  String? icon;
  RxBool isSelected = false.obs;

  ItemModel({this.text, this.icon, required this.isSelected});
}
