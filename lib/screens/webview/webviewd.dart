
// ignore_for_file: unused_import, prefer_interpolation_to_compose_strings, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewData extends StatefulWidget {
  final String? url;
  final String? title;
  const WebviewData({Key? key, this.url, this.title}) : super(key: key);

  @override
  State<WebviewData> createState() => _WebviewDataState();
}

class _WebviewDataState extends State<WebviewData> {
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
    initData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      usertype = await Utils.getPreferencesValue(
          null, ESharedPreferences.user_type.name);
      role =
          await Utils.getPreferencesValue(null, ESharedPreferences.role.name);
      uid = await Utils.getPreferencesValue(
          null, ESharedPreferences.user_id.name);

      if (widget.url!.contains("?")) {
        url = widget.url! +
            "&usertype=" +
            usertype.toString() +
            "&role=" +
            role +
            "&uid=" +
            uid.toString();
      } else {
        url = widget.url! +
            "?usertype=" +
            usertype.toString() +
            "&role=" +
            role +
            "&uid=" +
            uid.toString();
      }

      setState(() {});
    });
  }

  void initData() async {
    await FlutterDownloader.initialize(
        debug:
            true, // optional: set to false to disable printing logs to console (default: true)
        ignoreSsl:
            false // option: set to false to disable working with http links (default: false)
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      //body:
          //  kIsWeb
          //     ? Iframe(4
          //         key: UniqueKey(),
          //         url:
          //             "http://ec2-43-204-102-150.ap-south-1.compute.amazonaws.com:9092/leads",
          //       )
          //     :
/*           WebView(
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
                  if (url.toLowerCase().contains(".pdf")) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PdfViwer(
                                  url: GlobalConstants.ASSET_URL + url,
                                  title: title,
                                )));
                  } else if (url.toLowerCase().contains(".jpg") ||
                      url.toLowerCase().contains(".jpeg") ||
                      url.toLowerCase().contains(".png") ||
                      url.toLowerCase().contains(".gif") ||
                      url.toLowerCase().contains(".bmp")) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageViewer(
                                  url: GlobalConstants.ASSET_URL + url,
                                  title: title,
                                )));
                  } else {
                    final taskId = await FlutterDownloader.enqueue(
                      url: GlobalConstants.ASSET_URL + url,

                      savedDir: '/storage/emulated/0/Download/',
                      showNotification:
                          true, // show download progress in status bar (for Android)
                      openFileFromNotification:
                          true, // click on notification to open downloaded file (for Android)
                    );
                  }
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
      ), */
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
