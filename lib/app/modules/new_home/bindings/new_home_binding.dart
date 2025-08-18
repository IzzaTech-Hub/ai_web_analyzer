import 'package:get/get.dart';

import '../controllers/new_home_controller.dart';
import 'package:ai_web_analyzer/app/modules/home/controller/home_view_ctl.dart';
import 'package:ai_web_analyzer/app/modules/pdf_operations/controllers/pdf_operations_controller.dart';

class NewHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHomeController>(() => NewHomeController());
    // Needed for Web Chat section URL input/actions
    Get.lazyPut<HomeViewCTL>(() => HomeViewCTL(), fenix: true);
    // Needed to list and navigate PDF tools
    Get.lazyPut<PdfOperationsController>(() => PdfOperationsController(), fenix: true);
  }
}
