// //? Commented by jamal start
import 'package:ai_web_analyzer/app/utills/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ComFunction {}

Container NativeAdMethed(NativeAd? nativeAd, RxBool isNativeAdLoaded) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 1.5),
    child: Obx(() => isNativeAdLoaded.value
        ? Container(width: 320, height: 280, child: AdWidget(ad: nativeAd!))
        : Container(
            //commetned by Raqeeb --start
            // width: 320,
            // height: 280,
            // // color: Colors.grey,

            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(20),
            //     border: Border.all(color: Colors.grey)),
            // child: Center(
            //     child: Text(
            //   "Ads Placement",
            //   style: TextStyle(color: Colors.white, fontSize: 22),
            // )),
            //commetned by Raqeeb --end
            )),
  );
}
