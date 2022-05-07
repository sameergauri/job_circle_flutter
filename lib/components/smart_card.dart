import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:job_circle/components/label_text.dart';
import 'package:job_circle/models/card_model.dart';
import 'package:job_circle/themes/typography.dart';

class SmartCard extends StatelessWidget {
  CardModel? model;
  SmartCard({Key? key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 150,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: Colors.blueGrey,
          boxShadow: [BoxShadow(blurRadius: 4)],
          border: Border.all(
              style: BorderStyle.solid, color: Colors.white, width: 1)),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    topRight: Radius.circular(100),
                    bottomRight: Radius.circular(100))),
            height: double.infinity,
            width: 150,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Image.asset(
                "assets/images/male.png",
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                // TypographyStyle.textH3("PRATIK NAIK", Colors.white),
                TypographyStyle.textH3(
                    model?.cardName ?? 'Your Name', Colors.white),
                const SizedBox(
                  height: 10,
                ),
                CustomComponent.labelText(
                    "Mobile", "+91 9004390874", Colors.white),
                const SizedBox(
                  height: 10,
                ),
                CustomComponent.labelText("", "+91 9004390874", Colors.white),
              ],
            ),
          )
        ],
      ),
    );
  }
}
