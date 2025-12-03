import 'package:flutter/material.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class BulletedText extends StatelessWidget {
  final String text;
  final double bulletSize;
  final double spacing;
  final TextStyle? style;
  final int? maxLines;

  const BulletedText({
    super.key,
    required this.text,
    this.bulletSize = 3.0,
    this.spacing = 8.0,
    this.style,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final lines = text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < lines.length; i++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 6),
                width: bulletSize,
                height: bulletSize,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: customText(
                title:  lines[i],
                  overflow: maxLines != null ? TextOverflow.ellipsis : null,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
