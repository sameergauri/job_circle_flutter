import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/themes/colors.dart'; // Make sure to import the necessary package(s)

class CustomPDFViewerDialog extends StatelessWidget {
  final String pdfUrl;
  final Function()? onRemove;
  final Function()? onReplace;

  CustomPDFViewerDialog({
    required this.pdfUrl,
    this.onRemove,
    this.onReplace,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  if (onRemove != null) {
                    onRemove!();
                  }
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 4.h,
                    horizontal: 8.r,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Constants.themeBgColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        size: 15.h,
                        color: Constants.themeBgColor,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text("Remove"),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  if (onReplace != null) {
                    onReplace!();
                  }
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20.w),
                  padding: EdgeInsets.symmetric(
                    vertical: 4.h,
                    horizontal: 8.r,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Constants.themeBgColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.upload_file,
                        size: 15.h,
                        color: Constants.themeBgColor,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text("Replace"),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20.h),
          Container(
            height: 400.h, // Adjust the height as needed
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
          ),
        ],
      ),
    );
  }
}
