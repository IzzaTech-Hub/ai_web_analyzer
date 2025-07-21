import 'package:get/get.dart';

import '../controllers/pdfscanner_controller.dart';

class PdfscannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PdfscannerController>(
      () => PdfscannerController(),
    );
  }
}
