// import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class PdfViewerDialog extends StatelessWidget {
  final String assetPath;

  const PdfViewerDialog({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            SizedBox() /*  FutureBuilder<PDFDocument>(
        future: PDFDocument.fromAsset(assetPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return PDFViewer(
                document: snapshot.data!,
                scrollDirection: Axis.vertical,
                panLimit: 1.1,
                zoomSteps: 3,
                showNavigation: false,
                showPicker: false,
              );
            } else {
              return const Center(child: Text('Failed to load PDF'));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ), */
        );
  }
}
