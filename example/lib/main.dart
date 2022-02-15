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
  final sampleUrl = 'http://www.africau.edu/images/default/sample.pdf';

  String? pdfFilePath;

  Future<String> downloadAndSavePdf() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/sample.pdf');
    if (await file.exists()) {
      return file.path;
    }
    final response = await http.get(Uri.parse(sampleUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  Future<String?> loadPdfFromAssets() async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/bereshit.pdf');
    final byteData = await rootBundle.load('assets/bereshit.pdf');

    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    // if (await file.exists()) {
    return file.path;
    // }
  }

  void loadPdf(BuildContext context) async {
    // pdfFlePath = await downloadAndSavePdf();
    pdfFilePath = await loadPdfFromAssets();
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
      home: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            title: Text('Plugin example app'),
          ),
          body: Center(
            child: ElevatedButton(
              child: Text("Load pdf"),
              onPressed: ()=>loadPdf(context),
            ),
          ),
        );
      }),
    );
  }
}
