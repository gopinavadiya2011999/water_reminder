
import 'package:waterreminder/ads/timer_service.dart';
import 'package:waterreminder/main.dart';

import 'ad_service.dart';

void setUp() {
  getIt.registerSingleton<TimerService>(TimerService());
  getIt.registerSingleton<AdService>(AdService());
}