import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomDialogueForAddResume extends StatefulWidget {
  final String subtitle;
  final VoidCallback onClose;
  final bool error;
  final bool confirmationDialogue;
  final String? title;
  const CustomDialogueForAddResume({
    super.key,
    required this.subtitle,
    required this.onClose,
    required this.error,
    this.confirmationDialogue = false,
    this.title,
  });

  @override
  State<CustomDialogueForAddResume> createState() =>
      _CustomDialogueForAddResumeState();
}

class _CustomDialogueForAddResumeState
    extends State<CustomDialogueForAddResume> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: widget.error ? Colors.red : Colors.white),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.confirmationDialogue || widget.title != null)
              SizedBox(height: 5),
            if (widget.confirmationDialogue || widget.title != null)
              customText(
                title: widget.title != null ? widget.title! : widget.subtitle,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            if (!widget.confirmationDialogue || widget.title != null)
              customText(title: widget.subtitle, fontSize: 14),
            if (widget.confirmationDialogue) SizedBox(height: 10),
            InkWell(
              onTap: widget.onClose,
              child: Container(
                margin: const EdgeInsets.only(top: 10, right: 6, bottom: 4),
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: widget.error
                      ? Colors.red
                      : widget.confirmationDialogue
                      ? Colors.red
                      : Constants.darkBlue,
                ),
                child: customText(
                  title: widget.confirmationDialogue ? "Yes" : "Close",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
