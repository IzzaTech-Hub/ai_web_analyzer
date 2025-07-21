import 'dart:async';
import 'dart:math';
import 'package:ai_web_analyzer/app/providers/admob_ads_provider.dart';
import 'package:ai_web_analyzer/app/routes/app_pages.dart';
// import 'package:face_scanner/app/providers/applovin_ads.provider.dart';
// import 'package:face_scanner/app/routes/app_pages.dart';
// import 'package:face_scanner/app/services/remoteconfig_services.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  RxInt percent = 0.obs;
  RxBool isLoadingComplete = false.obs;
  bool _isNavigating = false;

  @override
  void onInit() {
    super.onInit();
    _startLoading();
  }

  void _startLoading() async {
    // Start loading the interstitial ad early
    AdMobAdsProvider.instance.initialize();

    // Show progress animation
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      percent.value = i;
    }

    // Loading complete, show the Get Started button
    isLoadingComplete.value = true;
    onGetStartedPressed();
  }

  void onGetStartedPressed() {
    // Prevent multiple navigation attempts
    if (_isNavigating) return;
    _isNavigating = true;

    // Try to show interstitial ad
    // AdMobAdsProvider.instance.showInterstitialAd((){});
    AdMobAdsProvider.instance.showInterstitialAd(() {
      Get.offAllNamed(Routes.HOMEVIEW);
    });

    // Fallback: if ad doesn't show in 3 seconds, navigate anyway
    Future.delayed(const Duration(seconds: 3), () {
      if (_isNavigating) {
        Get.offAllNamed(Routes.HOMEVIEW);
      }
    });
  }

  // var tabIndex = 0.obs;
  // Rx<int> percent = 0.obs;
  // Rx<bool> isLoaded = false.obs;
  // @override
  // void onInit() async {
  //   super.onInit();
  //   await RemoteConfigService().initialize();
  //   // AppLovinProvider.instance.init();

  //   // AppLovinProvider.instance.init();
  //   Timer? timer;
  //   timer = Timer.periodic(Duration(milliseconds: 500), (_) {
  //     int n = Random().nextInt(10) + 5;
  //     percent.value += n;
  //     if (percent.value >= 100) {
  //       percent.value = 100;
  //       Get.offNamed(Routes.HOMEVIEW);

  //       // isLoaded.value = true;

  //       timer!.cancel();
  //     }
  //   });

  //   // prefs.then((SharedPreferences pref) {
  //   //   isFirstTime = pref.getBool('first_time') ?? true;

  //   //   print("Is First Time from Init: $isFirstTime");
  //   // });
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {}

  // // void setFirstTime(bool bool) {
  // //   prefs.then((SharedPreferences pref) {
  // //     pref.setBool('first_time', bool);
  // //     print("Is First Time: $isFirstTime");
  // //   });
  // // }
}
