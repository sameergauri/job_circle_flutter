import 'package:flutter/material.dart';
import 'package:job_circle/enums/enums.dart';

class ThemeButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;
  final bool? isText;
  final ThemeButtonSize? themeButtonSize;
  final double width;
  final bool disabled;
  final bool hide;
  final double radious;
  final Icon? icon;
  final Color? color;
  final double? fontsize;

  const ThemeButton(
      {Key? key,
      required this.onPressed,
      this.text,
      this.isText = false,
      this.themeButtonSize = ThemeButtonSize.medium,
      this.width = 0,
      this.disabled = false,
      this.hide = false,
      this.radious = 100,
      this.icon,
      this.color,
      this.fontsize = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return hide
        ? Container()
        : Container(
            width: width > 0.0 ? width : double.infinity,
            height: themeButtonSize == ThemeButtonSize.large
                ? 60
                : themeButtonSize == ThemeButtonSize.small
                    ? 35
                    : themeButtonSize == ThemeButtonSize.xsmall
                        ? 30
                        : 50,
            decoration: BoxDecoration(
              color: isText == true
                  ? Colors.transparent
                  : disabled
                      ? Theme.of(context).disabledColor
                      : color ?? Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(radious)),
            ),
            child: RawMaterialButton(
              padding: const EdgeInsets.all(10),
              onPressed: disabled ? null : () => onPressed(),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radious)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        text!,
                        style: TextStyle(
                          color: isText == true ? Colors.black87 : Colors.white,
                          fontSize: fontsize! > 0
                              ? fontsize
                              : (themeButtonSize == ThemeButtonSize.large
                                  ? 22
                                  : themeButtonSize == ThemeButtonSize.small
                                      ? 15
                                      : themeButtonSize ==
                                              ThemeButtonSize.xsmall
                                          ? 11
                                          : 19),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  icon ?? Container(),
                ],
              ),
            ),
          );
  }
}
