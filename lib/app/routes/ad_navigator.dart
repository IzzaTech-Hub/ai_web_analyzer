import 'dart:async';
import 'package:ai_web_analyzer/app/providers/admob_ads_provider.dart';
import 'package:get/get.dart';

class AdNavigator {
  static Future<void> to(dynamic page,
      {dynamic arguments, bool fullscreenDialog = false}) async {
    await _showInterstitialAd();
    Get.to(page, arguments: arguments, fullscreenDialog: fullscreenDialog);
  }

  static Future<void> toNamed(dynamic page,
      {dynamic arguments, bool fullscreenDialog = false}) async {
    await _showInterstitialAd();
    Get.toNamed(page, arguments: arguments);
  }

  static Future<void> off(dynamic page, {dynamic arguments}) async {
    await _showInterstitialAd();
    Get.off(page, arguments: arguments);
  }

  static Future<void> offAll(dynamic page, {dynamic arguments}) async {
    await _showInterstitialAd();
    Get.offAll(page, arguments: arguments);
  }

  static Future<void> back({dynamic result}) async {
    await _showInterstitialAd();
    Get.back(result: result);
  }

  static Future<void> _showInterstitialAd() async {
    final completer = Completer<void>();
    bool adShown = false;
    print('showing ad');
    AdMobAdsProvider.instance.showInterstitialAd(() {
      adShown = true;
      completer.complete();
    });
    // Fallback: if ad doesn't show in 2 seconds, continue
    Future.delayed(const Duration(seconds: 2), () {
      if (!adShown) completer.complete();
    });
    return completer.future;
  }
}
