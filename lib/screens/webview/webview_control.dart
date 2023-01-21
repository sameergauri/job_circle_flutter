import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/webJsonModel.dart';
import 'package:job_circle/screens/viewers/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewDataCtrl extends StatefulWidget {
  final String? url;
  final String? title;
  final bool? actionbar;
  final WebViewCtrlController? controller;
  const WebViewDataCtrl(
      {Key? key, this.url, this.title, this.actionbar = true, this.controller})
      : super(key: key);

  @override
  State<WebViewDataCtrl> createState() => _WebViewDataCtrlState();
}

class _WebViewDataCtrlState extends State<WebViewDataCtrl> {
  var usertype = -1;
  var role = "-1";
  var progress = 0.1;
  var isLoading = true;
  var uid = 0;
  String url = "";
  late WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller?.refresh = refresh;
      widget.controller?.setUrl = setUrl;
    }
    url = widget.url!;
    initiate();
  }

  void initiate() async {
    usertype = await Utils.getPreferencesValue(
        null, ESharedPreferences.user_type.name);
    role = await Utils.getPreferencesValue(null, ESharedPreferences.role.name);
    uid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);

    if (url.contains("?")) {
      url = url +
          "&usertype=" +
          usertype.toString() +
          "&role=" +
          role +
          "&uid=" +
          uid.toString();
    } else {
      url = url +
          "?usertype=" +
          usertype.toString() +
          "&role=" +
          role +
          "&uid=" +
          uid.toString();
    }

    setState(() {});
  }

  void refresh() {
    isLoading = true;
    setState(() {});
    webViewController.reload();
  }

  void setUrl() {
    url = widget.controller!.url;
    initiate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.actionbar!
          ? AppBar(
              title: Text(widget.title!),
              actions: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: Visibility(
                              visible: isLoading,
                              child: const CircularProgressIndicator(
                                strokeWidth: 4,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () => {
                                    if (!isLoading)
                                      {
                                        isLoading = true,
                                        if (webViewController != null)
                                          {webViewController.reload()}
                                      }
                                  },
                              icon: const Icon(Icons.refresh))
                        ],
                      ),
                    ),
                  ],
                )
              ],
              // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
            )
          : null,
      body:
          //  kIsWeb
          //     ? Iframe(4
          //         key: UniqueKey(),
          //         url:
          //             "http://ec2-13-232-140-47.ap-south-1.compute.amazonaws.com:9092/leads",
          //       )
          //     :
          Column(
        children: [
          if (isLoading)
            const LinearProgressIndicator(
              minHeight: 5,
              color: ui.Color.fromARGB(255, 255, 255, 255),
              backgroundColor: ui.Color.fromARGB(255, 222, 2, 2),
            ),
          Expanded(
            child: WebView(
              key: UniqueKey(),
              javascriptMode: JavascriptMode.unrestricted,
              debuggingEnabled: true,
              javascriptChannels: {
                JavascriptChannel(
                    name: 'webJson',
                    onMessageReceived: (JavascriptMessage message) async {
                      var data = await jsonDecode(message.message);
                      WebJson wj = WebJson.fromJson(data);
                      if (wj.func == "call_mobile") {
                        bool? res = await FlutterPhoneDirectCaller.callNumber(
                            wj.data["contactno"].toString());
                      } else if (wj.func == "send_message") {
                        final link = WhatsAppUnilink(
                          phoneNumber: wj.data["contactno"].toString(),
                          text: wj.data["message"].toString(),
                        );
                        // Convert the WhatsAppUnilink instance to a string.
                        // Use either Dart's string interpolation or the toString() method.
                        // The "launch" method is part of "url_launcher".
                        await launchUrl(Uri.parse(link.toString()));
                      } else if (wj.func == "file_view") {
                        var url = wj.data["url"].toString();
                        var title = wj.data["title"].toString();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PdfViwer(
                                      url: GlobalConstants.ASSET_URL + url,
                                      title: title,
                                    )));
                      }
                    }),
              },
              zoomEnabled: false,
              initialUrl: url,
              onProgress: (int progress) {
                print('WebView is loading (progress : $progress%)');
              },
              onWebViewCreated: (web) => {webViewController = web},
              navigationDelegate: (NavigationRequest request) {
                // if (request.url.startsWith('https://www.youtube.com/')) {
                //   print('blocking navigation to $request}');
                //   return NavigationDecision.prevent;
                // }
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                //Utils.showLoaderDialog(context, "Loading");
                print('Page started loading: $url');
              },
              onPageFinished: (String url) {
                //Utils.hideLoaderDialog(context);
                if (isLoading) {
                  isLoading = false;
                  setState(() {});
                }

                print('Page finished loading: $url');
              },
              gestureNavigationEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}

class WebViewCtrlController {
  late VoidCallback refresh;
  late VoidCallback setUrl;
  late String url;
}
