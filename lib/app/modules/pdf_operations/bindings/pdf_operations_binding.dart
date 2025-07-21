import 'package:get/get.dart';

import '../controllers/pdf_operations_controller.dart';

class PdfOperationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PdfOperationsController>(
      () => PdfOperationsController(),
    );
  }
}
