import 'package:flutter/material.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class PdfScreen extends StatelessWidget {
  final String pdfFilePath;
  const PdfScreen(
    this.pdfFilePath, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text('Pdf Reader Plugin'),
      ),
      body: PdfView(path: pdfFilePath),
    );
  }
}
