// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, use_super_parameters

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';

class SimpleWebView extends StatefulWidget {
  final String? url;
  final String? title;
  const SimpleWebView({Key? key, this.url, this.title}) : super(key: key);

  @override
  State<SimpleWebView> createState() => _SimpleWebViewState();
}

class _SimpleWebViewState extends State<SimpleWebView> {
  GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: true),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  double progress = 0;
  late String url = "";
  var usertype = -1;
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
      webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
      setState(() {});
    });
    print(url);
    pullToRefreshController = PullToRefreshController(
        options: PullToRefreshOptions(
          color: Colors.blue,
        ),
        onRefresh: () async {
          if (Platform.isAndroid) {
            webViewController?.reload();
          } else if (Platform.isIOS) {
            webViewController?.loadUrl(
                urlRequest: URLRequest(url: await webViewController?.getUrl()));
          }
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title!),
          // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        ),
        body: SafeArea(
            child: InAppWebView(
          key: webViewKey,
          // contextMenu: contextMenu,
          initialUrlRequest: URLRequest(
              url: WebUri(
                  "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf")),
          // initialFile: "assets/index.html",

          initialOptions: options,
          pullToRefreshController: pullToRefreshController,
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onLoadStart: (controller, url) {
            setState(() {
              this.url = url.toString();
            });
          },
          androidOnPermissionRequest: (controller, origin, resources) async {
            return PermissionRequestResponse(
                resources: resources,
                action: PermissionRequestResponseAction.GRANT);
          },
          // shouldOverrideUrlLoading: (controller, navigationAction) async {
          //   var uri = navigationAction.request.url!;

          //   // if (![
          //   //   "http",
          //   //   "https",
          //   //   "file",
          //   //   "chrome",
          //   //   "data",
          //   //   "javascript",
          //   //   "about"
          //   // ].contains(uri.scheme)) {
          //   //   if (await canLaunch(url)) {
          //   //     // Launch the App
          //   //     await launch(
          //   //       url,
          //   //     );
          //   //     // and cancel the request
          //   //     return NavigationActionPolicy.CANCEL;
          //   //   }
          //   // }

          //   return NavigationActionPolicy.ALLOW;
          // },
          onLoadStop: (controller, url) async {
            pullToRefreshController.endRefreshing();
            setState(() {
              this.url = url.toString();
            });
          },
          onLoadError: (controller, url, code, message) {
            pullToRefreshController.endRefreshing();
          },
          onProgressChanged: (controller, progress) {
            if (progress == 100) {
              pullToRefreshController.endRefreshing();
            }
            setState(() {
              this.progress = progress / 100;
            });
          },
          onUpdateVisitedHistory: (controller, url, androidIsReload) {
            setState(() {
              this.url = url.toString();
            });
          },
          onConsoleMessage: (controller, consoleMessage) {
            print(consoleMessage);
          },
        )));
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
