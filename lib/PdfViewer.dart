
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatelessWidget {
  File? file;
  PdfViewer({super.key,required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SfPdfViewer.file(
            file!));
  }
}



