import 'package:ai_web_analyzer/app/modules/splash_screen/controller/splash_screen_ctl.dart';
import 'package:ai_web_analyzer/app/providers/admob_ads_provider.dart';
import 'package:ai_web_analyzer/app/utills/appstring.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SplashScreen extends GetView<SplashController> {
  SplashScreen({Key? key}) : super(key: key);

  late BannerAd myBanner;
  RxBool isBannerLoaded = false.obs;

  initBanner() {
    myBanner = BannerAd(
      adUnitId: AppStrings.ADMOB_BANNER,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('Banner Ad loaded.');
          isBannerLoaded.value = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Banner Ad failed to load: $error');
        },
      ),
    );
    myBanner.load();
  }

  @override
  Widget build(BuildContext context) {
    initBanner();
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.16),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/icon/icon.png',
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width * 0.6,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.1),
                    child: Text(
                      "AI Web Analyzer",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Text(
                    "Analyze Web Content with AI",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.05),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.09,
                        right: MediaQuery.of(context).size.width * 0.15,
                        left: MediaQuery.of(context).size.width * 0.15,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Obx(
                            () => LinearProgressIndicator(
                              value: controller.percent.value / 100,
                              backgroundColor: Colors.grey.shade100,
                              color: Colors.blue,
                              minHeight: 6,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Obx(
                      () => isBannerLoaded.value &&
                              AdMobAdsProvider.instance.isAdEnable.value
                          ? SizedBox(
                              height: AdSize.banner.height.toDouble(),
                              child: AdWidget(ad: myBanner),
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
