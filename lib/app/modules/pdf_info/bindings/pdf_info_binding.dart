import 'package:get/get.dart';

import '../controllers/pdf_info_controller.dart';

class PdfInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PdfInfoController>(
      () => PdfInfoController(),
    );
  }
}
