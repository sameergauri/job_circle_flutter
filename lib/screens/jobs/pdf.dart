import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/constants/customdialogue_for_call_whatsapp.dart';
import 'package:url_launcher/url_launcher.dart';

class PDFViewerScreen extends StatefulWidget {
  final String pdfAssetPath;
  final int phoneNumber1, phoneNumber2;

  const PDFViewerScreen(
      {super.key,
      required this.pdfAssetPath,
      required this.phoneNumber1,
      required this.phoneNumber2});

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'PDF Viewer',
          style: TextStyle(color: Colors.black),
        ),
      ),
      floatingActionButton: widget.phoneNumber2 == 0
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
            ),
   
      body: FutureBuilder<PDFDocument>(
        future: PDFDocument.fromAsset(widget.pdfAssetPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return PDFViewer(
                document: snapshot.data!,
                zoomSteps: 1,
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
