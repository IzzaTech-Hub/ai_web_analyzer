import 'package:ai_web_analyzer/app/models/pdf_handler.dart';
import 'package:ai_web_analyzer/app/modules/pdf_operations/controllers/pdf_operations_controller.dart';
import 'package:ai_web_analyzer/app/providers/admob_ads_provider.dart';
import 'package:ai_web_analyzer/app/routes/ad_navigator.dart';
import 'package:ai_web_analyzer/app/routes/app_pages.dart';
import 'package:ai_web_analyzer/app/routes/app_pages.dart';
import 'package:ai_web_analyzer/app/utills/appstring.dart';
import 'package:ai_web_analyzer/operation_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ai_web_analyzer/app/modules/home/controller/home_view_ctl.dart';
import 'package:ai_web_analyzer/app/utills/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends GetView<HomeViewCTL> {
  HomeView({super.key});
  late BannerAd myBanner;
  RxBool isBannerLoaded = false.obs;

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
    void _shareApp(BuildContext context) {
      Share.share(
          "Consider downloading this exceptional app, available on the Google Play Store at the following link: https://play.google.com/store/apps/details?id=app.chatwebai.pdfai_app");
      // 'Check out this amazing cat cartoon channel for kids! 🐱 https://yourchannel.link');
    }

    void _sendFeedback(BuildContext context) async {
      final Uri emailLaunchUri = Uri.parse(
          'https://play.google.com/store/apps/details?id=app.chatwebai.pdfai_app');

      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open email app')),
        );
      }
    }

    SizeConfig().init(context);
    PdfOperationsController ppcontroller = Get.put(PdfOperationsController());
    initBanner();
    return Scaffold(
      bottomSheet: Container(
        height: SizeConfig.blockSizeVertical * 10,
        // margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 23),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6), // Transparent background
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        // height: 100,
        // width: SizeConfig.screenWidth / 2,
        child: GestureDetector(
          onTap: () async {
            final InAppReview inAppReview = InAppReview.instance;

            inAppReview.openStoreListing();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin:
                    EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 0.5),
                child: Text(
                  "Rate Us",
                  style: GoogleFonts.alata(
                      color: Colors.black,
                      fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.grey,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                // Opens the drawer
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red, // Red shade
                  Colors.red.shade700, // Darker red
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          centerTitle: true,
          title: const Text(
            'AI Web Analyzer',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          elevation: 0,
          backgroundColor:
              Colors.transparent, // Must be transparent to see gradient

          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.home, color: Colors.white),
          //     onPressed: () {},
          //   ),
          //   IconButton(
          //     icon: const Icon(Icons.info, color: Colors.white),
          //     onPressed: () {},
          //   ),
          //   IconButton(
          //     icon: const Icon(Icons.contact_support, color: Colors.white),
          //     onPressed: () {},
          //   ),
          // ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                // color: Color(0xffF89C9E),
                color: Colors.red,
              ),
              child: Image.asset("assets/icon/icon.png"),
              // child: Text('Menu',
              //     style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(
                Icons.star_rate,
                color: Colors.red,
              ),
              title: const Text('Feedback'),
              onTap: () => _sendFeedback(context),
            ),
            ListTile(
              leading: const Icon(
                Icons.share,
                color: Colors.red,
              ),
              title: const Text(
                'Share',
              ),
              onTap: () => _shareApp(context),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Divider(
                  // color: Colors.red,
                  height: 0.1,
                  thickness: 0.1,
                ),
                // Hero Section
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red, Colors.red.shade900],
                      // begin: Alignment.topCenter,
                      // end: Alignment.bottomCenter,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => isBannerLoaded.value &&
                                  AdMobAdsProvider.instance.isAdEnable.value
                              ? Container(
                                  height: AdSize.banner.height.toDouble(),
                                  child: AdWidget(ad: myBanner))
                              : Container()),
                          verticalSpace(20),
                          const Text(
                            'Extract Data Smarter, Faster',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'AI-powered website analyzing made simple and efficient.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.only(left: 24, right: 12),
                            // padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child:

                                      TextField(
                                    cursorColor: Colors.white,
                                    textInputAction: TextInputAction.go,
                                    controller: controller.searchController,
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
                                      controller.goToUrl();

                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                      Icons.keyboard_double_arrow_right_rounded,
                                      color: Colors.white),
                                  onPressed: () {
                                    controller.goToUrl();
                                
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          GestureDetector(
                            onTap: () async {
                              ClipboardData? clipboardData =
                                  await Clipboard.getData(Clipboard.kTextPlain);
                              if (clipboardData != null &&
                                  clipboardData.text != null) {
                                controller.searchController.text = clipboardData
                                    .text!; // Set text to controller
                                controller.searchController.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(
                                      offset: controller
                                          .searchController.text.length),
                                ); // Move cursor to the end
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Text(
                                'Paste URL',
                                style: TextStyle(
                                    color: Colors.red.shade900,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    height: 1),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 20),

                // Features Section //

                Padding(
                    padding: EdgeInsets.all(16.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 5,
                      childAspectRatio: 0.9,
                      physics: NeverScrollableScrollPhysics(), //

                      children: [
                        FeatureCard1(
                          title: 'AI PDF Assistant',
                          description:
                              'Summarize, extract insights, and get instant answers',
                        ),
                        Card(
                          elevation: 4,

                          // margin: const EdgeInsets.symmetric(
                          //     horizontal: 16, vertical: 8),
                          child: InkWell(
                            onTap: () {
                              AdNavigator.toNamed(Routes.PDFSCANNER);
                              // Get.toNamed(Routes.PDFSCANNER);
                              // PdfOperationsController ppcontroller =
                              //     Get.put(PdfOperationsController());
                              // ppcontroller.pdfConverter();
                            },
                            // borderRadius: BorderRadius.circular(15),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.red.shade50, Colors.white],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: Colors.red.shade900, width: 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.image,
                                          color: Colors.red.shade800,
                                          size: 32,
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.red.shade800,
                                          size: 28,
                                        ),
                                        Icon(
                                          Icons.picture_as_pdf,
                                          color: Colors.red.shade800,
                                          size: 32,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      // operation.name,
                                      'Scan to PDF',
                                      // style:
                                      //     Theme.of(context).textTheme.titleMedium?.copyWith(
                                      //           fontWeight: FontWeight.bold,
                                      //         ),
                                      style: TextStyle(
                                          color: Colors.red.shade800,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      // operation.description,
                                      'Turn images into high quality PDFs in seconds.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                        fontFamily: 'Roboto',
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          child: InkWell(
                            onTap: () async {
                              // Get.toNamed(Routes.PDF_OPERATIONS);

                              await ppcontroller.pdfConverter();
                            },
                            // borderRadius: BorderRadius.circular(15),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.red.shade50, Colors.white],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: Colors.red.shade900, width: 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.picture_as_pdf,
                                          color: Colors.red.shade800,
                                          size: 32,
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.red.shade800,
                                          size: 28,
                                        ),
                                        Icon(
                                          Icons.save_rounded,
                                          color: Colors.red.shade800,
                                          size: 32,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      // operation.name,
                                      'PDF Converter',

                                      style: TextStyle(
                                          color: Colors.red.shade800,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      // operation.description,
                                      'Transform PDFs into Word, Excel, PowerPoint & more formats.',

                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                        fontFamily: 'Roboto',
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          child: InkWell(
                            onTap: () {
                              AdNavigator.toNamed(Routes.PDF_OPERATIONS);
                            },
                            // borderRadius: BorderRadius.circular(15),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.red.shade50, Colors.white],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: Colors.red.shade900, width: 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.picture_as_pdf,
                                      color: Colors.red.shade800,
                                      size: 32,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          // operation.name,
                                          'More Pdf Tools',
                                          // style:
                                          //     Theme.of(context).textTheme.titleMedium?.copyWith(
                                          //           fontWeight: FontWeight.bold,
                                          //         ),
                                          style: TextStyle(
                                              color: Colors.red.shade800,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.red.shade800,
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      // operation.description,
                                      'Manipulate and convert PDFs with advance powerful Tools',

                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                        fontFamily: 'Roboto',
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
             
                verticalSpace(SizeConfig.blockSizeVertical * 10),
              ],
            ),
          ),
          Obx(() {
            if (ppcontroller.isgenerating.value) {
              return Container(
                color: Colors.black.withOpacity(0.7),
                child: const Center(
                  child: SizedBox(
                      // width: SizeConfig.screenWidth * 0.7,
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        strokeWidth: 8,
                        color: Colors.red,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Converting Your PDF...',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )
                    ],
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

class FeatureCard1 extends StatelessWidget {
  final String title;
  final String description;

  const FeatureCard1({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    HomeViewCTL controller = Get.find();
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: GestureDetector(
        onTap: () async {
          await controller.goToPdf();
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.shade50, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.red.shade900, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  CupertinoIcons.arrow_up_doc_fill,
                  size: 32,
                  color: Colors.red.shade800,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontFamily: 'Roboto',
                    // height: 1.,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Chat with PDF →",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.shade800,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Try Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
