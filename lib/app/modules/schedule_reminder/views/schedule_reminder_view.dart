import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/schedule_reminder_controller.dart';

class ScheduleReminderView extends GetView<ScheduleReminderController> {

  const ScheduleReminderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ScheduleReminderView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'ScheduleReminderView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
