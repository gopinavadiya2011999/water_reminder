import 'package:get/get.dart';
import 'package:waterreminder/app/modules/account/views/account_view.dart';
import 'package:waterreminder/model/user_model.dart';
import 'package:waterreminder/toast.dart';

class HomeController extends GetxController {
  RxList<ItemModel> menuItems = <ItemModel>[].obs;
  List<WaterRecords> waterRecords = [];
  RxList<UserModel> userData = <UserModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    userData = RxList(await getPrefData());
    update();
    emitter.on('add', this, (ev, context) async {
      switch (ev.eventName) {
        case "add":
          userData = RxList(await getPrefData());
          update();
          break;
      }
    });
    menuItems.value.clear();
    menuItems.value.addAll([
      ItemModel(
          isSelected: false.obs, text: "Delete", icon: 'assets/delete.png'),
      ItemModel(isSelected: true.obs, text: "Edit", icon: 'assets/edit.png'),
    ]);
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
