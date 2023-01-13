import 'package:get/get.dart';

import '../controllers/schedule_reminder_controller.dart';

class ScheduleReminderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleReminderController>(
      () => ScheduleReminderController(),
    );
  }
}
