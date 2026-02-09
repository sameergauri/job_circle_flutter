// ignore_for_file: unused_local_variable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';

class CustomNewListTile extends StatelessWidget {
  const CustomNewListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.isThreeLine = false,
    this.dense,
    this.contentPadding,
    this.shape,
    this.tileColor,
    this.selectedTileColor,
    this.visualDensity,
    this.enabled = true,
    this.selected = false,
    this.mouseCursor,
    this.onTap,
    this.onLongPress,
    this.enableFeedback,
    this.focusNode,
    this.autofocus = false,
    this.horizontalTitleGap,
    this.minVerticalPadding,
    this.minLeadingWidth,
    this.textColor,
    this.iconColor,
    this.selectedColor,
    this.titleTextStyle,
    this.subtitleTextStyle,
  });

  // ListTile जैसी ही properties
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;

  final bool isThreeLine;
  final bool? dense;
  final EdgeInsetsGeometry? contentPadding;
  final ShapeBorder? shape;
  final Color? tileColor;
  final Color? selectedTileColor;
  final VisualDensity? visualDensity;

  final bool enabled;
  final bool selected;
  final MouseCursor? mouseCursor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool? enableFeedback;
  final FocusNode? focusNode;
  final bool autofocus;

  final double? horizontalTitleGap; // gap b/w leading and title
  final double? minVerticalPadding; // vertical padding
  final double? minLeadingWidth; // leading min width

  final Color? textColor;
  final Color? iconColor;
  final Color? selectedColor;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);
    final listTileTheme = ListTileTheme.of(context);

    // Resolve paddings/dimensions similar to ListTile defaults
    final EdgeInsets resolvedPadding =
        (contentPadding ??
                listTileTheme.contentPadding as EdgeInsets? ??
                const EdgeInsets.symmetric(horizontal: 16.0))
            .resolve(Directionality.of(context));

    final double resolvedHorizontalTitleGap =
        horizontalTitleGap ?? 16.0; // ListTile default
    final double resolvedMinLeadingWidth = minLeadingWidth ?? 40.0;
    final double resolvedMinVerticalPadding =
        minVerticalPadding ?? (dense == true ? 4.0 : 8.0);

    // Colors (selected/normal)
    final bool isEnabled = enabled && (onTap != null || onLongPress != null);
    final Color? effectiveTextColor = selected
        ? (selectedColor ?? listTileTheme.selectedColor ?? textColor)
        : (textColor ?? listTileTheme.textColor);
    final Color? effectiveIconColor = selected
        ? (selectedColor ?? listTileTheme.selectedColor ?? iconColor)
        : (iconColor ?? listTileTheme.iconColor);

    final Color? backgroundColor = colors.bgColor; /* selected
        ? (selectedTileColor ?? listTileTheme.selectedTileColor)
        : (tileColor ?? listTileTheme.tileColor); */

    // Text styles
    final TextStyle baseTitleStyle =
        theme.textTheme.titleMedium ?? const TextStyle(fontSize: 16);
    final TextStyle baseSubtitleStyle =
        theme.textTheme.bodyMedium ?? const TextStyle(fontSize: 14);

    final TextStyle titleStyle =
        (titleTextStyle ?? listTileTheme.titleTextStyle ?? baseTitleStyle)
            .apply(color: effectiveTextColor);

    final TextStyle subtitleStyle =
        (subtitleTextStyle ??
                listTileTheme.subtitleTextStyle ??
                baseSubtitleStyle)
            .apply(color: effectiveTextColor?.withOpacity(0.8));

    // Dense adjustment (like ListTile)
    final TextStyle adjustedTitleStyle = (dense ?? listTileTheme.dense ?? false)
        ? titleStyle.copyWith(fontSize: (titleStyle.fontSize ?? 16) - 2)
        : titleStyle;

    final TextStyle adjustedSubtitleStyle =
        (dense ?? listTileTheme.dense ?? false)
        ? subtitleStyle.copyWith(fontSize: (subtitleStyle.fontSize ?? 14) - 2)
        : subtitleStyle;

    // Visual density
    final VisualDensity density =
        visualDensity ?? listTileTheme.visualDensity ?? theme.visualDensity;

    final bool hasSubtitle = subtitle != null;
    assert(
      isThreeLine ||
          !hasSubtitle ||
          !isOneLine(adjustedTitleStyle, adjustedSubtitleStyle),
      'When isThreeLine is false, make sure title/subtitle styles fit within two lines.',
    );

    Widget? leadingIcon = leading;
    if (leadingIcon != null && effectiveIconColor != null) {
      leadingIcon = IconTheme.merge(
        data: IconThemeData(color: effectiveIconColor),
        child: leadingIcon,
      );
    }

    Widget? trailingIcon = trailing;
    if (trailingIcon != null && effectiveIconColor != null) {
      trailingIcon = IconTheme.merge(
        data: IconThemeData(color: effectiveIconColor),
        child: trailingIcon,
      );
    }

    final Widget content = Row(
      crossAxisAlignment: hasSubtitle || isThreeLine
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.start,
      children: [
        if (leadingIcon != null)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: resolvedMinLeadingWidth),
              child: leadingIcon,
            ),
          ),
        // Title + Subtitle
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                DefaultTextStyle.merge(
                  style: adjustedTitleStyle,
                  maxLines: isThreeLine ? 3 : (hasSubtitle ? 1 : 2),
                  overflow: TextOverflow.ellipsis,
                  child: title!,
                ),
              if (hasSubtitle) ...[
                const SizedBox(height: 2),
                DefaultTextStyle.merge(
                  style: adjustedSubtitleStyle,
                  maxLines: isThreeLine ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  child: subtitle!,
                ),
              ],
            ],
          ),
        ),
        if (trailingIcon != null) ...[Expanded(flex: 1, child: trailingIcon)],
      ],
    );

    final Widget tile = InkWell(
      onTap: isEnabled ? onTap : null,
      onLongPress: isEnabled ? onLongPress : null,
      enableFeedback: enableFeedback != null ? enableFeedback! : false,
      mouseCursor: mouseCursor,
      focusNode: focusNode,
      autofocus: autofocus,
      customBorder: shape is OutlinedBorder ? shape as OutlinedBorder? : null,
      child: content,
    );

    return Material(color: backgroundColor, shape: shape, child: tile);
  }

  // Helper to estimate if title+subtitle likely exceed single line each
  bool isOneLine(TextStyle titleStyle, TextStyle subtitleStyle) {
    // Heuristic, ListTile भी strict check नहीं करता; हम safe side पर रखते हैं
    return (titleStyle.height ?? 1.0) <= 1.3 &&
        (subtitleStyle.height ?? 1.0) <= 1.3;
  }
}
