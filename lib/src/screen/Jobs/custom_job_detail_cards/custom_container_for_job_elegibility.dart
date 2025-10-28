import 'package:flutter/material.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomContainerForEligibility extends StatelessWidget {
  final String heading;
  final List<String>? stringList;
  final bool isList;
  final String? title;

  const CustomContainerForEligibility({
    super.key,
    required this.heading,
    this.stringList,
    required this.isList,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            title: heading,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 4),
          isList
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      stringList
                          ?.map(
                            (e) => Padding(
                              padding: EdgeInsets.only(
                                bottom: e == stringList!.last ? 0 : 8,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const customText(
                                    title: "• ",
                                    letterspacing: 1.0,
                                  ),
                                  Expanded(
                                    child: customText(
                                      title: e,
                                      letterspacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList() ??
                      [],
                )
              : customText(title: title ?? ''),
        ],
      ),
    );
  }
}
