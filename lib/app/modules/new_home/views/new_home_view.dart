import 'package:ai_web_analyzer/app/providers/admob_ads_provider.dart';
import 'package:ai_web_analyzer/app/providers/cm.dart';
import 'package:ai_web_analyzer/app/routes/ad_navigator.dart';
import 'package:ai_web_analyzer/app/utills/appstring.dart';
import 'package:ai_web_analyzer/app/utills/size_config.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../controllers/new_home_controller.dart';
import 'package:ai_web_analyzer/app/models/pdf_handler.dart';
import 'package:ai_web_analyzer/app/modules/pdf_operations/controllers/pdf_operations_controller.dart';
import 'package:ai_web_analyzer/app/modules/home/controller/home_view_ctl.dart';
import 'package:ai_web_analyzer/app/routes/app_pages.dart';
import 'package:ai_web_analyzer/operation_card.dart';

class NewHomeView extends GetView<NewHomeController> {
  NewHomeView({super.key});
  late BannerAd myBanner;
  RxBool isBannerLoaded = false.obs;

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
    final pdfOpsCtl = Get.find<PdfOperationsController>();
    final homeCtl = Get.find<HomeViewCTL>();

    final converters = [
      {
        'label': 'Word',
        'icon': Icons.description,
        'color': Colors.blueAccent,
        'ext': 'docx'
      },
      {
        'label': 'Excel',
        'icon': Icons.grid_on,
        'color': Colors.green,
        'ext': 'xlsx'
      },
      {
        'label': 'PowerPoint',
        'icon': Icons.slideshow,
        'color': Colors.orange,
        'ext': 'pptx'
      },
      {
        'label': 'Images',
        'icon': Icons.image,
        'color': Colors.purple,
        'ext': 'jpeg'
      },
      {
        'label': 'RTF',
        'icon': Icons.text_snippet_outlined,
        'color': Colors.indigo,
        'ext': 'rtf'
      },
    ];

    return Scaffold(
      // backgroundColor: Colors.red.shade400,

      appBar: PreferredSize(
          preferredSize: Size.fromHeight(SizeConfig.screenHeight * 0.2),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade800, Colors.red.shade400],
                // begin: Alignment.topLeft,
                // end: Alignment.bottomRight,
              ),
              // borderRadius: BorderRadius.circular(16),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'AI PDF Assistant',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Chat with PDFs and use pro tools — all in one place.',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          )),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade800, Colors.red.shade400],
                // begin: Alignment.topLeft,
                // end: Alignment.bottomRight,
              ),
              // borderRadius: BorderRadius.circular(16),
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                // gradient: LinearGradient(
                // colors: [Colors.red.shade800, Colors.red.shade400],
                // begin: Alignment.topLeft,
                // end: Alignment.bottomRight,
                // ),

                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    // const SizedBox(height: 8),

                    // Primary quick actions
                    Row(
                      children: [
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade800,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              // await PdfHandler().extractTextFromPDF();
                              homeCtl.goToPdf();
                            },
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text(
                              'Chat with PDF',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: Colors.red.shade800),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () =>
                                AdNavigator.toNamed(Routes.PDFSCANNER),
                            // onPressed: () => Get.toNamed(Routes.PDFSCANNER),
                            icon: Icon(Icons.document_scanner,
                                color: Colors.red.shade800),
                            label: Text(
                              'Scan to PDF',
                              style: TextStyle(
                                color: Colors.red.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Obx(() => isBannerLoaded.value &&
                            AdMobAdsProvider.instance.isAdEnable.value
                        ? Column(
                            children: [
                              const SizedBox(height: 10),
                              Container(
                                  height: AdSize.banner.height.toDouble(),
                                  child: AdWidget(ad: myBanner)),
                            ],
                          )
                        : Container()),
                    verticalSpace(10),
                    // Converters section
                    const Text(
                      'Convert PDF to',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: converters.map((c) {
                        return InkWell(
                          onTap: () =>
                              pdfOpsCtl.quickConvert(c['ext'] as String),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: (Get.width - 56) / 3,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x11000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor:
                                      (c['color'] as Color).withOpacity(0.15),
                                  child: Icon(c['icon'] as IconData,
                                      color: c['color'] as Color),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  c['label'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // PDF Tools section
                    const Text(
                      'PDF Tools',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    ...pdfOpsCtl.operations.map((op) => OperationCard(
                          operation: op,
                          onTap: () => AdNavigator.toNamed(op.route),
                        )),

                    const SizedBox(height: 20),

                    // Web chat (less focus)
                    // Text(
                    //   'Web Chat (Optional)',
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.w600,
                    //     color: Colors.grey.shade800,
                    //   ),
                    // ),
                    // const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade300,
                            Colors.blue.shade700,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 24, right: 12),

                            // padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              // color: Colors.red,
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TextField(
                                    cursorColor: Colors.white,
                                    textInputAction: TextInputAction.go,
                                    controller: homeCtl.searchController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      hintText: 'Enter webpage URL...',
                                      hintStyle:
                                          TextStyle(color: Colors.white70),
                                      border: InputBorder.none,
                                    ),
                                    // selectionControls:
                                    //     CustomTextSelectionControls(),
                                    onSubmitted: (value) {
                                      homeCtl.goToUrl();
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                      Icons.keyboard_double_arrow_right_rounded,
                                      color: Colors.white),
                                  onPressed: () {
                                    homeCtl.goToUrl();
                                  },
                                ),
                              ],
                            ),
                          ),
                          // TextField(
                          //   controller: homeCtl.searchController,
                          //   keyboardType: TextInputType.url,
                          //   decoration: const InputDecoration(
                          //     hintText: 'Enter website URL (https://...)',
                          //     prefixIcon: Icon(Icons.public),
                          //     border: OutlineInputBorder(),
                          //   ),
                          // ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                // backgroundColor: Colors.transparent,
                                backgroundColor: Colors.blue.shade500,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                              onPressed: () => homeCtl.goToUrl(),
                              child: const Text('Chat with Website'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // TextButton(
                    //   onPressed: () => AdNavigator.toNamed(Routes.CHATVIEW),
                    //   child: const Text('Open Web Chat'),
                    // ),
                    //native ad
                    Obx(
                      () => AdMobAdsProvider.instance.isAdEnable.value
                          ? Center(
                              child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConfig.blockSizeHorizontal * 5),
                                  child: NativeAdMethed(
                                      nativeAd, nativeAdIsLoaded)),
                            )
                          : Container(),
                    ),
                    verticalSpace(12),
                  ],
                ),
              ),
            ),
          ),

          // Loading overlay when extracting PDF
          Obx(() {
            final reading = PdfHandler.isLoading.value;
            final converting = pdfOpsCtl.isgenerating.value;
            if (reading || converting) {
              final message = converting
                  ? 'Converting your file...'
                  : 'Reading your PDF...';
              return Container(
                color: Colors.black54,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
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
