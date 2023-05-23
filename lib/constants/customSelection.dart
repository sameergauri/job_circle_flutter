import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobTitleItem extends StatefulWidget {
  final String title;
  final bool isSelected;
  final bool ismulti;
  final VoidCallback onTap;
  final bool isVisible;

  const JobTitleItem({
    super.key,
    required this.ismulti,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required getJobTitle1isSelected,
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
          setState(() {
            isSelected = !isSelected;
          });
          widget.onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xfff310d44) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: TextStyle(color: isSelected ? Colors.white : null),
              ),
              widget.ismulti
                  ? SizedBox(
                      child: isSelected
                          ? Row(
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                Image.asset(
                                  "assets/images/cross.png",
                                  height: 11.h,
                                ),
                              ],
                            )
                          : null,
                    )
                  : SizedBox(
                      child: Icon(
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
