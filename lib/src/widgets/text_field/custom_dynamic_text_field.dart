// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/src/constants/colors.dart';

class DynamicHintTextField extends StatefulWidget {
  final String hint;
  final bool? isGmail;
  final bool isPrimaryNumber;
  final int? maxLength;
  final bool isNumber;
  final bool? keyboardType;
  final bool isDisabled;
  final int? maxline;
  final bool? isSearchBar;
  final bool? isSearch;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final Function(PointerDownEvent)? onTabOutside;
  final Function(String)? onFieldSubmitted;
  final TextEditingController controller;
  final Function? onTab;
  final bool? headline;

  const DynamicHintTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.isGmail,
    this.isPrimaryNumber = false,
    this.maxLength,
    this.isNumber = false,
    this.keyboardType,
    this.isDisabled = true,
    this.maxline,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onTabOutside,
    this.onTab,
    this.isSearchBar,
    this.isSearch,
    this.headline,
    this.focusNode,
  });

  @override
  _DynamicHintTextFieldState createState() => _DynamicHintTextFieldState();
}

class _DynamicHintTextFieldState extends State<DynamicHintTextField>
    with SingleTickerProviderStateMixin {
  final List<String> dynamicParts = ["Role", "Process", "Skills"];
  int _currentIndex = 0;
  Timer? _timer;

  String get _staticPrefix => "Search job by ";
  String get _currentDynamicHint => dynamicParts[_currentIndex];

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % dynamicParts.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        SizedBox(
          height: widget.maxline == null
              ? MediaQuery.of(context).size.height / 24
              : null,
          child: TextFormField(
            focusNode: focusNode,
            onTap: () {
              widget.onTab != null ? widget.onTab!() : null;
            },
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onFieldSubmitted,
            onEditingComplete: widget.onEditingComplete,
            onTapOutside: widget.onTabOutside,
            maxLines: widget.maxline,
            enabled: widget.isDisabled,
            controller: widget.controller,
            maxLength: widget.maxLength,
            inputFormatters: widget.isNumber
                ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
                : (widget.isGmail != null && widget.isGmail!)
                ? <TextInputFormatter>[
                    FilteringTextInputFormatter.singleLineFormatter,
                  ]
                : <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                  ],
            keyboardType: widget.isNumber
                ? TextInputType.phone
                : TextInputType.name,
            textCapitalization: widget.keyboardType == true
                ? TextCapitalization.none
                : TextCapitalization.sentences,
            style: GoogleFonts.montserrat(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              filled: widget.isPrimaryNumber
                  ? true
                  : widget.isSearch != null && widget.isSearch!
                  ? true
                  : false,
              fillColor: widget.isPrimaryNumber
                  ? Colors.grey[200]
                  : widget.isSearch != null && widget.isSearch!
                  ? Colors.white
                  : Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              counterText: widget.headline == true ? null : '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black),
              ),
              // hintText removed since we are manually overlaying
            ),
          ),
        ),

        // 🧠 Manual hint when controller is empty
        if (widget.controller.text.isEmpty)
          InkWell(
            splashColor: Colors.transparent, // Add this
            highlightColor: Colors.transparent, // Add this
            hoverColor: Colors.transparent, // Add this (for web/desktop)
            onTap: () {
              focusNode.requestFocus();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    _staticPrefix,
                    style: GoogleFonts.montserrat(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(
                      milliseconds: 1000,
                    ), // slow fade-slide
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          final slideIn =
                              Tween<Offset>(
                                begin: const Offset(0, -1), // from top
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.linear,
                                ),
                              );

                          return SlideTransition(
                            textDirection: TextDirection.rtl,
                            position: slideIn,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                    child: Text(
                      "'$_currentDynamicHint'",
                      key: ValueKey(
                        _currentDynamicHint,
                      ), // must be unique for each hint
                      style: GoogleFonts.merriweather(
                        color: Constants.black,
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
