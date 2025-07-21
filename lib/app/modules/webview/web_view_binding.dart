import 'package:get/get.dart';
import 'package:ai_web_analyzer/app/modules/home/controller/home_view_ctl.dart';
import 'package:ai_web_analyzer/app/modules/webview/web_view_ctl.dart';

class WebViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WebViewCTL());
  }
}
