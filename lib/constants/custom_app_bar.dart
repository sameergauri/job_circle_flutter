import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final double appBarHeight;
  final Widget leading;
  final Widget title;
 // final List<Widget> actions;
  final TabBar tabBar;

  CustomAppBar({
    required this.appBarHeight,
    required this.leading,
    required this.title,
   // this.actions,
    required this.tabBar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: appBarHeight,
      color: Colors.blue, // Customize the background color
      padding:
          const EdgeInsets.symmetric(horizontal: 16.0), // Customize the spacing
      child: Column(
        children: [
          Row(
            children: [
              leading,
              SizedBox(width: 16.0), // Add custom spacing
              Row(children: [title],),
              Spacer(), // Push actions to the right
              
            ],
          ),
          tabBar, // Display the TabBar
        ],
      ),
    );
  }
}
