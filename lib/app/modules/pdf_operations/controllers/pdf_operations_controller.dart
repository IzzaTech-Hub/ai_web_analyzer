import 'dart:convert';
import 'dart:io';

import 'package:ai_web_analyzer/app/providers/admob_ads_provider.dart';
import 'package:ai_web_analyzer/app/routes/app_pages.dart';
import 'package:ai_web_analyzer/app/utills/remoteconfig_variables.dart';
import 'package:ai_web_analyzer/operation_card.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:ai_web_analyzer/app/routes/ad_navigator.dart';

class PdfOperationsController extends GetxController {
  File? pdfFile;
  String? path;
  String? ext;
  RxBool isgenerating = false.obs;
  pdfConverter() async {
    // Check connectivity
    // var connectivity;
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
      print(e);
      // return;
    }

    isgenerating.value = true;
    if (!await pickfile()) {
      isgenerating.value = false;

      return;
    }
    ext = await showConvertToDialog();
    if (ext == null) {
      isgenerating.value = false;

      return;
    }
    path = generateConvertedFilePath(ext!);
    await convertPdf();
    isgenerating.value = false;
  }

  Future<void> quickConvert(String targetExt) async {
    try {
      // Connectivity check
      try {
        final connectivity = await Connectivity().checkConnectivity();
        if (connectivity[0] == ConnectivityResult.none) {
          Get.snackbar('No Internet Connection',
              'Please Check your Internet Connectionand try again');
          return;
        }
      } catch (e) {
        // ignore connectivity check failures
      }

      isgenerating.value = true;
      if (!await pickfile()) {
        isgenerating.value = false;
        return;
      }
      ext = targetExt;
      path = generateConvertedFilePath(ext!);
      await convertPdf();
    } finally {
      isgenerating.value = false;
    }
  }

  Future<bool> pickfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    // final dir = await getApplicationDocumentsDirectory();

    // final dir = result!.files.single.path;
    // print('Directory is : ${dir.path}');
    if (result == null || result.files.single.path == null) {
      Get.snackbar('No File Selected', 'Please Select a valid file');
      // pdfFile=File
      return false;
    } else {
      pdfFile = File(result.files.single.path!);
      return true;
    }
    // return pdfFile;
    // return;
    // return result;
  }

  Future<String?> showConvertToDialog() async {
    return Get.dialog<String>(
      AlertDialog(
        title: Text('Convert To'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconOption(
                  icon: Icons.slideshow,
                  label: 'PowerPoint',
                  color: Colors.red.shade700,
                  value: 'pptx',
                ),
                _buildIconOption(
                  icon: Icons.image,
                  label: 'Images',
                  color: Colors.purple,
                  value: 'jpeg',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconOption(
                  icon: Icons.description,
                  label: 'Word',
                  color: Colors.blue.shade400,
                  value: 'docx',
                ),
                _buildIconOption(
                  icon: Icons.grid_on,
                  label: 'Excel',
                  color: Colors.green,
                  value: 'xlsx',
                ),
                _buildIconOption(
                  icon: Icons.text_snippet_outlined,
                  label: 'RTF',
                  color: Colors.blue.shade900,
                  value: 'rtf',
                ),

                // _buildIconOption(
                //   icon: Icons.text_fields_outlined,
                //   label: 'Text',
                //   color: Colors.black87,
                //   value: 'txt',
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String generateConvertedFilePath(String ext) {
    File file = pdfFile!;
    String newName;
    final originalName = p.basenameWithoutExtension(file.path);
    final dir = '/storage/emulated/0/Download';
    // final dir = p.dirname(file.path);
    //  Directory('/storage/emulated/0/Download');
    print(dir);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    if (ext == 'jpeg') {
      newName = '${originalName}_${timestamp}IMG';
    } else {
      newName = 'converted_${originalName}_$timestamp.$ext';
    }
    return p.join(dir, newName);
  }

  // Future<File?>
  Future<void> convertPdf(
      //   {
      //   required File pdfFile,
      //   required String targetFormat,
      //   required String name,
      // }
      ) async {
    String apiKey = RCVariables.clientId;
    String clientId = RCVariables.clientId;
    String clientSecret = RCVariables.clientSecret;
    // final String outputFileName = '$name.$targetFormat';

    try {
      // 1. Get OAuth token
      final tokenResponse = await http.post(
        Uri.parse('https://pdf-services.adobe.io/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'client_id': clientId, 'client_secret': clientSecret},
      );
      if (tokenResponse.statusCode != 200)
        throw Exception('Failed to get token');
      final token = jsonDecode(tokenResponse.body)['access_token'];

      // 2. Upload the PDF
      final createAssetResponse = await http.post(
        Uri.parse('https://pdf-services.adobe.io/assets'),
        headers: {
          'Authorization': 'Bearer $token',
          'x-api-key': apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'mediaType': 'application/pdf'}),
      );
      if (createAssetResponse.statusCode != 200)
        throw Exception('Asset creation failed');
      final assetData = jsonDecode(createAssetResponse.body);
      final uploadUri = assetData['uploadUri'];
      final assetID = assetData['assetID'];

      final uploadResponse = await http.put(
        Uri.parse(uploadUri),
        headers: {'Content-Type': 'application/pdf'},
        body: pdfFile!.readAsBytesSync(),
      );

      // 3. Start conversion
      // final convertResponse = await http.post(
      //   // Uri.parse('https://pdf-services.adobe.io/operation/pdftoimages'),

      //   Uri.parse('https://pdf-services.adobe.io/operation/pdftoimages'),
      //   headers: {
      //     'Authorization': 'Bearer $token',
      //     'x-api-key': apiKey,
      //     'Content-Type': 'application/json',
      //   },
      //   body: jsonEncode({
      //     'assetID': assetID,
      //     'targetFormat': ext,
      //     "outputType": "listOfPageImages"
      //     // "outputType": "zipOfPageImages"
      //   }),
      // );
      // print(ext);

      final convertResponse = await http.post(
        // Uri.parse('https://pdf-services.adobe.io/operation/pdftoimages'),
        ext != 'jpeg'
            ? Uri.parse('https://pdf-services.adobe.io/operation/exportpdf')
            : Uri.parse('https://pdf-services.adobe.io/operation/pdftoimages'),
        headers: {
          'Authorization': 'Bearer $token',
          'x-api-key': apiKey,
          'Content-Type': 'application/json',
        },
        body: ext == 'jpeg'
            ? jsonEncode({
                'assetID': assetID,
                'targetFormat': ext,
                "outputType": "listOfPageImages"
                // "outputType": "zipOfPageImages"
              })
            : jsonEncode({
                'assetID': assetID,
                'targetFormat': ext,
                // "outputType": "ListOfPageImages"
                // "outputType": "zipOfPageImages"
              }),
      );
      print('statusCheck.statusCode');
      print(convertResponse.statusCode);
      print('statusCheck.body');
      print(convertResponse.body);
      print('statusCheck.headers');
      print(convertResponse.headers);
      final location = convertResponse.headers['location'];
      if (location == null) throw Exception('No status location provided');

      // 4. Poll for conversion result
      List<String> downloadUri = [];
      while (true) {
        await Future.delayed(Duration(seconds: 2));
        final statusCheck = await http.get(
          Uri.parse(location),
          headers: {'Authorization': 'Bearer $token', 'x-api-key': apiKey},
        );
        // print('statusCheck.statusCode');
        // print(statusCheck.statusCode);
        // print('statusCheck.body');
        // print(statusCheck.body);
        // print('statusCheck.headers');
        // print(statusCheck.headers);
        final statusJson = jsonDecode(statusCheck.body);
        if (statusJson['status'] == 'done') {
          if (ext != 'jpeg') {
            downloadUri = [statusJson['asset']['downloadUri']];
          } else {
            // downloadUri = statusJson['assetList'][0]['downloadUri'];
            for (var asset in statusJson['assetList']) {
              downloadUri.add(asset['downloadUri']);
            }
          }
          // downloadUri = statusJson['assetList'][0]['downloadUri'];
          break;
        } else if (statusJson['status'] == 'failed') {
          throw Exception('Conversion failed: ${statusJson['error']}');
        }
      }

      // 5. Download and save
      if (ext == 'jpeg') {
        for (int i = 0; i < downloadUri.length; i++) {
          final uri = Uri.parse(downloadUri[i]);
          final response = await http.get(uri);
          // final path = (await getApplicationDocumentsDirectory()).path;

          final fileName = '${i + 1}.jpeg';
          final filePath = '$path$fileName';

          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);
          print('File saved: $filePath');
        }

        // Show success dialog after all files are downloaded
        Get.dialog(AlertDialog(
          title: Text('Files Converted Successfully'),
          content: Text("Images saved to Gallery"),
          actions: [
            TextButton(
              onPressed: () => AdNavigator.back(),
              child: Text('OK'),
            ),
          ],
        ));
      } else {
        final resultResponse = await http.get(Uri.parse(downloadUri[0]));
        // final directory = await getApplicationDocumentsDirectory();
        final file = File(path!);
        // final file = File('${directory.path}/$outputFileName');
        await file.writeAsBytes(resultResponse.bodyBytes);
        print('File saved: ${file.path}');
        Get.dialog(AlertDialog(
          title: Text('File Converted Successfully'),
          content: Text("File Saved to Downloads"),
          // content: Text("File Saved to '$path'"),
          actions: [
            TextButton(
              onPressed: () => AdNavigator.back(), // Closes the dialog
              child: Text('OK'),
            ),
          ],
        ));
      }
      // return file;
    } catch (e) {
      Get.dialog(AlertDialog(
        title: Text('File Conversion Failed'),
        content: Text("Please check your Internet Connection"),
        actions: [
          TextButton(
            onPressed: () => AdNavigator.back(), // Closes the dialog
            child: Text('OK'),
          ),
        ],
      ));
      print('Error during PDF conversion: $e');
      return null;
    }
  }

  final List<PdfOperation> operations = [
    // PdfOperation(
    //   id: 'mine',
    //   name: 'PDF Mine',
    //   description: 'Extract metadata and details from your PDF document',
    //   iconName: 'info',
    //   route: 'mine',
    // ),
    PdfOperation(
      id: 'pdf_info',
      name: 'PDF Information',
      description: 'Extract metadata and details from your PDF document',
      iconName: 'info',
      route: Routes.PDF_INFO,
    ),
    PdfOperation(
      id: 'pdf_merge',
      name: 'Merge PDFs',
      description: 'Combine multiple PDF files into a single document',
      iconName: 'merge',
      route: Routes.PDF_MERGE,
    ),
    // PdfOperation(
    //   id: 'pdf_split',
    //   name: 'Split PDF',
    //   description: 'Split a PDF into individual pages or custom ranges',
    //   iconName: 'split',
    //   route: 'pdf_split',
    // ),
    // PdfOperation(
    //   id: 'pdf_extract',
    //   name: 'Extract Pages',
    //   description: 'Extract specific pages from a PDF document',
    //   iconName: 'extract',
    //   route: 'pdf_extract',
    // ),
    // PdfOperation(
    //   id: 'pdf_rotate',
    //   name: 'Rotate Pages',
    //   description: 'Rotate specific pages in your PDF document',
    //   iconName: 'rotate',
    //   route: 'pdf_rotate',
    // ),
    PdfOperation(
      id: 'pdf_compress',
      name: 'Compress PDF',
      description: 'Reduce PDF file size while preserving quality',
      iconName: 'compress',
      route: Routes.PDF_COMPRESS,
    ),
    // PdfOperation(
    //   id: 'pdf_to_word',
    //   name: 'PDF to Word',
    //   description: 'Convert PDF documents to editable Word format',
    //   iconName: 'convert_word',
    //   route: 'pdf_to_word',
    // ),
    // PdfOperation(
    //   id: 'docx_to_pdf',
    //   name: 'Word to PDF',
    //   description: 'Convert Word documents to PDF format',
    //   iconName: 'convert_pdf',
    //   route: 'docx_to_pdf',
    // ),
  ];

  Widget _buildIconOption({
    required IconData icon,
    required String label,
    required Color color,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: color, size: 36),
          onPressed: () {
            AdNavigator.back(result: value);
          },
        ),
        Text(label),
      ],
    );
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
