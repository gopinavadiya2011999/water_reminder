import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:waterreminder/app/modules/splash/views/splash_view.dart';
import 'package:waterreminder/no_internet/check_network.dart';
import 'package:waterreminder/no_internet/provider_setup.dart';
import 'package:waterreminder/notification_logic.dart';
import 'package:yodo1mas/Yodo1MAS.dart';

import 'ads/setup.dart';

FirebaseAuth auth = FirebaseAuth.instance;

final getIt = GetIt.instance;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

}


Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  Yodo1MAS.instance.init(
      "jopV935IZE",
      true,
          (successful) =>
      {});
  await Firebase.initializeApp();
  setUp();

  NotificationLogic.init( );
   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

final box = GetStorage();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {



    return MultiProvider(
      providers: providers,
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return GetMaterialApp(

            theme: ThemeData(

                textSelectionTheme: TextSelectionThemeData(
                  selectionHandleColor: Colors.transparent
                )),

              themeMode: ThemeMode.light,
              debugShowCheckedModeBanner: false,
              home:CheckNetwork(child: SplashScreen()));
        },
      ),
    );
  }
}
