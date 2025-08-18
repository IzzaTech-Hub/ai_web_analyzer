import 'dart:io';
import 'package:ai_web_analyzer/app/modules/pdf/pdf_view.dart';
import 'package:ai_web_analyzer/app/routes/app_pages.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:developer' as developer;
import 'package:ai_web_analyzer/app/routes/ad_navigator.dart';

class PdfHandler {
  static String pdfpath = '';
  static String pdfText = '';
  static RxBool isLoading = false.obs;
  Future<void> extractTextFromPDF1() async {
    try {
      // Pick a PDF file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      isLoading.value = true;

      if (result != null && result.files.single.path != null) {
        File pdfFile = File(result.files.single.path!);
        pdfpath = result.files.single.path!;
        print("PDF Selected: ${pdfFile.path}");

        // Load the PDF document
        List<int> bytes = await pdfFile.readAsBytes();
        PdfDocument document = PdfDocument(inputBytes: bytes);

        // Extract text from all pages
        String extractedText = PdfTextExtractor(document).extractText();
        pdfText = extractedText;

        // Close the document
        document.dispose();
        developer.log(pdfText);
        // Print extracted text (or display it in UI)
        AdNavigator.toNamed(const PDFView());
        print("Extracted Text:\n$extractedText");
      } else {
        print("No file selected");
      }
    } catch (e) {
      print("Error extracting text: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> extractTextFromPDF() async {
    isLoading.value = true;

    try {
      // Pick a PDF file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        String pdfPath = result.files.single.path!;
        pdfpath = pdfPath;
        print("📄 PDF Selected: $pdfPath");

        // Load the PDF document using Syncfusion
        File file = File(pdfPath);
        final PdfDocument document =
            PdfDocument(inputBytes: file.readAsBytesSync());

        List<String> formattedPages = []; // Store formatted text per page
        bool isScanned = false;

        for (int i = 0; i < document.pages.count; i++) {
          PdfTextExtractor extractor = PdfTextExtractor(document);
          String pageText =
              extractor.extractText(startPageIndex: i, endPageIndex: i);

          // Clean text: Remove extra spaces and blank lines
          // pageText = pageText.replaceAll(RegExp(r'\n\s*\n'), '\n').trim();
          pageText = pageText.replaceAll(RegExp(r'\n\s*\n'), ' ').trim();

          if (pageText.isNotEmpty) {
            formattedPages.add("📄 **Page ${i + 1}**\n$pageText");
          } else {
            isScanned = true;
            print("⚠️ Page ${i + 1} might be scanned, using OCR...");

            // Apply OCR (Extract text from image-based PDFs)
            String ocrText = await FlutterTesseractOcr.extractText(pdfPath);

            // Clean OCR text
            // ocrText = ocrText.replaceAll(RegExp(r'\n\s*\n'), '\n').trim();
            ocrText = ocrText.replaceAll(RegExp(r'\n\s*\n'), ' ').trim();

            formattedPages
                .add("📄 **Page ${i + 1} (OCR Extracted)**\n$ocrText");
          }
        }

        document.dispose(); // Clean up
        developer.log('ai pdf assistant');

        if (formattedPages.isEmpty) {
          Get.snackbar('Something Went wronge', 'Given file has no content');

          print("⚠️ No readable text found. The PDF might be encrypted.");
        } else {
          AdNavigator.toNamed(Routes.PDFVIEW);
          // AdNavigator.toNamed(const PDFView());

          String finalExtractedText =
              formattedPages.join("\n\n════════════════════════\n\n");
          pdfText = finalExtractedText;
          developer.log("✅ Extracted Text:\n$finalExtractedText");
        }
      } else {
        Get.snackbar('Something Went wronge', 'No File Selected');
      }
    } catch (e) {
      print("❌ Error extracting text: $e");
      Get.snackbar('Something Went wronge', 'Error while reading pdf data');
    } finally {
      isLoading.value = false;
    }
  }
}
