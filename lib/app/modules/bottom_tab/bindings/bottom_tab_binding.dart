import 'package:get/get.dart';

import '../controllers/bottom_tab_controller.dart';

class BottomTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomTabController>(
      () => BottomTabController(),
    );
  }
}
