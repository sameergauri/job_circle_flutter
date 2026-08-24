import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomRadioButton extends StatefulWidget {
  final String title;
  final bool isSelected;
  final ValueChanged<bool> onChanged;

  const CustomRadioButton({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  _CustomRadioButtonState createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(true); // Call the callback function
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            widget.isSelected
                ? Icons.radio_button_checked_outlined
                : Icons.radio_button_off,
            color: widget.isSelected
                ? Constants.darkBlue
                : Constants.subtitleclr,
          ),
          const SizedBox(width: 5),
          customText(
            title: widget.title,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Constants.subtitleclr,
          ),
        ],
      ),
    );
  }
}
