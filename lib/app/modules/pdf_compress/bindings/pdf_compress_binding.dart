import 'package:get/get.dart';

import '../controllers/pdf_compress_controller.dart';

class PdfCompressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PdfCompressController>(
      () => PdfCompressController(),
    );
  }
}
