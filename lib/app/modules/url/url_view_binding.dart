import 'package:get/get.dart';
import 'package:ai_web_analyzer/app/modules/home/controller/home_view_ctl.dart';
import 'package:ai_web_analyzer/app/modules/url/url_view_ctl.dart';

class URLViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(URLViewCTL());
  }
}
