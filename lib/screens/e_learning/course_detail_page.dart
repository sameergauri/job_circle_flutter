import 'package:flutter/material.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CourseDetailPage extends StatefulWidget {
  final String courseName;
  final String url;

  const CourseDetailPage({
    super.key,
    required this.courseName,
    required this.url,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // You can show a loading indicator here if needed
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          widget.courseName,
          style: const TextStyle(
            color: Constants.darkBlue,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
