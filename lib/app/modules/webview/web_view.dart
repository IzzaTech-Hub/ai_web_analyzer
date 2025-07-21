// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ai_web_analyzer/app/models/current_content.dart';
// import 'package:ai_web_analyzer/app/models/url_handler.dart';
// import 'package:ai_web_analyzer/app/modules/webview/web_view_ctl.dart';
// import 'package:ai_web_analyzer/app/utills/size_config.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// // class WebWrapper extends StatelessWidget {
// //   const WebWrapper({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return GetBuilder<WebViewCTL>(
// //       init: WebViewCTL(),
// //       builder: (_) => const WebView(),
// //     );
// //   }
// // }

// class WebWrapper extends StatelessWidget {
//   WebWrapper({super.key});

//   // Ensure controller is initialized only once
//   final WebViewCTL controller = Get.put(WebViewCTL());

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<WebViewCTL>(
//       builder: (_) => const WebView(),
//     );
//   }
// }

// class WebView extends GetView<WebViewCTL> {
//   const WebView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);

//     return WebViewScreen(
//       initialUrl: UrlHandler.url,
//     );
//   }
// }

// class WebViewScreen extends StatefulWidget {
//   final String initialUrl;

//   WebViewScreen({required this.initialUrl});

//   @override
//   State<WebViewScreen> createState() => _WebViewScreenState();
// }

// class _WebViewScreenState extends State<WebViewScreen> {
//   late final WebViewController _controller;
//   @override
//   bool get wantKeepAlive => true;

//   @override
//   void initState() {
//     super.initState();
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onNavigationRequest: (request) {
//             // Allow navigation and update content for the new URL
//             if (request.url.startsWith('http')) {
//               WebContentManager.updateContent(request.url);
//             }
//             return NavigationDecision.navigate;
//           },
//           onPageStarted: (url) {
//             // Update content when a new page starts loading
//             WebContentManager.updateContent(url);
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(widget.initialUrl));

//     // Initialize content for the initial URL
//     WebContentManager.updateContent(widget.initialUrl);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Web Browser')),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Print the current content to the console
//           print('Current Content: ${WebContentManager.currentContent}');
//         },
//         child: Icon(Icons.chat),
//       ),
//       body: WebViewWidget(controller: _controller),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ai_web_analyzer/app/models/current_content.dart';
import 'package:ai_web_analyzer/app/models/url_handler.dart';
import 'package:ai_web_analyzer/app/modules/webview/web_view_ctl.dart';

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> with AutomaticKeepAliveClientMixin {
  final WebViewCTL controller =
      Get.put(WebViewCTL());
  late final WebViewController _webController;

  @override
  bool get wantKeepAlive => true; // ✅ Keeps WebView in memory

  @override
  void initState() {
    super.initState();
    _webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.startsWith('http')) {
              WebContentManager.updateContent(request.url);
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (url) {
            WebContentManager.updateContent(url);
          },
        ),
      )
      ..loadRequest(Uri.parse(UrlHandler.url));
    WebContentManager.updateContent(UrlHandler.url);

  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // ✅ Ensures AutomaticKeepAliveClientMixin works

    return
        //  Scaffold(
        // appBar: AppBar(title: const Text('Web Browser')),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     print('Current Content: ${WebContentManager.currentContent}');
        //   },
        // child: Icon(Icons.chat),
        // ),
        // body:
        WebViewWidget(controller: _webController);
    // );
  }
}
