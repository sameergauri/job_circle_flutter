import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class WebviewData extends StatefulWidget {
  final String? url;
  final String? title;
  const WebviewData({Key? key, this.url, this.title}) : super(key: key);

  @override
  State<WebviewData> createState() => _WebviewDataState();
}

class _WebviewDataState extends State<WebviewData> {
  var usertype = -1;
  String url = "";
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
      ),
      body:
          //  kIsWeb
          //     ? Iframe(
          //         key: UniqueKey(),
          //         url:
          //             "http://ec2-43-204-102-150.ap-south-1.compute.amazonaws.com:9092/leads",
          //       )
          //     :
          WebView(
        key: UniqueKey(),
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: url,
        onProgress: (int progress) {
          print('WebView is loading (progress : $progress%)');
        },
        navigationDelegate: (NavigationRequest request) {
          // if (request.url.startsWith('https://www.youtube.com/')) {
          //   print('blocking navigation to $request}');
          //   return NavigationDecision.prevent;
          // }
          print('allowing navigation to $request');
          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) {
          Utils.showLoaderDialog(context, "Loading");
          print('Page started loading: $url');
        },
        onPageFinished: (String url) {
          Utils.hideLoaderDialog(context);
          print('Page finished loading: $url');
        },
        gestureNavigationEnabled: true,
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
