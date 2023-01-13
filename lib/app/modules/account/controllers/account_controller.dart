
import 'package:get/get.dart';
import 'package:waterreminder/model/user_model.dart';
import 'package:waterreminder/toast.dart';


class AccountController extends GetxController {
List<UserModel> userData = [];
RxString gender =''.obs;
RxString weight =''.obs;
RxString waterGoal =''.obs;
RxString sleepTime =''.obs;
RxString wakeUpTime =''.obs;

  @override
 Future<void> onInit()  async {

    userData = await getPrefData();
    gender.value= userData.first.gender!;
    weight.value= userData.first.weight!;
    waterGoal.value= userData.first.waterGoal!;
    sleepTime.value= userData.first.bedTime!;
    wakeUpTime.value= userData.first.wakeUpTime!;
    update();

    super.onInit();
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
