import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:ai_web_analyzer/app/routes/ad_navigator.dart';

class PdfscannerController extends GetxController {
  RxBool isGenerated = false.obs;
  RxBool isGenerating = false.obs;
  RxList<File> images = <File>[].obs;
  RxString filePath = ''.obs;
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromCamera() async {
    print('here');
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    print('here2');

    if (pickedFile != null) {
      print('here3');

      return File(pickedFile.path);
    }
    print('here4');

    return null;
  }

  Future<File?> pickImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  void onCameraTap() async {
    File? image = await pickImageFromCamera();
    if (image != null) {
      images.add(image);
      // print('Camera image picked: ${image.path}');
    }
  }

  void onGalleryTap() async {
    File? image = await pickImageFromGallery();
    if (image != null) {
      images.add(image);

      // print('Gallery image picked: ${image.path}');
    }
  }

  Future<Uint8List> generatePdfFromImages() async {
    List<File> imageFiles = images;
    final pdf = pw.Document();

    for (final imageFile in imageFiles) {
      final imageBytes = await imageFile.readAsBytes();
      final image = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image, fit: pw.BoxFit.contain),
            );
          },
        ),
      );
    }

    return await pdf.save();
  }

  createPdfFromImages() async {
    isGenerating.value = true;

    Uint8List pdfFileBytes = await generatePdfFromImages();
    // final dir = ;
    final dir = '/storage/emulated/0/Download';

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final path = '${dir}/scan_to_pdf_$timestamp.pdf';

    File pdfFile = File(path);
    filePath.value = pdfFile.path;
    // final file = File('${directory.path}/$outputFileName');

    await pdfFile.writeAsBytes(pdfFileBytes);

    print('File saved: ${pdfFile.path}');
    await Get.dialog(AlertDialog(
      title: Text('PDF Created Successful'),
      content: Text("File Saved to Downloads/scan_to_pdf_$timestamp.pdf"),
      // content: Text("File Saved to '$path'"),
      actions: [
        TextButton(
          onPressed: () => AdNavigator.back(), // Closes the dialog
          child: Text('OK'),
        ),
      ],
    ));
    isGenerating.value = false;

    isGenerated.value = true;
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
