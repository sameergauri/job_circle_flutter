// ignore_for_file: unnecessary_underscores, deprecated_member_use, library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as InternetFile;
import 'package:job_circle/src/constants/colors.dart';
import 'package:pdfx/pdfx.dart';

class DocxViewerWidget extends StatefulWidget {
  final String docxUrl;

  const DocxViewerWidget({super.key, required this.docxUrl});

  @override
  State<DocxViewerWidget> createState() => _DocxViewerWidgetState();
}

class _DocxViewerWidgetState extends State<DocxViewerWidget> {
  @override
  void dispose() {
    try {
      webViewController.stopLoading();
    } catch (_) {}
    super.dispose();
  }

  bool isLoading = true;
  String? errorMessage;
  double loadingProgress = 0;
  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    // ✅ Check if file is PDF — wrap URL for Google Docs Viewer
    final String fileUrl =
        'https://view.officeapps.live.com/op/embed.aspx?src=${widget.docxUrl}';

    return WillPopScope(
      onWillPop: () async {
        try {
          await webViewController.stopLoading();
        } catch (_) {}
        return true; // allow back navigation
      },
      child: Stack(
        children: [
          AnimatedOpacity(
            opacity: isLoading ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(fileUrl)),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                supportZoom: true,
                builtInZoomControls: false,
                displayZoomControls: false,
                useWideViewPort: true,
                loadWithOverviewMode: true,
                mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
                allowFileAccessFromFileURLs: true,
                allowUniversalAccessFromFileURLs: true,
              ),
              onWebViewCreated: (controller) => webViewController = controller,
              onLoadStart: (_, __) => setState(() {
                isLoading = true;
                errorMessage = null;
              }),
              onLoadStop: (controller, _) async {
                setState(() => isLoading = false);

                // 🧩 Inject JavaScript to hide share icon and footer in Google Docs Viewer
                await controller.evaluateJavascript(
                  source: '''
        document.getElementsByTagName('header')[0].style.display='none';
        document.getElementsByTagName('footer')[0].style.display='none';
        ''',
                );
              },
              onProgressChanged: (_, progress) =>
                  setState(() => loadingProgress = progress / 100),
              onLoadError: (_, __, ___, message) => setState(() {
                isLoading = false;
                errorMessage = 'Failed to load: $message';
              }),
              onLoadHttpError: (_, __, statusCode, description) => setState(() {
                isLoading = false;
                errorMessage = 'HTTP Error $statusCode: $description';
              }),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 30, // adjust as needed
            child: Container(color: Colors.white),
          ),
          if (isLoading)
            Container(
              color: colors.bgColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: Constants.darkBlue),
                    const SizedBox(height: 16),
                    Text(
                      'Loading Document... ${(loadingProgress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (errorMessage != null)
            Container(
              color: colors.bgColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.headingColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                          errorMessage = null;
                        });
                        webViewController.reload();
                      },
                      icon: Icon(Icons.refresh, color: colors.headingColor),
                      label: Text(
                        'Retry',
                        style: TextStyle(color: colors.headingColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// pdf_viewer_screen.dart

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;

  const PdfViewerScreen({super.key, required this.pdfUrl});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PdfControllerPinch? pdfController;
  bool isLoading = true;
  String? errorMessage;
  int currentPage = 1;
  int totalPages = 0;

  @override
  void initState() {
    super.initState();
    _initializePdfController();
  }

  void _initializePdfController() async {
    final response = await InternetFile.get(Uri.parse(widget.pdfUrl));
    pdfController = PdfControllerPinch(
      document: PdfDocument.openData(response.bodyBytes),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.bgColor,
      body: pdfController == null
          ? SizedBox.shrink()
          : PdfViewPinch(
          
              controller: pdfController!,
              onDocumentLoaded: (document) {
                setState(() {
                  isLoading = false;
                  totalPages = document.pagesCount;
                });
              },
              onPageChanged: (page) {
                setState(() {
                  currentPage = page;
                });
              },
              onDocumentError: (error) {
                setState(() {
                  isLoading = false;
                  errorMessage = error.toString();
                });
              },
              builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
                options: DefaultBuilderOptions(),
                documentLoaderBuilder: (_) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Constants.darkBlue),
                      SizedBox(height: 16),
                      Text(
                        'Loading PDF...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: colors.headingColor,
                        ),
                      ),
                    ],
                  ),
                ),
                pageLoaderBuilder: (_) => const Center(
                  child: CircularProgressIndicator(color: Constants.darkBlue),
                ),
                errorBuilder: (_, error) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'Error loading PDF: ${error.toString()}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.headingColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _initializePdfController();
                          });
                        },
                        icon: Icon(Icons.refresh, color: colors.headingColor),
                        label: Text(
                          'Retry',
                          style: TextStyle(color: colors.headingColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    pdfController!.dispose();
    super.dispose();
  }
}
