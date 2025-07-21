import 'package:get/get.dart';
import 'package:ai_web_analyzer/app/modules/home/controller/home_view_ctl.dart';

class HomeViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeViewCTL());
  }
}
