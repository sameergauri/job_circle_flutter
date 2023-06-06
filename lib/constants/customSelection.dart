import 'package:flutter/material.dart';

class JobTitleItem extends StatefulWidget {
  final String title;
  final bool isSelected;
  final bool ismulti;
  final VoidCallback onTap;
  final bool isVisible;
  final bool onlyOneIcon;

  const JobTitleItem({
    super.key,
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
          setState(() {
            isSelected = true;
          });
          widget.onTap();
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
