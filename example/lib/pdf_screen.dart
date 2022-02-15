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
    Widget _floatingActionButton() => Column(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.add),
            ),
            SizedBox(
              height: 20,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.remove),
            ),
          ],
        );

    return Scaffold(
      floatingActionButton: _floatingActionButton(),
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text('Pdf Reader Plugin'),
      ),
      body: Container(
        color: Colors.blue,
        child: PdfView(
          filePath: pdfFilePath,
          spacing: 10,
          initialPage: 3,
        ),
      ),
    );
  }
}
