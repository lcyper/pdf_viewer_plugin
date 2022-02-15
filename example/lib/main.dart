import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'pdf_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final sampleUrl = 'http://www.africau.edu/images/default/sample.pdf';
  final sampleUrl =
      'https://www.uv.mx/personal/clelanda/files/2013/03/Aprender-a-buscar-en-Google.pdf';
  // https://www.adobe.com/content/dam/acom/en/devnet/pdf/pdfs/pdf_reference_archives/PDFReference.pdf

  String? pdfFilePath;

  Future<String> downloadAndSavePdf() async {
    // final directory = await getApplicationDocumentsDirectory();
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/sample.pdf');
    if (await file.exists()) {
      return file.path;
    }
    final response = await http.get(Uri.parse(sampleUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  Future<String> loadPdfFromAssets() async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/bereshit.pdf');
    if (await file.exists()) {
      return file.path;
    }
    final byteData = await rootBundle.load('assets/bereshit.pdf');

    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file.path;
  }

  void loadPdf(
    BuildContext context,
    Future<String> Function() function,
  ) async {
    // pdfFlePath = await downloadAndSavePdf();
    pdfFilePath = await function();
    if (pdfFilePath != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfScreen(pdfFilePath!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      home: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            title: Text('Plugin example app'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text("Load pdf from assets"),
                  onPressed: () => loadPdf(context, loadPdfFromAssets),
                ),
                ElevatedButton(
                  child: Text("Load pdf from internet"),
                  onPressed: () => loadPdf(context, downloadAndSavePdf),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
