// ignore_for_file: use_super_parameters, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:job_circle/screens/jobs/my_pipe_line.dart';
import 'package:job_circle/screens/jobs/talent_pool.dart';

import '../../themes/colors.dart';

class Recruitz extends StatefulWidget {
  const Recruitz({Key? key}) : super(key: key);

  @override
  State<Recruitz> createState() => _RecruitzState();
}

class _RecruitzState extends State<Recruitz> {
  final PageController pageController = PageController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              CustomTabBar(
                tabs: const ["Talent Pool", "My PipeLine"],
                selectedIndex: selectedIndex,
                onTabChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                  pageController.jumpToPage(index);
                },
              ),
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  children: const [TalentPool(), MyPipeLine()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TabClipper extends CustomClipper<Path> {
  final bool isLeft;

  TabClipper({this.isLeft = false});

  @override
  Path getClip(Size size) {
    var path = Path();

    if (isLeft) {
      path.moveTo(0, size.height);
      path.lineTo(0, 2 * size.height);
      path.quadraticBezierTo(0, 0, 0.6 * size.width, 3);
      path.lineTo(0.48 * size.width, 0);
      path.quadraticBezierTo(
          0.512 * size.width, 0, 0.6 * size.width, 0.1 * size.height);
      path.lineTo(0.57 * size.width, 0.83 * size.height);
      path.quadraticBezierTo(0.6 * size.width, 0.9 * size.height,
          0.59 * size.width, 0.9 * size.height);
      path.lineTo(size.width, 0.9 * size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    } else {
      path.moveTo(size.width, size.height);
      path.lineTo(size.width, 0.5 * size.height);
      path.quadraticBezierTo(size.width, 0, size.width - 0.1 * size.width, 0);
      path.lineTo(size.width - 0.48 * size.width, 0);
      path.quadraticBezierTo(size.width - 0.512 * size.width, 0,
          size.width - 0.52 * size.width, 0.1 * size.height);
      path.lineTo(size.width - 0.57 * size.width, 0.83 * size.height);
      path.quadraticBezierTo(size.width - 0.58 * size.width, 0.9 * size.height,
          size.width - 0.59 * size.width, 0.9 * size.height);
      path.lineTo(0, 0.9 * size.height);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) {
    return oldClipper.isLeft != isLeft;
  }
}

class CustomTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabChanged;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              tabs.length,
              (index) => _buildTabItem(index, context),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 2,
              width: MediaQuery.of(context).size.width / tabs.length,
              transform: Matrix4.translationValues(
                (MediaQuery.of(context).size.width / tabs.length) *
                    selectedIndex,
                0,
                0,
              ),
              decoration: BoxDecoration(
                color: Constants.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, BuildContext context) {
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onTabChanged(index),
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width / tabs.length,
        child: Center(
          child: Text(
            tabs[index],
            style: TextStyle(
              color: isSelected ? Colors.grey.shade500 : Colors.grey.shade400,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
