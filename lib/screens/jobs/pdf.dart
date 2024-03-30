// ignore_for_file: unused_field, deprecated_member_use, unused_element, unused_result, avoid_print, use_build_context_synchronously
// ignore_for_file: todo
import 'dart:io';

import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/customDialogue.dart';
import 'package:job_circle/constants/customdialogue_for_call_whatsapp.dart';
import 'package:job_circle/models/changeStatusModel.dart';
import 'package:job_circle/screens/jobs/Interview_bay_cc.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class PDFViewerScreen extends ConsumerStatefulWidget {
  final String pdfAssetPath;
  final int phoneNumber1, phoneNumber2;
  final bool isref;
  final String name;
  final int isCvDownloaded;
  final int? id;
  final bool? isCC;

  const PDFViewerScreen(
      {super.key,
      required this.pdfAssetPath,
      required this.phoneNumber1,
      required this.phoneNumber2,
      required this.isref,
      required this.name,
      required this.isCvDownloaded,
      this.id,
      this.isCC});

  @override
  ConsumerState<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends ConsumerState<PDFViewerScreen> {
  Future<void> _makePhoneCall() async {
    String number = "+911234567890"; // Replace with the desired phone number
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    if (!res!) {
      // Handle call failed
    }
  }

  Future<void> _openWhatsApp() async {
    String number = "+911234567890"; // Replace with the desired WhatsApp number
    Uri url = Uri.parse("whatsapp://send?phone=$number");
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      // Handle WhatsApp not installed
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      _makePhoneCall();
    } else if (index == 1) {
      _openWhatsApp();
    }
  }

  Future<void> apicallfunction() async {
    NewChangeStatusModel changeStatusModel =
        NewChangeStatusModel(isCvDownload: 1);
    Map<String, dynamic> jsonData = changeStatusModel.toJson();
    try {
      await JobPostApiService.CvDowloadDone(jsonData, widget.id!.toInt());
      ref.refresh(fetchAllApplicantProvider);
    } catch (e) {
      print('Error: $e');
      // Handle error...
    }
  }

  //TODO:: Download pdf option..

  PDFDocument? _pdfDocument;
  final bool _isDownloaded = false;

  // Function to download the PDF
  Future<void> downloadFileToDownloadsFolder(
      String url, String fileName) async {
    // Construct the file path in the downloads directory
    final filePath = '/storage/emulated/0/Download/$fileName';

    // Save the file to the downloads directory
    final file = File(filePath);
    try {
      // Send a GET request to the URL
      var response = await http.get(Uri.parse(url));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Get the downloads directory

        await file.writeAsBytes(response.bodyBytes);
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return WillPopScope(
              onWillPop: () async {
                // Define your custom logic here to determine whether the dialog should close or not.
                // Return true to allow the dialog to close or false to prevent it from closing.
                return false; // Change this as needed.
              },
              child: CustomDialog(
                  fetchDataFromApi: () {},
                  onClose: () {
                    // ref.refresh(fetchAllApplicantProvider);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    ref.refresh(fetchAllApplicantProvider);
                  },
                  isFisrt: false,
                  title: "CV downloaded",
                  subtitle: "Path : /Download/$fileName"),
            );
          },
        );
        await apicallfunction();
        print('File saved to Downloads folder: $filePath');
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return WillPopScope(
              onWillPop: () async {
                // Define your custom logic here to determine whether the dialog should close or not.
                // Return true to allow the dialog to close or false to prevent it from closing.
                return false; // Change this as needed.
              },
              child: CustomDialog(
                  fetchDataFromApi: () {},
                  onClose: () {
                    // ref.refresh(fetchAllApplicantProvider);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    ref.refresh(fetchAllApplicantProvider);
                  },
                  isFisrt: false,
                  title: "Fail!",
                  subtitle: "CV Not downlaoded due to some technical fault."),
            );
          },
        );
        // Handle the error if the request was not successful
        print('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error downloading file: $e');
    }
  }

  //TODO:: Download pdf option..

  @override
  Widget build(BuildContext context) {
    String fileUrl =
        'https://s3.ap-south-1.amazonaws.com/job-circle-2/${widget.pdfAssetPath}';
    String fileName = "${widget.name}_cv.pdf";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'PDF Viewer',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          if (widget.isref != true &&
              widget.isCvDownloaded != 1 &&
              widget.isCC != null &&
              widget
                  .isCC!) // Show download button if PDF is loaded and not downloaded yet
            IconButton(
                icon: const Icon(
                  Icons.download,
                  color: Constants.blue,
                ),
                onPressed: () async {
                  await downloadFileToDownloadsFolder(fileUrl, fileName);
                  ref.refresh(fetchAllApplicantProvider);
                }),
        ],
      ),
      /*  appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'PDF Viewer',
          style: TextStyle(color: Colors.black),
        ),
      ), */
      floatingActionButton: widget.isref != true
          ? widget.phoneNumber2 == 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      mini: true,
                      backgroundColor: Colors.green[900],
                      onPressed: () async {
                        Uri url = Uri.parse(
                            "whatsapp://send?phone=91${widget.phoneNumber1}");
                        await canLaunchUrl(url)
                            ? await launchUrl(url)
                            : throw "could not launch $url";
                      },
                      child: Icon(
                        Icons.sms_outlined,
                        size: 18.h,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    FloatingActionButton(
                      mini: true,
                      onPressed: () {
                        FlutterPhoneDirectCaller.callNumber(
                            "+91${widget.phoneNumber1}");
                      },
                      child: Icon(
                        Icons.call,
                        size: 18.h,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomFloatCall(
                      isCall: false,
                      phoneNumber1: widget.phoneNumber1,
                      phoneNumber2: widget.phoneNumber2,
                    ),
                    const SizedBox(
                        width: 10), // Add some spacing between the buttons
                    CustomFloatCall(
                      isCall: true,
                      phoneNumber1: widget.phoneNumber1,
                      phoneNumber2: widget.phoneNumber2,
                    ),
                  ],
                )
          : const SizedBox(),
      body: FutureBuilder<PDFDocument>(
        future: PDFDocument.fromURL(
            "https://s3.ap-south-1.amazonaws.com/job-circle-2/${widget.pdfAssetPath}"),
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

                // numberPickerConfirmWidget: f,
              );
            } else {
              return const Center(child: Text('Failed to load PDF'));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
