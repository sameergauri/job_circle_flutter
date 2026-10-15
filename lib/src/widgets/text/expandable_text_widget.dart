// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  int initialMaxLines; // Initial maxLines value
  final bool isSummary;
  // When true, lines starting with '•' are rendered with a hanging indent so
  // that a wrapped continuation lines up under the bullet's text instead of
  // the left margin. Defaults to false so every other usage is unaffected.
  final bool hangingIndentBullets;

  ExpandableTextWidget({
    required this.text,
    required this.initialMaxLines,
    this.isSummary = false,
    this.hangingIndentBullets = false,
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

  // Renders bulleted text as a column of bullet-rows (fixed-width bullet +
  // Expanded text) so wrapped lines hang-indent under the bullet's text,
  // while still honouring the same total-line budget (initialMaxLines) that
  // the plain-text rendering uses, so View More/View Less keeps working the
  // same way for collapsed vs expanded state.
  Widget _buildBulletColumn(
    dynamic colors,
    double rowMaxWidth,
    TextScaler textScaler,
  ) {
    final style = TextStyle(
      fontFamily: "Cambria",
      fontSize: widget.isSummary ? 13 : 12,
      color: colors.headingColor,
      fontWeight: FontWeight.normal,
    );
    const bulletColumnWidth = 14.0;
    // rowMaxWidth comes from a LayoutBuilder placed exactly where this column
    // renders, so it already reflects the real width left after the card's
    // own padding/margins — unlike the full screen width, which is wider than
    // the actual space and was undercounting how many lines a bullet needs,
    // causing it to get cut off with "..." before it actually wrapped.
    // Small safety margin so minor rounding differences between this
    // estimate and the real RenderParagraph never make us predict fewer
    // lines than what's actually needed (that under-prediction is what
    // caused bullets to get cut off with "..." before they truly wrapped).
    final availableWidth = rowMaxWidth - bulletColumnWidth - 2.0;
    final lines = widget.text.split('\n');
    var remaining = widget.initialMaxLines;
    final rows = <Widget>[];

    for (final line in lines) {
      if (remaining <= 0) break;
      final trimmed = line.trimLeft();
      final isBullet = trimmed.startsWith('•');
      final bulletChar = isBullet ? '•' : '';
      final restText = isBullet ? trimmed.substring(1).trimLeft() : line;

      final fullPainter = TextPainter(
        text: TextSpan(text: restText, style: style),
        textDirection: TextDirection.ltr,
        // Must match the device's text scale, otherwise the estimate thinks
        // a line fits when the actually-rendered (scaled) text needs one
        // more line, which is what was causing premature "..." cutoffs.
        textScaler: textScaler,
      )..layout(maxWidth: availableWidth > 0 ? availableWidth : 0);
      final neededLines = fullPainter.computeLineMetrics().length;
      if (neededLines == 0) continue;
      final take = neededLines <= remaining ? neededLines : remaining;

      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: bulletColumnWidth, child: Text(bulletChar, style: style)),
              Expanded(
                child: Text(
                  restText,
                  style: style,
                  maxLines: take,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
      remaining -= take;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
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

    final useBulletLayout = widget.hangingIndentBullets;

    final textWidget = !useBulletLayout
        ? customTextFornCambria(
            title: widget.text,
            maxlines: widget.initialMaxLines,
            overflow: TextOverflow.ellipsis,
            fontSize: widget.isSummary ? 13 : 12,
            color: colors.headingColor,
            fontWeight: FontWeight.normal,
            //letterSpacing: 0.8,s
          )
        : LayoutBuilder(
            builder: (context, constraints) {
              return _buildBulletColumn(
                colors,
                constraints.maxWidth,
                MediaQuery.textScalerOf(context),
              );
            },
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget,
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
