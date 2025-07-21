import 'package:ai_web_analyzer/app/providers/admob_ads_provider.dart';
import 'package:ai_web_analyzer/app/providers/cm.dart';
import 'package:ai_web_analyzer/app/routes/app_pages.dart';
import 'package:ai_web_analyzer/app/utills/appstring.dart';
import 'package:ai_web_analyzer/app/utills/size_config.dart';
import 'package:ai_web_analyzer/operation_card.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../controllers/pdf_operations_controller.dart';
import 'package:ai_web_analyzer/app/routes/ad_navigator.dart';

class PdfOperationsView extends GetView<PdfOperationsController> {
  PdfOperationsView({super.key});

  // // // Native Ad Implementation start // // //

  //? commented by jamal start
  NativeAd? nativeAd;
  RxBool nativeAdIsLoaded = false.obs;

  initNative() {
    nativeAd = NativeAd(
      adUnitId: AppStrings.ADMOB_NATIVE,
      request: AdRequest(),
      // factoryId: ,
      nativeTemplateStyle:
          NativeTemplateStyle(templateType: TemplateType.medium),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          print('$NativeAd loaded.');

          nativeAdIsLoaded.value = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
      ),
    )..load();
  }
  //? commented by jamal end

  /// Native Ad Implemntation End ///

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              AdNavigator.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
        title: const Text(
          'PDF Operations',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.red.shade700,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              // Card(
              //   elevation: 4,
              //   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //   child: InkWell(
              //     onTap: () {
              //       // Get.toNamed(Routes.PDF_OPERATIONS);
              //       controller.pdfConverter();
              //     },
              //     // borderRadius: BorderRadius.circular(15),
              //     child: Container(
              //       decoration: BoxDecoration(
              //         gradient: LinearGradient(
              //           colors: [Colors.red.shade50, Colors.white],
              //           begin: Alignment.topLeft,
              //           end: Alignment.bottomRight,
              //         ),
              //         borderRadius: BorderRadius.circular(12),
              //         border: Border.all(color: Colors.red.shade900, width: 1),
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.all(16.0),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Row(
              //               children: [
              //                 //   Container(
              //                 //     padding: const EdgeInsets.all(12),
              //                 //     decoration: BoxDecoration(
              //                 //       color: Colors.red.shade800,
              //                 //       // color: Theme.of(context).colorScheme.primaryContainer,
              //                 //       borderRadius: BorderRadius.circular(12),
              //                 //     ),
              //                 //     child: Icon(
              //                 //       // _getIconData(operation.iconName),
              //                 //       Icons.picture_as_pdf,
              //                 //       // color: Theme.of(context).colorScheme.primary,
              //                 //       color: Colors.white,
              //                 //       size: 24,
              //                 //     ),
              //                 //   ),

              //                 Expanded(
              //                   child: Text(
              //                     // operation.name,
              //                     'PDF Converter',
              //                     // style:
              //                     //     Theme.of(context).textTheme.titleMedium?.copyWith(
              //                     //           fontWeight: FontWeight.bold,
              //                     //         ),
              //                     style: TextStyle(
              //                         color: Colors.red.shade800,
              //                         fontWeight: FontWeight.bold,
              //                         fontSize: 18),
              //                   ),
              //                 ),
              //                 Icon(
              //                   Icons.picture_as_pdf,
              //                   color: Colors.red.shade800,
              //                   size: 28,
              //                 ),
              //                 Icon(
              //                   Icons.arrow_forward,
              //                   color: Colors.red.shade800,
              //                   size: 28,
              //                 ),
              //                 Icon(
              //                   Icons.save_rounded,
              //                   color: Colors.red.shade800,
              //                   size: 28,
              //                 ),
              //                 const SizedBox(width: 16),

              //                 // Icon(
              //                 //   Icons.arrow_forward_ios,
              //                 //   size: 16,
              //                 //   color:
              //                 //       Theme.of(context).colorScheme.onSurfaceVariant,
              //                 // ),
              //               ],
              //             ),
              //             const SizedBox(height: 16),
              //             // Row(
              //             //   mainAxisAlignment: MainAxisAlignment.center,
              //             //   children: [
              //             //   ],
              //             // ),
              //             // const SizedBox(height: 16),
              //             Text(
              //               // operation.description,
              //               'Convert your PDF into Word, Excel, PowerPoint, and more.',
              //               // style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              //               //       color: Theme.of(context).colorScheme.onSurfaceVariant,
              //               //     ),
              //               style: TextStyle(
              //                 fontSize: 14,
              //                 color: Colors.grey.shade700,
              //                 fontFamily: 'Roboto',
              //                 height: 1.5,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // Divider(
              //   indent: 26,
              //   endIndent: 26,
              // ),
              // Card(
              //   elevation: 4,
              //   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              //   child: InkWell(
              //     onTap: () {
              //       Get.toNamed(Routes.PDF_OPERATIONS);
              //     },
              //     // borderRadius: BorderRadius.circular(15),
              //     child: Container(
              //       decoration: BoxDecoration(
              //         gradient: LinearGradient(
              //           colors: [Colors.red.shade50, Colors.white],
              //           begin: Alignment.topLeft,
              //           end: Alignment.bottomRight,
              //         ),
              //         borderRadius: BorderRadius.circular(12),
              //         border: Border.all(color: Colors.red.shade900, width: 1),
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.all(16.0),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Row(
              //               children: [
              //                 //   Container(
              //                 //     padding: const EdgeInsets.all(12),
              //                 //     decoration: BoxDecoration(
              //                 //       color: Colors.red.shade800,
              //                 //       // color: Theme.of(context).colorScheme.primaryContainer,
              //                 //       borderRadius: BorderRadius.circular(12),
              //                 //     ),
              //                 //     child: Icon(
              //                 //       // _getIconData(operation.iconName),
              //                 //       Icons.picture_as_pdf,
              //                 //       // color: Theme.of(context).colorScheme.primary,
              //                 //       color: Colors.white,
              //                 //       size: 24,
              //                 //     ),
              //                 //   ),

              //                 Expanded(
              //                   child: Text(
              //                     // operation.name,
              //                     'Image to PDF',
              //                     // style:
              //                     //     Theme.of(context).textTheme.titleMedium?.copyWith(
              //                     //           fontWeight: FontWeight.bold,
              //                     //         ),
              //                     style: TextStyle(
              //                         color: Colors.red.shade800,
              //                         fontWeight: FontWeight.bold,
              //                         fontSize: 18),
              //                   ),
              //                 ),
              //                 Icon(
              //                   Icons.image,
              //                   color: Colors.red.shade800,
              //                   size: 28,
              //                 ),
              //                 Icon(
              //                   Icons.arrow_forward,
              //                   color: Colors.red.shade800,
              //                   size: 28,
              //                 ),
              //                 Icon(
              //                   Icons.picture_as_pdf,
              //                   color: Colors.red.shade800,
              //                   size: 28,
              //                 ),
              //                 const SizedBox(width: 16),

              //                 // Icon(
              //                 //   Icons.arrow_forward_ios,
              //                 //   size: 16,
              //                 //   color:
              //                 //       Theme.of(context).colorScheme.onSurfaceVariant,
              //                 // ),
              //               ],
              //             ),
              //             const SizedBox(height: 16),
              //             // Row(
              //             //   mainAxisAlignment: MainAxisAlignment.center,
              //             //   children: [
              //             //   ],
              //             // ),
              //             // const SizedBox(height: 16),
              //             Text(
              //               // operation.description,
              //               'Convert photos into PDF with one tap',
              //               // style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              //               //       color: Theme.of(context).colorScheme.onSurfaceVariant,
              //               //     ),
              //               style: TextStyle(
              //                 fontSize: 14,
              //                 color: Colors.grey.shade700,
              //                 fontFamily: 'Roboto',
              //                 height: 1.5,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.operations.length,
                itemBuilder: (context, index) {
                  final operation = controller.operations[index];
                  return OperationCard(
                    operation: operation,
                    onTap: () => Get.toNamed(operation.route),
                    // onTap: () => _navigateToScreen(context, operation.route),
                  );
                },
              ),
              // const SizedBox(height: 12),
              // Card(
              //   elevation: 4,
              //   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              //   child: InkWell(
              //     onTap: () {
              //       Get.toNamed(Routes.PDF_OPERATIONS);
              //     },
              //     // borderRadius: BorderRadius.circular(15),
              //     child: Container(
              //       decoration: BoxDecoration(
              //         gradient: LinearGradient(
              //           colors: [Colors.red.shade50, Colors.white],
              //           begin: Alignment.topLeft,
              //           end: Alignment.bottomRight,
              //         ),
              //         borderRadius: BorderRadius.circular(12),
              //         border: Border.all(color: Colors.red.shade900, width: 1),
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.all(16.0),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Row(
              //               children: [
              //                 //   Container(
              //                 //     padding: const EdgeInsets.all(12),
              //                 //     decoration: BoxDecoration(
              //                 //       color: Colors.red.shade800,
              //                 //       // color: Theme.of(context).colorScheme.primaryContainer,
              //                 //       borderRadius: BorderRadius.circular(12),
              //                 //     ),
              //                 //     child: Icon(
              //                 //       // _getIconData(operation.iconName),
              //                 //       Icons.picture_as_pdf,
              //                 //       // color: Theme.of(context).colorScheme.primary,
              //                 //       color: Colors.white,
              //                 //       size: 24,
              //                 //     ),
              //                 //   ),

              //                 Expanded(
              //                   child: Text(
              //                     // operation.name,
              //                     'PDF to file',
              //                     // style:
              //                     //     Theme.of(context).textTheme.titleMedium?.copyWith(
              //                     //           fontWeight: FontWeight.bold,
              //                     //         ),
              //                     style: TextStyle(
              //                         color: Colors.red.shade800,
              //                         fontWeight: FontWeight.bold,
              //                         fontSize: 18),
              //                   ),
              //                 ),
              //                 Icon(
              //                   Icons.picture_as_pdf,
              //                   color: Colors.red.shade800,
              //                   size: 28,
              //                 ),
              //                 Icon(
              //                   Icons.arrow_forward,
              //                   color: Colors.red.shade800,
              //                   size: 28,
              //                 ),
              //                 Icon(
              //                   Icons.save_rounded,
              //                   color: Colors.red.shade800,
              //                   size: 28,
              //                 ),
              //                 const SizedBox(width: 16),

              //                 // Icon(
              //                 //   Icons.arrow_forward_ios,
              //                 //   size: 16,
              //                 //   color:
              //                 //       Theme.of(context).colorScheme.onSurfaceVariant,
              //                 // ),
              //               ],
              //             ),
              //             const SizedBox(height: 16),
              //             // Row(
              //             //   mainAxisAlignment: MainAxisAlignment.center,
              //             //   children: [
              //             //   ],
              //             // ),
              //             // const SizedBox(height: 16),
              //             Text(
              //               // operation.description,
              //               'Convert your PDF into Word, Excel, PowerPoint, and more.',
              //               // style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              //               //       color: Theme.of(context).colorScheme.onSurfaceVariant,
              //               //     ),
              //               style: TextStyle(
              //                 fontSize: 14,
              //                 color: Colors.grey.shade700,
              //                 fontFamily: 'Roboto',
              //                 height: 1.5,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Obx(
                () => AdMobAdsProvider.instance.isAdEnable.value
                    ? Center(
                        child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.blockSizeHorizontal * 5),
                            child: NativeAdMethed(nativeAd, nativeAdIsLoaded)),
                      )
                    : Container(),
              )
            ],
          )),
          Obx(() {
            if (controller.isgenerating.value) {
              return Container(
                color: Colors.black.withOpacity(0.7),
                child: const Center(
                  child: SizedBox(
                      // width: SizeConfig.screenWidth * 0.7,
                      child: CircularProgressIndicator(
                    strokeWidth: 8,
                    color: Colors.blue,
                  )),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
