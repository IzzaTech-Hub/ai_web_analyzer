import 'package:ai_web_analyzer/app/models/pdf_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_web_analyzer/app/modules/chat/chat_view.dart';
import 'package:ai_web_analyzer/app/modules/webview/web_view.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFScreenView extends StatefulWidget {
  const PDFScreenView({super.key});

  @override
  State<PDFScreenView> createState() => _PDFScreenViewState();
}

class _PDFScreenViewState extends State<PDFScreenView>
    with AutomaticKeepAliveClientMixin {
  final RxBool isChatFullscreen =
      true.obs; // Controls which view is full-screen

  @override
  final String pdfPath = PdfHandler.pdfpath;

  @override
  bool get wantKeepAlive => true; // ✅ Keeps WebView in memory

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PDFView(
        filePath: pdfPath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageSnap: true,
        fitPolicy: FitPolicy.BOTH,
      ),
    );
  }
}

class PDFUploader extends StatefulWidget {
  @override
  _PDFUploaderState createState() => _PDFUploaderState();
}

class _PDFUploaderState extends State<PDFUploader> {
  String? _pdfPath; // Stores the selected PDF file path

  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _pdfPath = result.files.single.path;
      });

      // Navigate to PDF viewer screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(pdfPath: _pdfPath!),
        ),
      );
    } else {
      print("No file selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF Uploader")),
      body: Center(
        child: ElevatedButton(
          onPressed: pickPDF,
          child: Text("Select & View PDF"),
        ),
      ),
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String pdfPath;

  const PDFViewerScreen({required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF Viewer")),
      body: PDFView(
        filePath: pdfPath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageSnap: true,
        fitPolicy: FitPolicy.BOTH,
      ),
    );
  }
}
