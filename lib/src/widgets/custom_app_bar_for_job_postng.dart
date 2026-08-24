import 'package:flutter/material.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class JobPostingPageAppBarTitle extends StatelessWidget {
  JobPostingPageAppBarTitle({super.key, this.title});
  String? title;
  @override
  Widget build(BuildContext context) {
    return customText(
      title: title ?? "Job Posting",
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );
  }
}
