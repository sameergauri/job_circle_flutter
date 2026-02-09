// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  int initialMaxLines; // Initial maxLines value
  final bool isSummary;

  ExpandableTextWidget({
    required this.text,
    required this.initialMaxLines,
    this.isSummary = false,
    super.key,
  });

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  // late int currentMaxLines;
  late bool exceedsMaxLines;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkExceedsMaxLines();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resetState(); // Har baar page reload pe reset hoga
  }

  void _resetState() {
    setState(() {
      widget.initialMaxLines = 4;
      _checkExceedsMaxLines(); // Reset ke saath calculation bhi karni padegi
    });
  }

  void _checkExceedsMaxLines() {
    final textSpan = TextSpan(
      text: widget.text,
      style: GoogleFonts.merriweather(
        fontSize: 12,
        // fontWeight: FontWeight.w500,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      maxLines: widget.initialMaxLines, // Initial maxLines
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width);

    final fullTextPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width);

    setState(() {
      exceedsMaxLines = textPainter.height < fullTextPainter.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.text,
        style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      maxLines: widget.initialMaxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width);

    final exceedsMaxLines = textPainter.didExceedMaxLines;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customTextFornCambria(
          title: widget.text,
          maxlines: widget.initialMaxLines,
          overflow: TextOverflow.ellipsis,
          fontSize: widget.isSummary ? 13 : 12,
          color: colors.headingColor,
          fontWeight: FontWeight.normal,
          //letterSpacing: 0.8,s
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.initialMaxLines > 5)
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.initialMaxLines = 4;
                  });
                },
                child: const customText(
                  title: "View Less",
                  color: Color.fromARGB(255, 239, 18, 2),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(width: 10),
            if (exceedsMaxLines && widget.initialMaxLines < widget.text.length)
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.initialMaxLines += 10;
                  });
                },
                child: const customText(
                  title: "View More",
                  color: Constants.darkBlue,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
