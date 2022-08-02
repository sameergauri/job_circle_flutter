import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:pdfx/pdfx.dart';

class PdfViwer extends StatefulWidget {
  final String? url;
  final String? title;
  const PdfViwer({Key? key, this.url, this.title}) : super(key: key);

  @override
  State<PdfViwer> createState() => _PdfViwerState();
}

class _PdfViwerState extends State<PdfViwer> {
  var usertype = -1;
  String url = "";
  static const int _initialPage = 1;
  bool _isSampleDoc = true;
  late PdfControllerPinch _pdfControllerPinch;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      usertype = await Utils.getPreferencesValue(
          null, ESharedPreferences.user_type.name);
      if (widget.url!.contains("?")) {
        url = widget.url! + "&usertype=" + usertype.toString();
      } else {
        url = widget.url! + "?usertype=" + usertype.toString();
      }

      setState(() {});
    });

    _pdfControllerPinch = PdfControllerPinch(
      // document: PdfDocument.openAsset('assets/hello.pdf'),
      document: PdfDocument.openData(
        InternetFile.get(
          widget.url!,
        ),
      ),
      initialPage: _initialPage,
    );
  }

  @override
  void dispose() {
    _pdfControllerPinch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
      ),
      body: PdfViewPinch(
        builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
          options: const DefaultBuilderOptions(),
          documentLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          pageLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          errorBuilder: (_, error) => Center(child: Text(error.toString())),
        ),
        controller: _pdfControllerPinch,
      ),
    );
  }
}

// class Iframe extends StatelessWidget {
//   final String url;
//   Iframe({Key? key, required this.url})
//       : super(
//           key: key,
//         ) {
//     // ignore: undefined_prefixed_name
//     ui.platformViewRegistry.registerViewFactory('iframe', (int viewId) {
//       var iframe = html.IFrameElement();
//       iframe.src = url;
//       return iframe;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return const SizedBox(
//         width: double.infinity,
//         height: double.infinity,
//         child: HtmlElementView(viewType: 'iframe'));
//   }
// }
