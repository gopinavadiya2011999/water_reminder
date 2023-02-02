import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:waterreminder/app/modules/bottom_tab/views/bottom_tab_view.dart';
import 'package:waterreminder/app/modules/login/views/login_view.dart';
import 'package:waterreminder/constant/color_constant.dart';
import 'package:waterreminder/constant/text_style_constant.dart';
import 'package:waterreminder/main.dart';
import 'package:waterreminder/no_internet/check_network.dart';
import 'package:yodo1mas/testmasfluttersdktwo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool isStared = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    timer();
  }


  timer() async {
    // String? token = await FirebaseMessaging.instance.getToken();
    // print("Token :: ${token}");
    await Future.delayed(Duration(milliseconds: 15));
    isStared = true;
    Timer(const Duration(seconds: 4), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      bool? isLogin = box.read('login') ?? false;
      setState(() {});

      if (isLogin) {
        Get.offAll(BottomTabView());
      } else {
     Yodo1MAS.instance.showRewardAd();
        Get.offAll(LoginView());
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return  CheckNetwork(
      child: Scaffold(
              body: Container(
                height: double.infinity,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                        child: Container(
                      color: ColorConstant.blueFe,
                    )),
                    Positioned.fill(
                        child: Image.asset('assets/Water.gif',
                            fit: BoxFit.fill,
                            opacity: AnimationController(
                                vsync: this,
                                lowerBound: 200,
                                upperBound: 200,
                                value: 0.1))),
                    Positioned(
                      left: MediaQuery.of(context).size.width / 15,
                      right: MediaQuery.of(context).size.width / 15,
                      top: MediaQuery.of(context).size.height / 4.5,
                      child: AnimatedOpacity(
                        child: Text("WATER REMINDER",
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyleConstant.blue60.copyWith(
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 2
                                  ..color = isStared
                                      ? ColorConstant.blueFF
                                      : ColorConstant.blueFF)),
                        duration: Duration(seconds: 3),
                        opacity: isStared ? 1 : 0.4,
                      ),
                    ),
                    AnimatedPositioned(
                      child: Image.asset("assets/bottle.png", fit: BoxFit.fill),
                      top: isStared
                          ? (MediaQuery.of(context).size.height / 2.6)
                          : 0,
                      width: MediaQuery.of(context).size.width / 2.1,
                      height: MediaQuery.of(context).size.height / 3.4,
                      duration: Duration(seconds: 3),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
