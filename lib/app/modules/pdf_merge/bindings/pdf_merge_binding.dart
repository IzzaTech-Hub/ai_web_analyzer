import 'package:get/get.dart';

import '../controllers/pdf_merge_controller.dart';

class PdfMergeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PdfMergeController>(
      () => PdfMergeController(),
    );
  }
}
