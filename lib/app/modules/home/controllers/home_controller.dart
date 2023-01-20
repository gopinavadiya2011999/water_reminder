import 'package:get/get.dart';
import 'package:waterreminder/app/modules/home/views/home_view.dart';
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
    emitter.on('getUsers', this, (ev, context) async {
      print("*****");
      switch(ev.eventName){

        case "getUsers":
      print("*****EVENT USER");
          userData= RxList(await getPrefData());
          update();
          break;
      }
    });


  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    emitter.removeListener('getUsers', (ev, context) async {
      switch(ev.eventName){
        case "getUsers":
          userData= RxList(await getPrefData());
    }
    });
  }
}

class ItemModel {
  String? text;
  String? icon;
  RxBool isSelected = false.obs;

  ItemModel({this.text, this.icon, required this.isSelected});
}
