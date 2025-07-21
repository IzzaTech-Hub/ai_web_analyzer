import 'package:ai_web_analyzer/app/providers/admob_ads_provider.dart';
import 'package:ai_web_analyzer/app/providers/cm.dart';
import 'package:ai_web_analyzer/app/routes/ad_navigator.dart';
import 'package:ai_web_analyzer/app/utills/appstring.dart';
import 'package:ai_web_analyzer/app/utills/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/pdfscanner_controller.dart';
// import '../routes/ad_navigator.dart';

class PdfscannerView extends GetView<PdfscannerController> {
  PdfscannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                if (controller.isGenerated.value) {
                  controller.isGenerated.value = false;
                } else {
                  AdNavigator.back();
                }
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              )),
          title: const Text(
            'Scan to PDF',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          // actions: [
          //   controller.isGenerated.value
          //       ? IconButton(onPressed: () {}, icon: Icon(Icons.save))
          //       : Container()
          // ],
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.red.shade700,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Obx(() {
          return !controller.isGenerated.value
              ? ExpandableFab(
                  onCameraTap: () => controller.onCameraTap(),
                  onGalleryTap: () => controller.onGalleryTap(),
                )
              : SizedBox.shrink(); // Empty widget when FAB is hidden
        }),
        body: Obx(() => !controller.isGenerated.value
            ? GenerationView(controller: controller)
            : PdfViewerWidget(
                controller: controller,
              )));
  }
}
// import 'package:flutter/material.dart';

class ExpandableFab extends StatefulWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  const ExpandableFab({
    Key? key,
    required this.onCameraTap,
    required this.onGalleryTap,
  }) : super(key: key);

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          // Background tappable area to close
          // if (isOpen)
          //   GestureDetector(
          //     onTap: () => setState(() => isOpen = false),
          //     behavior: HitTestBehavior.opaque,
          //     child: Container(color: Colors.transparent),
          //   ),

          // Gallery Button
          Positioned(
            right: 20,
            bottom: 130,
            child: Visibility(
              visible: isOpen,
              child: FloatingActionButton(
                heroTag: 'gallery',
                mini: true,
                // backgroundColor: Colors.green,
                onPressed: widget.onGalleryTap,
                child: Icon(Icons.photo),
              ),
            ),
          ),

          // Camera Button
          Positioned(
            right: 20,
            // bottom: 16,
            bottom: 80,
            child: Visibility(
              visible: isOpen,
              child: FloatingActionButton(
                heroTag: 'camera',
                mini: true,
                // backgroundColor: Colors.orange,
                onPressed: widget.onCameraTap,
                child: Icon(Icons.camera_alt),
              ),
            ),
          ),

          // Main FAB
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.red.shade700,
              heroTag: 'main',
              onPressed: () => setState(() => isOpen = !isOpen),
              child: Icon(
                isOpen ? Icons.close : Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GenerationView extends StatelessWidget {
  PdfscannerController controller;
  GenerationView({super.key, required this.controller});
  late BannerAd myBanner;
  RxBool isBannerLoaded = false.obs;

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
  initBanner() {
    BannerAdListener listener = BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) {
        print('Ad loaded.');
        isBannerLoaded.value = true;
      },
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) {
        print('Ad opened.');
      },
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) {
        print('Ad closed.');
      },
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) {
        print('Ad impression.');
      },
    );

    myBanner = BannerAd(
      adUnitId: AppStrings.ADMOB_BANNER,
      size: AdSize.banner,
      request: AdRequest(),
      listener: listener,
    );
    myBanner.load();
  }

  @override
  Widget build(BuildContext context) {
    initBanner();
    initNative();
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Obx(() => isBannerLoaded.value &&
                        AdMobAdsProvider.instance.isAdEnable.value
                    ? Container(
                        height: AdSize.banner.height.toDouble(),
                        child: AdWidget(ad: myBanner))
                    : Container()),
                verticalSpace(10),
                Container(
                  // color: Colors.amber,
                  height: SizeConfig.screenHeight * 0.4,
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Your dynamic content (images or other widgets) here
                        // For example:
                        Obx(() {
                          final images = controller.images;
                          if (images.isEmpty) {
                            return Center(child: Text("No images selected."));
                          }
                          return GridView.builder(
                            itemCount: images.length,
                            padding: const EdgeInsets.all(8),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            shrinkWrap:
                                true, // Makes the GridView wrap its height based on the content
                            physics:
                                NeverScrollableScrollPhysics(), // Disable GridView's scrolling
                            itemBuilder: (context, index) {
                              final file = images[index];
                              return Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Stack(
                                        children: [
                                          Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor:
                                                Colors.grey.shade100,
                                            child: Container(
                                              height: double.infinity,
                                              width: double.infinity,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Image.file(
                                            file,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        shape: BoxShape.circle,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          controller.images.removeAt(index);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(Icons.close,
                                              color: Colors.white, size: 18),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Create PDF Button
                Obx(() => Visibility(
                      visible: controller.images.isNotEmpty,
                      child: SizedBox(
                        width: SizeConfig.blockSizeHorizontal * 40,
                        child: ElevatedButton.icon(
                          onPressed: controller.createPdfFromImages,
                          icon: Icon(
                            Icons.picture_as_pdf,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Create PDF",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    )),

                Obx(
                  () => AdMobAdsProvider.instance.isAdEnable.value
                      ? Center(
                          child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                      SizeConfig.blockSizeHorizontal * 5),
                              child:
                                  NativeAdMethed(nativeAd, nativeAdIsLoaded)),
                        )
                      : Container(),
                ),
                verticalSpace(12),
              ],
            ),
          ),
        ),
        Obx(() {
          if (controller.isGenerating.value) {
            return Container(
              color: Colors.black.withOpacity(0.7),
              child: const Center(
                child: SizedBox(
                    // width: SizeConfig.screenWidth * 0.7,
                    child: CircularProgressIndicator(
                  strokeWidth: 8,
                  color: Colors.red,
                )),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}

class PdfViewerWidget extends StatelessWidget {
  PdfscannerController controller;

  PdfViewerWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.filePath.value.isEmpty) {
        return Center(child: Text("No PDF to display"));
      }

      return PDFView(
        filePath: controller.filePath.value,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageSnap: true,
        fitPolicy: FitPolicy.BOTH,
      );
    });
  }
}
