// import 'package:ai_web_analyzer/app/modules/pdfscreen/pdfscreen_view.dart';
// import 'package:ai_web_analyzer/app/utills/size_config.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ai_web_analyzer/app/modules/chat/chat_view.dart';
// import 'package:ai_web_analyzer/app/modules/webview/web_view.dart';

// class PDFView extends StatefulWidget {
//   const PDFView({super.key});

//   @override
//   State<PDFView> createState() => _PDFViewState();
// }

// class _PDFViewState extends State<PDFView> {
//   final RxBool isChatFullscreen =
//       true.obs; // Controls which view is full-screen

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     double smallSizeFactor = 0.25; // Scale factor (1/4th size)
//     double margin = 20; // Space from screen edges

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red.shade900,
//         title: Text("PDF Viewer",style: TextStyle(
//           fontSize: SizeConfig.blockSizeHorizontal * 5,
//           fontWeight: FontWeight.bold,
//           color: Colors.white

//         ),
//         ),
//         centerTitle: true,
//         leading: GestureDetector(
//           onTap: (){
//             Get.back();
//           },
//           child: Icon(Icons.arrow_back_ios_new_rounded,
//           color: Colors.white,)),
//       ),
//       body: Obx(() {

//         bool isChatBig = isChatFullscreen.value;
//         Widget fullScreenView = isChatBig ? ChatView() : const PDFScreenView();
//         Widget smallView = isChatBig ? const PDFScreenView() : ChatView();

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
import 'package:ai_web_analyzer/app/modules/pdfscreen/pdfscreen_view.dart';
import 'package:ai_web_analyzer/app/utills/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_web_analyzer/app/modules/chat/chat_view.dart';
import 'package:ai_web_analyzer/app/modules/webview/web_view.dart';

class PDFView extends StatefulWidget {
  const PDFView({super.key});

  @override
  State<PDFView> createState() => _PDFViewState();
}

class _PDFViewState extends State<PDFView> {
  final RxBool isChatFullscreen =
      true.obs; // Controls which view is full-screen

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two Tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "PDF Analyzer",
            style: TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal * 5,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          centerTitle: true,
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              )),
          elevation: 0,
          backgroundColor: Colors.red.shade900, // Your Color
          bottom: const TabBar(
            indicatorColor: Colors.white, // White Indicator
            indicatorWeight: 3.0, // Modern Look
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.picture_as_pdf_sharp), text: "View"),
              Tab(icon: Icon(Icons.forum_rounded), text: "AI Chat"),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // WebWrapper(), // First View
            const PDFScreenView(),
            ChatView(), // Second View
          ],
        ),
      ),
    );
  }
}
