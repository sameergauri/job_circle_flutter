import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/faq/faq_model.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class FaqReactionButtons extends StatelessWidget {
  final FaqItem faq;
  final bool isLoading;
  final Function({required bool? like, required bool? dislike}) onReact;

  const FaqReactionButtons({
    super.key,
    required this.faq,
    required this.isLoading,
    required this.onReact,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          customText(
            title: "Was this helpfull?",
            fontSize: 11,
            fontStyle: FontStyle.italic,
            color: colors.subTitleColor,
          ),
          SizedBox(width: 10),
          // LIKE BUTTON
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: isLoading
                    ? null
                    : () {
                        if (faq.userLiked) {
                          // Already liked → Reset
                          onReact(like: null, dislike: null);
                        } else {
                          // Like
                          onReact(like: true, dislike: false);
                        }
                      },
                child: Icon(
                  faq.userLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                  size: 18,
                  color: faq.userLiked ? colors.darkBlue : colors.subTitleColor,
                ),
              ),
              if (faq.likeCount != 0) ...[
                SizedBox(width: 4),
                Text(
                  formatCount(faq.likeCount),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ],
          ),

          const SizedBox(width: 20),

          // DISLIKE BUTTON
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: isLoading
                    ? null
                    : () {
                        if (faq.userDisliked) {
                          // Already disliked → Reset
                          onReact(like: null, dislike: null);
                        } else {
                          // Dislike
                          onReact(like: false, dislike: true);
                        }
                      },
                child: Icon(
                  faq.userDisliked
                      ? Icons.thumb_down
                      : Icons.thumb_down_alt_outlined,
                  size: 18,
                  color: faq.userDisliked
                      ? colors.subTitleColor
                      : colors.subTitleColor,
                ),
              ),
              if (faq.dislikeCount != 0) ...[
                SizedBox(width: 4),
                Text(
                  formatCount(faq.dislikeCount),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ],
          ),

          /* if (isLoading) ...[
                const SizedBox(width: 12),
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ], */
        ],
      ),
    );
  }

  String formatCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 100000) {
      // 1k to 99.9k
      double value = count / 1000;
      // Truncate to 1 decimal (no rounding)
      double truncated = (value * 10).floorToDouble() / 10;
      return truncated % 1 == 0
          ? '${truncated.toInt()}k'
          : '${truncated.toStringAsFixed(1)}k';
    } else if (count < 10000000) {
      // 1Lac to 99.9Lac
      double value = count / 100000;
      double truncated = (value * 10).floorToDouble() / 10;
      return truncated % 1 == 0
          ? '${truncated.toInt()}Lac'
          : '${truncated.toStringAsFixed(1)}Lac';
    } else {
      // 1Cr+
      double value = count / 10000000;
      double truncated = (value * 10).floorToDouble() / 10;
      return truncated % 1 == 0
          ? '${truncated.toInt()}Cr'
          : '${truncated.toStringAsFixed(1)}Cr';
    }
  }
}
