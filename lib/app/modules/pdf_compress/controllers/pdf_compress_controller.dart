// import 'package:get/get.dart';

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';

// import 'dart:io';
// import 'dart:typed_data';

// import 'package:dio/dio.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';

class PdfCompressController extends GetxController {
  File? selectedFile;
  File? compressedFile;
  double originalSize = 0;
  double compressedSize = 0;
  RxDouble reductionPercentage = 0.0.obs;
  RxBool isLoading = false.obs;
  RxBool isInfoGotten = false.obs;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      selectedFile = File(result.files.single.path!);
      compressedFile = null;
      originalSize = selectedFile!.lengthSync().toDouble();
      update();
    }
  }

  String getFileSize(double bytes, [int decimals = 2]) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    int i = (bytes == 0) ? 0 : (log(bytes) / log(1024)).floor();
    return "${(bytes / (1 << (10 * i))).toStringAsFixed(decimals)} ${suffixes[i]}";
  }

  Future<void> compressPdf() async {
    try {
      // print('connectivity');

      final connectivity = await Connectivity().checkConnectivity();
      // print(connectivity);
      // print(connectivity.length);
      // print(connectivity[0]);
      if (connectivity[0] == ConnectivityResult.none) {
        // print('failed');
        Get.snackbar('No Internet Connection',
            'Please Check your Internet Connectionand try again');
        // errorTitle = 'No Internet Connection';
        // errorString = 'Please Check Your Internet Connection and try again';
        // throw 'No internet connection';
        // throw ('wewe');
        return;
      }
    } catch (e) {
      Get.snackbar('No Internet Connection',
          'Please Check your Internet Connectionand try again');
      // print(e);
      return;
    }
    isLoading.value = true;
    isInfoGotten.value = false;
    if (selectedFile == null) return;
    try {
      isLoading.value = true;
      Dio dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ));

      String fileName = basename(selectedFile!.path);
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          selectedFile!.path,
          filename: fileName,
          contentType: MediaType('application', 'pdf'),
        ),
        'imageCompression': 'maximum',
      });

      Response response = await dio.post(
        'http://165.227.96.78:3001/api/pdf/compress',
        data: formData,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {'Accept': 'application/pdf'},
        ),
      );

      Uint8List pdfData = Uint8List.fromList(response.data);
      final dir = await getApplicationDocumentsDirectory();
      compressedFile = File('${dir.path}/compressed_${fileName}');
      await compressedFile!.writeAsBytes(pdfData);

      compressedSize = compressedFile!.lengthSync().toDouble();
      reductionPercentage.value =
          ((originalSize - compressedSize) / originalSize) * 100;
      isInfoGotten.value = true;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout) {
        Get.snackbar('Timeout Error',
            'Server did not respond in time. Please try again.');
      } else {
        Get.snackbar('Error', 'Failed to compress PDF: ${e.message}');
      }
    } catch (e) {
      Get.snackbar('Unexpected Error', e.toString());
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> saveCompressedFile(BuildContext context) async {
    if (compressedFile == null) return;

    String originalName = basename(selectedFile!.path);
    String defaultName =
        'CompressedPDF${DateTime.now().millisecondsSinceEpoch}.pdf';
    // String defaultName = 'compressed_$originalName';

    TextEditingController nameController =
        TextEditingController(text: defaultName);

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
      await savedFile.writeAsBytes(await compressedFile!.readAsBytes());
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




// class PdfCompressController extends GetxController {
 
// }
