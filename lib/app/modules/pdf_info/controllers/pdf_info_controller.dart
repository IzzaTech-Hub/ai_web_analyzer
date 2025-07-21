import 'dart:io';
import 'dart:math';

import 'package:ai_web_analyzer/app/models/pdf_info_response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class PdfInfoController extends GetxController {
  File? selectedFile;
  File? compressedFile;
  double originalSize = 0;
  double compressedSize = 0;
  RxDouble reductionPercentage = 0.0.obs;
  RxBool isLoading = false.obs;
  RxBool isgenerated = false.obs;
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
      selectedFile = File(result.files.single.path!);
      compressedFile = null;
      originalSize = selectedFile!.lengthSync().toDouble();
      isgenerated.value = false;
      isLoading.value = false;
      update();
    }
  }
Future<PdfInfoResponse> getInfoFunction() async {
  try {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      Get.snackbar('No Internet Connection', 'Please check your internet and try again');
      return PdfInfoResponse(
        title: '', author: '', subject: '', keywords: '',
        creator: '', producer: '', pageCount: 0, textContent: '', fileSize: ''
      );
    }
  } catch (e) {
    print('Connectivity check failed: $e');
    return PdfInfoResponse(
      title: '', author: '', subject: '', keywords: '',
      creator: '', producer: '', pageCount: 0, textContent: '', fileSize: ''
    );
  }

  isLoading.value = true;

  try {
    File file = selectedFile!;
    Dio dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ));

    String fileName = basename(file.path);
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
        contentType: MediaType('application', 'pdf'),
      ),
    });

    Response response = await dio.post(
      'http://165.227.96.78:3001/api/pdf/info',
      data: formData,
      options: Options(
        headers: {'Accept': 'application/json'},
      ),
    );

    isgenerated.value = true;
    return PdfInfoResponse.fromJson(response.data);
  } on DioException catch (e) {
    if (e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionTimeout) {
      Get.snackbar('Timeout Error', 'Server did not respond in time. Please try again.');
    } else {
      Get.snackbar('Request Failed', 'Error: ${e.message}');
    }
  } catch (e) {
    Get.snackbar('Unexpected Error', e.toString());
  } finally {
    isLoading.value = false;
  }

  return PdfInfoResponse(
    title: '', author: '', subject: '', keywords: '',
    creator: '', producer: '', pageCount: 0, textContent: '', fileSize: ''
  );
}

  // Future<PdfInfoResponse> getInfoFunction() async {
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
  //       return PdfInfoResponse(title: '', author: '', subject: '', keywords: '', creator: '', producer: '', pageCount: 0, textContent: '', fileSize: '');
  //     }
  //   } catch (e) {
  //     print(e);
  //     // return;
  //   }
  //   isLoading.value = true;
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
  //   isLoading.value = false;

  //   return PdfInfoResponse.fromJson(response.data);
  // }
  

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
