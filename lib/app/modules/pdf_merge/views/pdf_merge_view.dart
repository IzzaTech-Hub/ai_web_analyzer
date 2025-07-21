import 'package:ai_web_analyzer/app/utills/size_config.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pdf_merge_controller.dart';
import 'package:path/path.dart';
import 'package:ai_web_analyzer/app/routes/ad_navigator.dart';

class PdfMergeView extends GetView<PdfMergeController> {
  const PdfMergeView({super.key});
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
            'PDF Merger',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.red.shade700,
        ),
        body: SingleChildScrollView(
          child: GetBuilder<PdfMergeController>(
              builder: (controller) => Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                              border: Border.all(
                                  color: Colors.red.shade100, width: 1),
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
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black45,
                                                offset: Offset(2, 2),
                                                blurRadius: 1)
                                          ]),
                                      height: 48,
                                      width: SizeConfig.screenWidth * 0.45,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                            style:
                                                TextStyle(color: Colors.white),
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
                        Obx(() => Column(children: [
                              if (controller.isLoading.value)
                                Column(
                                  children: [
                                    const CircularProgressIndicator(),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Merging PDFs...',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),

                              if (controller.pdfFiles.length > 0 &&
                                  !controller.isgenerated.value)
                                Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    height: SizeConfig.screenHeight * 0.5,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.red.shade50,
                                          Colors.white
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Colors.red.shade100, width: 1),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: ListView.builder(
                                        itemCount: controller.pdfFiles.length,
                                        itemBuilder: (context, index) {
                                          final file = controller.pdfFiles[
                                              index]; // Assuming it's a File object

                                          return Card(
                                            elevation: 3,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: ListTile(
                                              leading: IconButton(
                                                  onPressed: () {
                                                    controller.pdfFiles
                                                        .removeAt(index);
                                                  },
                                                  icon: Icon(Icons.delete)),
                                              title: Text(
                                                file.path
                                                    .split('/')
                                                    .last, // Name of the file
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                controller.getFileSize(file
                                                    .lengthSync()
                                                    .toDouble()), // File size nicely formatted
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              if (controller.isgenerated.value)
                                Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.red.shade50,
                                          Colors.white
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Colors.red.shade100, width: 1),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'File Merged',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            'File Size: ${controller.getFileSize(controller.mergedFile!.lengthSync().toDouble())}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          const SizedBox(height: 24),
                                          InkWell(
                                            onTap: () {
                                              controller
                                                  .saveMergedFile(context);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black45,
                                                        offset: Offset(2, 2),
                                                        blurRadius: 1)
                                                  ]),
                                              height: 48,
                                              // width: 274,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.save,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 16,
                                                  ),
                                                  Text(
                                                    'Save Merged PDF',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              if (controller.pdfFiles.length >= 2 &&
                                  !controller.isLoading.value &&
                                  controller.mergedFile == null)
                                Column(
                                  children: [
                                    SizedBox(
                                        height: SizeConfig.screenHeight * 0.03),
                                    ElevatedButton(
                                      onPressed: () async {
                                        // pdfInfo.value =
                                        await controller.mergePdfFiles();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 32),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          backgroundColor: Colors.red.shade700),
                                      child: const Text(
                                        'Merge All',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                              // return const SizedBox();
                            ])),

                        // Compress button (only visible when file is selected)
                      ],
                    ),
                  )),
        ));
  }
}
