// ignore_for_file: file_names, library_private_types_in_public_api, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';

class JobTitleItem extends StatefulWidget {
  final String title;
  final bool isSelected;
  final bool ismulti;
  final Function(bool) onTap;
  final bool isunSelect;
  final bool isVisible;
  final bool onlyOneIcon;

  const JobTitleItem({
    super.key,
    required this.isunSelect,
    required this.ismulti,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required getJobTitle1isSelected,
    required this.onlyOneIcon,
    required this.isVisible,
  });

  @override
  _JobTitleItemState createState() => _JobTitleItemState();
}

class _JobTitleItemState extends State<JobTitleItem> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  @override
  void didUpdateWidget(covariant JobTitleItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      isSelected = widget.isSelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible,
      child: GestureDetector(
        onTap: () {
          widget.isunSelect
              ? setState(() {
                  isSelected = !isSelected;
                })
              : setState(() {
                  isSelected = true;
                });
          widget.onTap(isSelected);
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xfff310d44) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: TextStyle(color: isSelected ? Colors.white : null),
              ),
              widget.ismulti
                  ? const SizedBox()
                  : SizedBox(
                      child: widget.onlyOneIcon
                          ? Icon(
                              isSelected ? Icons.check : Icons.abc,
                              color: isSelected ? Colors.white : null,
                              size: isSelected ? 15 : 0,
                            )
                          : Icon(
                              isSelected ? Icons.check : Icons.add,
                              color: isSelected ? Colors.white : null,
                              size: 15,
                            ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class JobTitleItemForInterviewRounds extends StatefulWidget {
  final String title;
  final bool isSelected;
  final bool ismulti;
  final Function(bool) onTap;
  final bool isunSelect;
  final bool isVisible;
  final bool onlyOneIcon;

  const JobTitleItemForInterviewRounds({
    super.key,
    required this.isunSelect,
    required this.ismulti,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required getJobTitle1isSelected,
    required this.onlyOneIcon,
    required this.isVisible,
  });

  @override
  _JobTitleItemForInterviewRoundsState createState() =>
      _JobTitleItemForInterviewRoundsState();
}

class _JobTitleItemForInterviewRoundsState
    extends State<JobTitleItemForInterviewRounds> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  @override
  void didUpdateWidget(covariant JobTitleItemForInterviewRounds oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      isSelected = widget.isSelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible,
      child: GestureDetector(
        onTap: () {
          widget.isunSelect
              ? setState(() {
                  isSelected = !isSelected;
                })
              : setState(() {
                  isSelected = true;
                });
          widget.onTap(isSelected);
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xfff310d44) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: TextStyle(color: isSelected ? Colors.white : null),
              ),
              widget.ismulti
                  ? const SizedBox()
                  : SizedBox(
                      child: widget.onlyOneIcon
                          ? Icon(
                              isSelected ? Icons.check : Icons.abc,
                              color: isSelected ? Colors.white : null,
                              size: isSelected ? 15 : 0,
                            )
                          : Icon(
                              isSelected ? Icons.check : Icons.add,
                              color: isSelected ? Colors.white : null,
                              size: 15,
                            ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
