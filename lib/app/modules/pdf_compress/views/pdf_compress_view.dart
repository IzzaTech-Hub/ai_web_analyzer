import 'package:ai_web_analyzer/app/routes/ad_navigator.dart';
import 'package:ai_web_analyzer/app/utills/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import '../controllers/pdf_compress_controller.dart';
// import '../routes/ad_navigator.dart';

class PdfCompressView extends GetView<PdfCompressController> {
  const PdfCompressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              AdNavigator.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
        title: const Text(
          'PDF Compressor',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.red.shade700,
      ),
      body: GetBuilder<PdfCompressController>(
        builder: (controller) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // File selection card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade50, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.red.shade100, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(Icons.picture_as_pdf,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () => controller.pickFile(),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black45,
                                      offset: Offset(2, 2),
                                      blurRadius: 1)
                                ]),
                            height: 48,
                            width: SizeConfig.screenWidth * 0.45,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.attach_file,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  'Select PDF File',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (controller.selectedFile != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Column(
                              children: [
                                Text(
                                  '${basename(controller.selectedFile!.path)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${controller.getFileSize(controller.selectedFile!.lengthSync().toDouble())}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Compression section
              Obx(() {
                if (controller.isLoading.value) {
                  return Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Compressing PDF...',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  );
                }

                if (controller.isInfoGotten.value) {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red.shade50, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(color: Colors.red.shade100, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Compression Results',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Compressed file Size: ${controller.getFileSize(controller.compressedSize)}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Size Reduction'),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${controller.reductionPercentage.toStringAsFixed(2)}%',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.grey[300],
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Status'),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Success',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            LinearProgressIndicator(
                              value: controller.reductionPercentage.value / 100,
                              minHeight: 10,
                              borderRadius: BorderRadius.circular(5),
                              backgroundColor: Colors.grey[200],
                              color: Colors.green,
                            ),
                            const SizedBox(height: 24),
                            InkWell(
                              onTap: () =>
                                  controller.saveCompressedFile(context),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black45,
                                          offset: Offset(2, 2),
                                          blurRadius: 1)
                                    ]),
                                height: 48,
                                // width: 274,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.save,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Text(
                                      'Save Compressed PDF',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return const SizedBox();
              }),

              // const Spacer(),
              SizedBox(height: SizeConfig.screenHeight * 0.01),

              // Compress button (only visible when file is selected)
              if (controller.selectedFile != null &&
                  !controller.isLoading.value &&
                  controller.compressedFile == null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 94),
                  child: ElevatedButton(
                    onPressed: controller.compressPdf,
                    style: ElevatedButton.styleFrom(
                        // padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.red.shade700),
                    child: const Text(
                      'Compress PDF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
