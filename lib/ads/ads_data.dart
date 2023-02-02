import 'package:flutter/services.dart';
import 'package:yodo1mas/testmasfluttersdktwo.dart';

bannerAds() {
  return Yodo1MASBannerAd(
    size: BannerSize.Banner,
    onLoad: () => {},
    onOpen: () => {},
    onClosed: () => {},
    onLoadFailed: (message) => {},
    onOpenFailed: (message) => {},
  );
}
class CommonHelper {


  static bool? interstitialAds() {
print("object^^^^^^^^^^^^^^^");
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    bool? adsOpen;

//  Timer.periodic(const Duration(seconds: 5), (timer) {
    Yodo1MAS.instance.setInterstitialListener((event, message) {
      print("^^^^^^^^^^^^^^");
      switch (event) {
        case Yodo1MAS.AD_EVENT_OPENED:
          print('Interstitial AD_EVENT_OPENED');
          adsOpen = true;
          SystemChrome.setEnabledSystemUIMode(
              SystemUiMode.manual, overlays: []);

          break;
        case Yodo1MAS.AD_EVENT_ERROR:
          print('Interstitial AD_EVENT_ERROR$message');
          adsOpen = false;
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          break;
        case Yodo1MAS.AD_EVENT_CLOSED:
          print('Interstitial AD_EVENT_CLOSED');
          adsOpen = false;
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          break;
      }
    });
// });
    return adsOpen;
  }
}
