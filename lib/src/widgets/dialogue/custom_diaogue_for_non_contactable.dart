// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/provider/business_ats/business_ats_provider.dart';
import 'package:job_circle/src/widgets/button/custom_toggle_button.dart';
// import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class CustomDialogueForNotContactable extends StatefulWidget {
  final String title;
  final Function onYes;
  final String hint;
  final bool notcontact;

  const CustomDialogueForNotContactable({
    super.key,
    required this.title,
    required this.onYes,
    required this.hint,
    required this.notcontact,
  });

  @override
  State<CustomDialogueForNotContactable> createState() =>
      _CustomDialogueForNotContactable();
}

class _CustomDialogueForNotContactable
    extends State<CustomDialogueForNotContactable> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusnode.requestFocus();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    /*  final atsprovider = Provider.of<AtsProvider>(context, listen: false);
    atsprovider.remark.clear(); */
  }

  bool ringing = false,
      busy = false,
      notrechebale = false,
      disconnect = false,
      trainigunsatisfy = false,
      other = false;

  String text = '';

  FocusNode focusnode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final atsprovider = Provider.of<AtsProvider>(context, listen: false);
    final colors = context.appColors;
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        backgroundColor: colors.bottomsheetbgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
        contentPadding: const EdgeInsets.only(
          top: 20,
          left: 14,
          right: 14,
          bottom: 20,
        ),
        content: Container(
          color: colors.bottomsheetbgColor,
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customText(
                    title: widget.title,
                    fontSize: 16,
                    softwrap: true,
                    fontWeight: FontWeight.bold,
                    color: colors.headingColor,
                  ),
                  InkWell(
                    onTap: () {
                      atsprovider.remark.clear();
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: colors.headingColor,
                    ),
                  ),
                ],
              ),
              if (!widget.notcontact)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Wrap(
                        children: [
                          CustomToggleButton(
                            isSelect: trainigunsatisfy,
                            title: "Training uncertified",
                            onTap: () {
                              setState(() {
                                trainigunsatisfy = true;
                                other = false;
                                atsprovider.remark.clear();
                                text = '';
                              });
                            },
                          ),
                          CustomToggleButton(
                            isSelect: other,
                            title: "Other",
                            onTap: () {
                              setState(() {
                                trainigunsatisfy = false;
                                other = true;
                                atsprovider.remark.clear();
                                text = '';
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              if (widget.notcontact)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Wrap(
                        children: [
                          CustomToggleButton(
                            isSelect: ringing,
                            title: "Ringing",
                            onTap: () {
                              setState(() {
                                ringing = true;
                                busy = false;
                                notrechebale = false;
                                disconnect = false;
                                other = false;
                                atsprovider.remark.clear();
                                text = '';
                              });
                            },
                          ),
                          CustomToggleButton(
                            title: "Busy",
                            onTap: () {
                              setState(() {
                                ringing = false;
                                busy = true;
                                notrechebale = false;
                                disconnect = false;
                                other = false;
                                text = '';
                                atsprovider.remark.clear();
                              });
                            },
                            isSelect: busy,
                          ),
                          CustomToggleButton(
                            isSelect: notrechebale,
                            title: "Not reachable",
                            onTap: () {
                              setState(() {
                                ringing = false;
                                busy = false;
                                notrechebale = true;
                                disconnect = false;
                                other = false;
                                atsprovider.remark.clear();
                                text = '';
                              });
                            },
                          ),
                          CustomToggleButton(
                            isSelect: disconnect,
                            title: "Disconnecting",
                            onTap: () {
                              setState(() {
                                ringing = false;
                                busy = false;
                                notrechebale = false;
                                disconnect = true;
                                other = false;
                                atsprovider.remark.clear();
                                text = '';
                              });
                            },
                          ),
                          CustomToggleButton(
                            isSelect: other,
                            title: "Other",
                            onTap: () {
                              setState(() {
                                ringing = false;
                                busy = false;
                                notrechebale = false;
                                disconnect = false;
                                other = true;
                                focusnode.requestFocus();
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              if (other)
                CustomTextFieldforAll(
                  isGmail: true,
                  controller: atsprovider.remark,
                  hint: widget.hint,
                  focusNode: focusnode,
                  onChanged: (p0) {
                    setState(() {
                      text = p0;
                    });
                  },
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (((widget.notcontact &&
                              (busy ||
                                  ringing ||
                                  notrechebale ||
                                  disconnect)) ||
                          (widget.notcontact && (other && text != ''))) ||
                      ((!widget.notcontact && (trainigunsatisfy)) ||
                          !widget.notcontact && other && text != ''))
                    InkWell(
                      onTap: () {
                        if (ringing) {
                          atsprovider.remark.text = "Ringing";
                        } else if (busy) {
                          atsprovider.remark.text = "Busy";
                        } else if (notrechebale) {
                          atsprovider.remark.text = "Not reachable";
                        } else if (disconnect) {
                          atsprovider.remark.text = "Disconnecting";
                        } else if (trainigunsatisfy) {
                          atsprovider.remark.text = "Training uncertified";
                        }
                        widget.onYes();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: Constants.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: customText(
                          title: "Submit",
                          fontWeight: FontWeight.bold,
                          color: Constants.darkBlue,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDialogueForRemark extends StatefulWidget {
  final String title;
  final Function onYes;
  final String hint;

  const CustomDialogueForRemark({
    super.key,
    required this.title,
    required this.onYes,
    required this.hint,
  });

  @override
  State<CustomDialogueForRemark> createState() =>
      _CustomDialogueForRemarkState();
}

class _CustomDialogueForRemarkState extends State<CustomDialogueForRemark> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusnode.requestFocus();
  }

  bool isUnderGraduate = false;

  bool isGraduate = false;

  String text = '';

  FocusNode focusnode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final atsprovider = Provider.of<AtsProvider>(context, listen: false);
    final colors = context.appColors;

    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        backgroundColor: colors.bottomsheetbgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
        contentPadding: const EdgeInsets.only(
          top: 20,
          left: 14,
          right: 14,
          bottom: 20,
        ),
        content: Container(
          color: colors.bottomsheetbgColor,
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customText(
                    title: widget.title,
                    fontSize: 16,
                    softwrap: true,
                    fontWeight: FontWeight.bold,
                    color: colors.headingColor,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      atsprovider.remark.clear();
                    },
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: colors.headingColor
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              CustomTextFieldforAll(
                controller: atsprovider.remark,
                hint: widget.hint,
                focusNode: focusnode,
                onChanged: (p0) {
                  setState(() {
                    text = p0;
                  });
                },
              ),
              SizedBox(height: 20),
              if (text != '')
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        widget.onYes();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: Constants.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: customText(
                          title: "Submit",
                          fontWeight: isUnderGraduate
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: Constants.darkBlue,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
