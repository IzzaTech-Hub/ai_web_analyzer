import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ai_web_analyzer/app/modules/chat/chat_view.dart';
import 'package:ai_web_analyzer/app/modules/home/controller/home_view_ctl.dart';
import 'package:ai_web_analyzer/app/modules/url/url_view_ctl.dart';
import 'package:ai_web_analyzer/app/modules/webview/web_view.dart';
import 'package:ai_web_analyzer/app/utills/size_config.dart';
import 'package:ai_web_analyzer/app/routes/ad_navigator.dart';

class URLView extends GetView<URLViewCTL> {
  const URLView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: DefaultTabController(
        length: 2, // Two Tabs
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'WebChat AI',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            leading: GestureDetector(
                onTap: () {
                  AdNavigator.back();
                },
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                )),
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.red.shade900, // Your Color
            bottom: const TabBar(
              indicatorColor: Colors.white, // White Indicator
              indicatorWeight: 3.0, // Modern Look
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(icon: Icon(Icons.travel_explore), text: "Browsing"),
                Tab(icon: Icon(Icons.forum_rounded), text: "AI Chat"),
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              // WebWrapper(), // First View
              WebView(),
              ChatView(), // Second View
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ai_web_analyzer/app/modules/chat/chat_view.dart';
// import 'package:ai_web_analyzer/app/modules/webview/web_view.dart';

// class URLView extends StatefulWidget {
//   const URLView({super.key});

//   @override
//   State<URLView> createState() => _URLViewState();
// }

// class _URLViewState extends State<URLView> {
//   final RxBool isChatFullscreen =
//       true.obs; // Controls which view is full-screen

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     double smallSizeFactor = 0.25; // Scale factor (1/4th size)
//     double margin = 20; // Space from screen edges

//     return Scaffold(
//       body: Obx(() {
//         bool isChatBig = isChatFullscreen.value;
//         Widget fullScreenView = isChatBig ? ChatView() : const WebView();
//         Widget smallView = isChatBig ? const WebView() : ChatView();

//         return Stack(
//           children: [
//             /// Full-screen view (Works normally)
//             Positioned.fill(child: fullScreenView),

//             /// Small view placeholder (Only swaps when clicked)
//             Positioned(
//               top: margin,
//               left: margin,
//               width: screenWidth, // Keep full screen width
//               height: screenHeight, // Keep full screen height
//               child: Transform.scale(
//                 scale:
//                     smallSizeFactor, // Only scale the content, not the placeholder
//                 alignment: Alignment.topLeft, // Keep it in top-left
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: GestureDetector(
//                       onTap: () =>
//                           isChatFullscreen.toggle(), // Swap views on tap
//                       behavior: HitTestBehavior.opaque,
//                       child: AbsorbPointer(
//                           absorbing: true,
//                           child: smallView)), // The smaller view
//                 ),
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }
