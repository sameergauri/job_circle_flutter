import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/components/label_text.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/card_model.dart';
import 'package:job_circle/themes/typography.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SmartCard extends StatefulWidget {
  final CardModel? model;
  const SmartCard({Key? key, this.model}) : super(key: key);
  @override
  State<SmartCard> createState() => _SmartCardState();
}

class _SmartCardState extends State<SmartCard> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      SharedPreferences prefs = await Utils.getSharedPreferences();
      String mobile = await Utils.getPreferencesValue(
          prefs, ESharedPreferences.user_mobile.name);

      widget.model?.mobile = mobile;
      dynamic user_data = await Utils.getPreferencesValue(
          prefs, ESharedPreferences.user_data.name);
      if (user_data != null) {
        CardModel crd = CardModel.fromJson(jsonDecode(user_data));
        widget.model?.cardName = crd.cardName;
        widget.model?.mobile = crd.mobile;
        widget.model?.email = crd.email;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 150,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          //color: Colors.purple,

          image: const DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("../assets/images/abc.jpeg"),
          ),
          boxShadow: const [BoxShadow(blurRadius: 4)],
          border: Border.all(
              style: BorderStyle.solid, color: Colors.white, width: 1)),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Colors.transparent,
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
                  height: 20,
                ),
                // TypographyStyle.textH3("PRATIK NAIK", Colors.white),
                TypographyStyle.textH3(
                    widget.model?.cardName ?? 'Your Name', Colors.black),
                const SizedBox(
                  height: 20,
                ),
                CustomComponent.labelText(
                    widget.model?.mobile == null ? null : Icons.mobile_friendly,
                    widget.model?.mobile ?? '',
                    Colors.black),
                const SizedBox(
                  height: 10,
                ),
                CustomComponent.labelText(
                    widget.model?.email == null ? null : Icons.email_outlined,
                    widget.model?.email ?? '',
                    Colors.black),
              ],
            ),
          )
        ],
      ),
    );
  }
}
