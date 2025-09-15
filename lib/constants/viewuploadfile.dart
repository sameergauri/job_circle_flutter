// ignore_for_file: avoid_unnecessary_containers

// import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:job_circle/themes/colors.dart';
// Make sure to import the necessary package(s)

class CustomPDFViewerDialog extends StatelessWidget {
  final String pdfUrl;
  final Function()? onRemove;
  final Function()? onReplace;

  const CustomPDFViewerDialog({
    super.key,
    required this.pdfUrl,
    this.onRemove,
    this.onReplace,
  });

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: kToolbarHeight),
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
                backgroundColor: Constants.borderColor,
                child: const Icon(Icons.delete_outline_outlined,
                    color: Constants.darkBlue),
                onPressed: () {
                  if (onRemove != null) {
                    onRemove!();
                  }
                  Navigator.pop(context);
                }),
            body:SizedBox()/* Container(
              child: FutureBuilder<PDFDocument>(
                future: PDFDocument.fromURL(pdfUrl),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return PDFViewer(
                        scrollDirection: Axis.vertical,
                        panLimit: 1.1,
                        document: snapshot.data!,
                        zoomSteps: 3,
                        showNavigation: false,
                        showPicker: false,
                      );
                    } else {
                      return const Center(
                        child: Text('Failed to load PDF'),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ), */
          ),
        );
      },
    );
  }
}
