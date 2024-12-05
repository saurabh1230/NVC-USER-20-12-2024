import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfPreviewScreen extends StatelessWidget {
  final Uint8List pdfData;

  const PdfPreviewScreen({Key? key, required this.pdfData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Preview")),
      body: PDFView(
        pdfData: pdfData,
      ),
    );
  }
}
