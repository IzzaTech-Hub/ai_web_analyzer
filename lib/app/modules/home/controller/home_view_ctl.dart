import 'package:ai_web_analyzer/app/models/ai_handler.dart';
import 'package:ai_web_analyzer/app/models/pdf_handler.dart';
import 'package:ai_web_analyzer/app/models/url_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_web_analyzer/app/routes/app_pages.dart';

import 'package:http/http.dart' as http;

class HomeViewCTL extends GetxController {
  final TextEditingController searchController = TextEditingController();

  void goToUrl() async {
    final url = searchController.text.trim();

    if (url.isEmpty) {
      Get.snackbar("Error", "URL cannot be empty",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    Uri? uri = Uri.tryParse(url);
    if (uri == null || !uri.isAbsolute) {
      Get.snackbar("Invalid URL", "Please enter a valid URL",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white);
      return;
    }

    try {
      // Show loading snackbar
      // Get.snackbar("Checking URL", "Verifying if the webpage is accessible...",
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.blue,
      //     colorText: Colors.white,
      //     duration: Duration(seconds: 2));

      // Send an HTTP request to check if the webpage is accessible
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // URL is accessible, proceed
        AiHandler.chattype = 'url';
        UrlHandler.url = url;
        Get.toNamed(Routes.URLVIEW);
      } else {
        // Page exists but not accessible (403, 404, 500, etc.)
        Get.snackbar(
            "Error", "The webpage returned status code ${response.statusCode}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      // Error connecting to the server (DNS issues, no internet, etc.)
      Get.snackbar("Connection Error",
          "Could not reach the webpage. Please check your internet or URL.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }

    if (!Uri.parse(url).isAbsolute) {
      Get.snackbar("Invalid URL", "Please enter a valid URL",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white);
      return;
    }
    // AiHandler.chattype = 'url';

    // UrlHandler.url = url;
    // Get.toNamed(Routes.URLVIEW);
  }

  Future<void> goToPdf() async {
    // try {
    //   // Open file picker to select a PDF
    //   FilePickerResult? result = await FilePicker.platform.pickFiles(
    //     type: FileType.custom,
    //     allowedExtensions: ['pdf'],
    //   );

    //   if (result != null) {
    //     File pdfFile = File(result.files.single.path!);
    //     print("PDF Selected: ${pdfFile.path}");
    //     PdfHandler.pdfpath = pdfFile.path;
    //     Get.toNamed(Routes.PDFVIEW);

    //     // Here, you can upload the file to your server or process it
    //     // Example: Upload function -> uploadPDF(pdfFile);
    //   } else {
    //     print("No file selected");
    //   }
    // } catch (e) {
    //   print("Error picking file: $e");
    // }
    AiHandler.chattype = 'pdf';
    PdfHandler().extractTextFromPDF();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}

// class CustomTextSelectionControls extends MaterialTextSelectionControls {
//   @override
//   Color getHandleColor(BuildContext context) {
//     return Colors.white; // Change handle color to white
//   }
// }
