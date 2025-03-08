import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

final isExpandedProvider = StateProvider<bool>((ref) => false);

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  int initialMaxLines; // Initial maxLines value

  ExpandableTextWidget({
    required this.text,
    required this.initialMaxLines,
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
      style: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
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
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.text,
        style: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      maxLines: widget.initialMaxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width);

    final exceedsMaxLines = textPainter.didExceedMaxLines;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customTextForRoboto(
          title: widget.text,
          maxlines: widget.initialMaxLines,
          overflow: TextOverflow.ellipsis,
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.initialMaxLines > 5)
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.initialMaxLines = 5;
                  });
                },
                child: const customTextForWeather(
                  title: "View Less",
                  color: Color.fromARGB(255, 239, 18, 2),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(
              width: 10,
            ),
            if (exceedsMaxLines && widget.initialMaxLines < widget.text.length)
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.initialMaxLines += 10;
                  });
                },
                child: const customTextForWeather(
                  title: "View More",
                  color: Constants.themeBgColor,
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


/* class ExpandableTextWidget extends ConsumerWidget {
  final String text;
  final int maxLines;

  const ExpandableTextWidget({
    required this.text,
    this.maxLines = 4,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(isExpandedProvider);

    // Measure text height
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: GoogleFonts.varela(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width);

    final exceedsMaxLines =
        textPainter.didExceedMaxLines; // True if text overflows

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customTextForWeather(
          title: text,
          maxlines: isExpanded ? null : maxLines,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          fontSize: 12,
          // color: Constants.subtitleclr,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        if (exceedsMaxLines) // Show "View More" only if text overflows
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () =>
                    ref.read(isExpandedProvider.notifier).state = !isExpanded,
                child: customTextForWeather(
                  title: isExpanded ? "View Less" : "View More",
                  color: Constants.themeBgColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
      ],
    );
  }
} */


/* import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/themes/colors.dart';

final isExpandedProvider = StateProvider<bool>((ref) => false);

class ExpandableTextWidget extends ConsumerWidget {
  final String text;
  final int maxLines;

  const ExpandableTextWidget({
    required this.text,
    this.maxLines = 4,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(isExpandedProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          maxLines: isExpanded ? null : maxLines,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: GoogleFonts.varela(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (text.split(' ').length > maxLines * 4) // Condition for "View More"
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () =>
                    ref.read(isExpandedProvider.notifier).state = !isExpanded,
                child: Text(
                  isExpanded ? "View Less" : "View More",
                  style: TextStyle(
                    color: Constants.themeBgColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
 */