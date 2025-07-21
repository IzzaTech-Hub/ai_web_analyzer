import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

// import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'package:path_provider/path_provider.dart';

class PdfMergeController extends GetxController {
  File? selectedFile;
  File? mergedFile;
  double originalSize = 0;
  double compressedSize = 0;
  RxDouble reductionPercentage = 0.0.obs;
  RxBool isLoading = false.obs;
  RxBool isgenerated = false.obs;
  RxList<File> pdfFiles = (<File>[]).obs;
  String getFileSize(double bytes, [int decimals = 2]) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    int i = (bytes == 0) ? 0 : (log(bytes) / log(1024)).floor();
    return "${(bytes / (1 << (10 * i))).toStringAsFixed(decimals)} ${suffixes[i]}";
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      // selectedFile = File(result.files.single.path!);
      // pdfFiles.add(File(result.files.single.path!)) = File(result.files.single.path!);
      pdfFiles.add(File(result.files.single.path!));
      print(pdfFiles.length);
      mergedFile = null;
      originalSize = selectedFile!.lengthSync().toDouble();
      isgenerated.value = false;
      isLoading.value = false;
      update();
    }
  }
Future<void> mergePdfFiles() async {
  try {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      Get.snackbar('No Internet Connection', 'Please check your internet and try again');
      return;
    }
  } catch (e) {
    print('Connectivity error: $e');
    return;
  }

  isLoading.value = true;

  try {
    Dio dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ));

    List<File> pdfFile = pdfFiles;
    FormData formData = FormData();

    for (var file in pdfFile) {
      formData.files.add(MapEntry(
        'files',
        await MultipartFile.fromFile(
          file.path,
          filename: basename(file.path),
          contentType: MediaType('application', 'pdf'),
        ),
      ));
    }

    Response response = await dio.post(
      'http://165.227.96.78:3001/api/pdf/merge',
      data: formData,
      options: Options(
        responseType: ResponseType.bytes,
        headers: {'Accept': 'application/pdf'},
      ),
    );

    Uint8List pdfData = Uint8List.fromList(response.data);
    final dir = await getApplicationDocumentsDirectory();
    mergedFile = File('${dir.path}/merged_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await mergedFile!.writeAsBytes(pdfData);

    isgenerated.value = true;
  } on DioException catch (e) {
    if (e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionTimeout) {
      Get.snackbar('Timeout Error', 'Server did not respond in time. Please try again.');
    } else {
      Get.snackbar('Merge Failed', 'Something went wrong: ${e.message}');
    }
  } catch (e) {
    Get.snackbar('Unexpected Error', e.toString());
  } finally {
    isLoading.value = false;
  }
}

  // Future<void> mergePdfFiles() async {
  //   try {
  //     // print('connectivity');

  //     final connectivity = await Connectivity().checkConnectivity();
  //     // print(connectivity);
  //     // print(connectivity.length);
  //     // print(connectivity[0]);
  //     if (connectivity[0] == ConnectivityResult.none) {
  //       // print('failed');
  //       Get.snackbar('No Internet Connection',
  //           'Please Check your Internet Connectionand try again');
  //       // errorTitle = 'No Internet Connection';
  //       // errorString = 'Please Check Your Internet Connection and try again';
  //       // throw 'No internet connection';
  //       // throw ('wewe');
  //       return;
  //     }
  //   } catch (e) {
  //     print(e);
  //     // return;
  //   }
  //   isLoading.value = true;
  //   Dio dio = Dio();
  //   List<File> pdfFile = pdfFiles;
  //   FormData formData = FormData();

  //   // Add each file to the form data
  //   for (var file in pdfFile) {
  //     formData.files.add(MapEntry(
  //       'files',
  //       await MultipartFile.fromFile(
  //         file.path,
  //         filename: basename(file.path),
  //         contentType: MediaType('application', 'pdf'),
  //       ),
  //     ));
  //   }

  //   Response response = await dio.post(
  //     'http://165.227.96.78:3001/api/pdf/merge',
  //     data: formData,
  //     options: Options(
  //       responseType: ResponseType.bytes, // Simple bytes response like compress
  //       headers: {
  //         'Accept': 'application/pdf',
  //       },
  //     ),
  //   );

  //   // Uint8List mergedPdfData = Uint8List.fromList(response.data);
  //   Uint8List pdfData = Uint8List.fromList(response.data);
  //   final dir = await getApplicationDocumentsDirectory();
  //   mergedFile = File(
  //       '${dir.path}/merged_file${DateTime.now().millisecondsSinceEpoch}.pdf');
  //   await mergedFile!.writeAsBytes(pdfData);
  //   isLoading.value = false;
  //   isgenerated.value = true;
  //   print(mergedFile);
  //   // final dir = await getApplicationDocumentsDirectory();
  //   // final mergedFile = File('${dir.path}/merged_output.pdf');
  //   // await mergedFile.writeAsBytes(mergedPdfData);

  //   // print('Merged PDF saved at: ${mergedFile.path}');
  // }

  // Future<PdfInfoResponse> getInfoFunction() async {
  //   // Future<PdfInfoResponse> getInfoFunction(File file) async {
  //   print('object');
  //   File file = selectedFile!;
  //   Dio dio = Dio();

  //   String fileName = basename(file.path);
  //   FormData formData = FormData.fromMap({
  //     'file': await MultipartFile.fromFile(
  //       file.path,
  //       filename: fileName,
  //       contentType: MediaType('application', 'pdf'),
  //     ),
  //   });

  //   Response response = await dio.post(
  //     'http://165.227.96.78:3001/api/pdf/info',
  //     data: formData,
  //     options: Options(
  //       headers: {
  //         'Accept': 'application/json',
  //       },
  //     ),
  //   );
  //   isgenerated.value = true;
  //   return PdfInfoResponse.fromJson(response.data);
  // }
  Future<void> saveMergedFile(BuildContext context) async {
    if (mergedFile == null) return;
    // print('mergedllFile');

    // String originalName = basename(selectedFile!.path);
    String defaultName =
        'MergedPDF${DateTime.now().millisecondsSinceEpoch}.pdf';
    // print('mergedlFile');

    TextEditingController nameController =
        TextEditingController(text: defaultName);
    // print('mergedFile');

    String? fileName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Save As'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'File Name'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, nameController.text),
              child: Text('Save')),
        ],
      ),
    );

    if (fileName != null && fileName.trim().isNotEmpty) {
      // final dir = await getApplicationDocumentsDirectory();
      final dir = Directory('/storage/emulated/0/Download');

      print(dir.path);
      File savedFile = File('${dir.path}/$fileName');
      await savedFile.writeAsBytes(await mergedFile!.readAsBytes());
      Get.snackbar('Success', 'File saved as $fileName');
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
