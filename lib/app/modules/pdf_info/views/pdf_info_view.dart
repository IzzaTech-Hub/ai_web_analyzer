// import 'package:ai_web_analyzer/app/models/pdf_info_response';
import 'package:ai_web_analyzer/app/models/pdf_info_response.dart';
import 'package:ai_web_analyzer/app/utills/size_config.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:path/path.dart';
import '../controllers/pdf_info_controller.dart';
import 'package:ai_web_analyzer/app/routes/ad_navigator.dart';
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:your_app/api/pdf_api.dart'; // Update this with actual API location
// import 'package:your_app/model/pdf_info_response.dart'; // Update this with your model path

class PdfInfoView extends GetView<PdfInfoController> {
  Rx<PdfInfoResponse> pdfInfo = (PdfInfoResponse(
          title: 'title',
          author: 'author',
          subject: 'subject',
          keywords: 'keywords',
          creator: 'creator',
          producer: 'producer',
          pageCount: 0,
          textContent: 'textContent',
          fileSize: 'fileSize'))
      .obs;

  PdfInfoView({super.key});

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
            'PDF Info',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.red.shade700,
        ),
        body: SingleChildScrollView(
          child: GetBuilder<PdfInfoController>(
              builder: (controller) => Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          elevation: 2,
                          color: Colors.transparent,
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
                        Obx(() {
                          if (controller.selectedFile != null &&
                              !controller.isLoading.value &&
                              !controller.isgenerated.value) {
                            return Column(
                              children: [
                                // Container(height: 1,)
                                // const Spacer(),
                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.01,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    pdfInfo.value =
                                        await controller.getInfoFunction();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 32),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      backgroundColor: Colors.red.shade700),
                                  child: const Text(
                                    'Get PDF Info',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          if (controller.isLoading.value) {
                            return Column(
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 16),
                                Text(
                                  'Getting Info...',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            );
                          }

                          if (controller.isgenerated.value) {
                            return Card(
                              color: Colors.transparent,
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
                                  child: _buildPdfInfo(),
                                ),
                              ),
                            );
                          }

                          return const SizedBox();
                        }),

                        // Compress button (only visible when file is selected)
                      ],
                    ),
                  )),
        ));
  }

  Widget _buildPdfInfo() {
    return Column(
      children: [
        infoCard('Title', pdfInfo.value.title),
        infoCard('Author', pdfInfo.value.author),
        infoCard('Subject', pdfInfo.value.subject),
        infoCard('Creator', pdfInfo.value.creator),
        infoCard('Producer', pdfInfo.value.producer),
        infoCard('Number of Pages', pdfInfo.value.pageCount.toString()),
        infoCard('FileSize', pdfInfo.value.fileSize),
        // infoCard('Text Content', pdfInfo.value.textContent),
      ],
    );
  }

  Widget infoCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}

// class PdfInfoView extends StatefulWidget {
//   const PdfInfoView({super.key});

//   @override
//   State<PdfInfoView> createState() => _PdfInfoViewState();
// }

// class _PdfInfoViewState extends State<PdfInfoView> {
//   PdfInfoController controller = Get.put(PdfInfoController());
//   // PdfInfoController controller = Get.find();
//   File? selectedFile;
//   PdfInfoResponse? pdfInfo;
//   bool isLoading = false;

//   Future<void> pickFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null && result.files.single.path != null) {
//       final file = File(result.files.single.path!);
//       setState(() {
//         selectedFile = file;
//         pdfInfo = null;
//       });
//       await fetchPdfInfo(file);
//     }
//   }

//   Future<void> fetchPdfInfo(File file) async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final info = await controller.getInfoFunction(file);
//       setState(() {
//         pdfInfo = info;
//       });
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to fetch PDF info: $e');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Widget infoCard(String label, String value) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//       child: ListTile(
//         title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Text(value),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('PDF Info'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 20),
//           ElevatedButton.icon(
//             onPressed: pickFile,
//             icon: const Icon(Icons.upload_file),
//             label: const Text('Select PDF'),
//           ),
//           if (selectedFile != null)
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               child: Text(
//                 'File: ${selectedFile!.path.split('/').last}',
//                 style:
//                     const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               ),
//             ),
//           if (isLoading)
//             const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: CircularProgressIndicator(),
//             ),
//           if (pdfInfo != null) Expanded(child: _buildPdfInfo()),
//         ],
//       ),
//     );
//   }

//   Widget _buildPdfInfo() {
//     return ListView(
//       padding: const EdgeInsets.only(top: 8),
//       children: [
//         // infoCard('File Name', pdfInfo!.fileName ?? 'N/A'),
//         // infoCard('Size', '${(pdfInfo!.fileSizeInBytes! / 1024).toStringAsFixed(2)} KB'),
//         // infoCard('PDF Version', pdfInfo!.pdfVersion ?? 'N/A'),
//         infoCard('Title', pdfInfo!.title ?? 'N/A'),
//         infoCard('Author', pdfInfo!.author ?? 'N/A'),
//         infoCard('Subject', pdfInfo!.subject ?? 'N/A'),
//         infoCard('Creator', pdfInfo!.creator ?? 'N/A'),
//         infoCard('Producer', pdfInfo!.producer ?? 'N/A'),
//         infoCard('Number of Pages', pdfInfo!.pageCount?.toString() ?? 'N/A'),
//         infoCard('FileSize', pdfInfo!.fileSize ?? 'N/A'),

//         // infoCard('Created Date', pdfInfo!.creationDate ?? 'N/A'),
//         // infoCard('Modified Date', pdfInfo!.modificationDate ?? 'N/A'),
//       ],
//     );
//   }
// }
