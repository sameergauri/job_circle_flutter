import 'package:flutter/material.dart';

class CustomExpansionTile extends StatelessWidget {
  final Widget title;
  final List<Widget> children;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final ValueChanged<bool>? onExpansionChanged;
  final bool initiallyExpanded;
  final bool maintainState;
  final EdgeInsetsGeometry? tilePadding;
  final Alignment? expandedAlignment;
  final CrossAxisAlignment? expandedCrossAxisAlignment;
  final EdgeInsetsGeometry? childrenPadding;
  final Color? iconColor;
  final Color? collapsedIconColor;
  final Color? textColor;
  final Color? collapsedTextColor;
  final ShapeBorder? shape;
  final ShapeBorder? collapsedShape;
  final Clip? clipBehavior;
  final ListTileControlAffinity? controlAffinity;
  final AnimationStyle? expansionAnimationStyle;

  // Custom ExpansionTile internal options
  final bool? dense;
  final VisualDensity? visualDensity;
  final bool enabled;

  // Material Wrapper Props
  final Color backgroundColor;
  final Color? expandedBackgroundColor;
  final Color? collapsedBackgroundColor;
  final BorderRadius? borderRadius;

  const CustomExpansionTile({
    super.key,
    required this.title,
    this.children = const <Widget>[],
    this.subtitle,
    this.leading,
    this.trailing,
    this.onExpansionChanged,
    this.initiallyExpanded = false,
    this.maintainState = false,
    this.tilePadding = EdgeInsets.zero,
    this.expandedAlignment,
    this.expandedCrossAxisAlignment,
    this.childrenPadding = EdgeInsets.zero,
    this.iconColor,
    this.collapsedIconColor,
    this.textColor,
    this.collapsedTextColor,
    this.shape,
    this.collapsedShape,
    this.clipBehavior,
    this.controlAffinity,
    this.expansionAnimationStyle,
    this.dense = true,
    this.visualDensity,
    this.enabled = true,
    this.backgroundColor = Colors.transparent,
    this.expandedBackgroundColor,
    this.collapsedBackgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: borderRadius ?? BorderRadius.zero,
      clipBehavior: borderRadius != null ? Clip.antiAlias : Clip.none,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: title,
          subtitle: subtitle,
          leading: leading,
          trailing: trailing,
          onExpansionChanged: onExpansionChanged,
          initiallyExpanded: initiallyExpanded,
          maintainState: maintainState,
          tilePadding: tilePadding,
          expandedAlignment: expandedAlignment,
          expandedCrossAxisAlignment: expandedCrossAxisAlignment,
          childrenPadding: childrenPadding,
          iconColor: iconColor,
          collapsedIconColor: collapsedIconColor,
          textColor: textColor,
          collapsedTextColor: collapsedTextColor,
          backgroundColor: expandedBackgroundColor,
          collapsedBackgroundColor: collapsedBackgroundColor,
          shape: shape,
          collapsedShape: collapsedShape,
          clipBehavior: clipBehavior,
          controlAffinity: controlAffinity,
          expansionAnimationStyle: expansionAnimationStyle,
          dense: dense,
          visualDensity: visualDensity,
          enabled: enabled,
          children: children,
        ),
      ),
    );
  }
}
