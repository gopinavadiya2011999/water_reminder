
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../../main.dart';


class AccountController extends GetxController {
RxString gender =''.obs;
RxString weight =''.obs;
RxString waterGoal =''.obs;
RxString sleepTime =''.obs;
RxString wakeUpTime =''.obs;
User? user;
  @override
  Future<void> onInit()  async {

    user = auth.currentUser;

    QuerySnapshot<Map<String, dynamic>> snapshot= await FirebaseFirestore.instance
        .collection('user')
        .doc(user?.uid)
        .collection('user-info').get();
    if(  snapshot!=null && snapshot.docs!=null){
      gender.value =
          snapshot.docs.first.get('gender');
      weight.value =
          snapshot.docs.first.get('weight');
      sleepTime.value =
          snapshot.docs.first.get('bed_time');
      waterGoal.value =
          snapshot.docs.first.get('water_goal');
      wakeUpTime.value =
          snapshot.docs.first.get('wakeup_time');

    }


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
