import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomDocumentUploadButton extends StatefulWidget {
  final Function onTab;
  final String title;
  final String? subTitle;

  const CustomDocumentUploadButton({
    super.key,
    required this.onTab,
    required this.title,
    this.subTitle,
  });

  @override
  State<CustomDocumentUploadButton> createState() =>
      _CustomDocumentUploadButtonState();
}

class _CustomDocumentUploadButtonState
    extends State<CustomDocumentUploadButton> {
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: () {
        widget.onTab();
      },
      child: DottedBorder(
        options: RectDottedBorderOptions(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
          strokeWidth: 1,
          dashPattern: const [4, 4],
          color: Constants.subtitleclr,
        ),
        child: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 8),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: colors.unSelectedTabColor,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(1, 1),
                      blurStyle: BlurStyle.outer,
                      color: Colors.grey.shade400,
                      blurRadius: 2.1,
                    ),
                  ],
                ),
                child: customText(
                  title: widget.title,
                  color: colors.atsTabTextColor,
                ),
              ),
              customText(
                title:
                    widget.subTitle ?? "Supported format : PDF, DOCX and DOC",
                fontSize: 10,
                color: Constants.subtitleclr,
                fontStyle: FontStyle.italic,
              ),
              SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomResumeUpload extends StatefulWidget {
  final Function onTab;
  final String title;
  final String? subTitle;

  const CustomResumeUpload({
    super.key,
    required this.onTab,
    required this.title,
    this.subTitle,
  });

  @override
  State<CustomResumeUpload> createState() => _CustomResumeUploadState();
}

class _CustomResumeUploadState extends State<CustomResumeUpload> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTab();
      },
      child: DottedBorder(
        options: RectDottedBorderOptions(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
          strokeWidth: 1,
          dashPattern: const [4, 4],
          color: Constants.subtitleclr,
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              CustomNetworkImage(
                imageUrl: CustomIconUrl.documenticon,
                defaultIcon: Icons.abc,
                height: 50,
              ),
              SizedBox(height: 10),
              customText(
                title: widget.subTitle ?? "Upload Resume",
                fontSize: 14,
                color: Constants.subtitleclr,
                fontStyle: FontStyle.italic,
              ),
              customText(
                title: widget.subTitle ?? "Supported formate : PDF, DOCX",
                fontSize: 10,
                color: Constants.subtitleclr,
                fontStyle: FontStyle.italic,
              ),
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 8),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(1, 1),
                      blurStyle: BlurStyle.outer,
                      color: Colors.grey.shade400,
                      blurRadius: 2.1,
                    ),
                  ],
                ),
                child: customText(
                  title: widget.title,
                  color: Constants.darkBlue,
                ),
              ),
              SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}
