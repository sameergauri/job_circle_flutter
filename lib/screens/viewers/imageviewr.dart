import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class ImageViewer extends StatefulWidget {
  final String? url;
  final String? title;
  const ImageViewer({Key? key, this.url, this.title}) : super(key: key);

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title!),
          // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        ),
        body: PhotoView(
          imageProvider: NetworkImage(widget.url!),
        ));
  }
}
