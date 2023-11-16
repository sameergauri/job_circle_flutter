import 'package:flutter/material.dart';
import 'package:job_circle/screens/jobs/Applied_jobs.dart';
import 'package:job_circle/screens/refer_now.dart';

import '../../themes/colors.dart';

class TrackApplication extends StatefulWidget {
  const TrackApplication({Key? key}) : super(key: key);

  @override
  State<TrackApplication> createState() => _TrackApplicationState();
}

class _TrackApplicationState extends State<TrackApplication> {
  final PageController pageController = PageController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          //   decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
          //   margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
          child: Column(
            children: [
              CustomTabBar(
                tabs: const ["Applie's", "Referral +"],
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
                  children: const [AppliedJob(), AllReferStatus()],
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



/* class TabClipper extends CustomClipper<Path> {   working with clipper
  final bool isLeft;

  TabClipper({this.isLeft = false});

  @override
  Path getClip(Size size) {
    var path = Path();

    if (isLeft) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0.5 * size.height);
      path.quadraticBezierTo(0, 0, 0.1 * size.width, 0);
      path.lineTo(0.48 * size.width, 0);
      path.quadraticBezierTo(
          0.512 * size.width, 0, 0.52 * size.width, 0.1 * size.height);
      path.lineTo(0.57 * size.width, 0.83 * size.height);
      path.quadraticBezierTo(0.58 * size.width, 0.9 * size.height,
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
} */

// Updated CustomTabBar widget using ClipPath

/* class CustomTabBar extends StatelessWidget {
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
      height: 35,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          tabs.length,
          (index) => _buildTabItem(index, context),
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, BuildContext context) {
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onTabChanged(index),
      child: SizedBox(
        height: 60,
        width: MediaQuery.of(context).size.width / 2,
        child: ClipPath(
          clipper: TabClipper(isLeft: index == 0),
          child: Container(
            color: isSelected ? Constants.borderColor : Colors.grey.shade100,
            child: Center(
              child: Text(
                tabs[index],
                style: TextStyle(
                  color:
                      isSelected ? Colors.grey.shade500 : Colors.grey.shade400,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} */


/* class CustomTabBar extends StatelessWidget {
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
      height: 35,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          tabs.length,
          (index) => _buildTabItem(index, context),
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, BuildContext context) {
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onTabChanged(index),
      child: SizedBox(
        height: 60,
        width: MediaQuery.of(context).size.width / 2,
        child: CustomPaint(
          painter: TabPainter(
              //  radius: 20,
              isLeft: index == 0 ? true : false,
              color: isSelected ? Constants.borderColor : Colors.grey.shade100),
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
      ),
    );
  }
}

class TabPainter extends CustomPainter {
  final Color color;
  final bool isLeft;

  TabPainter({required this.color, this.isLeft = false});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    var path = Path();

    if (isLeft) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0.5 * size.height);
      path.quadraticBezierTo(0, 0, 0.1 * size.width, 0);
      path.lineTo(0.48 * size.width, 0);
      path.quadraticBezierTo(
          0.512 * size.width, 0, 0.52 * size.width, 0.1 * size.height);
      path.lineTo(0.57 * size.width, 0.83 * size.height);
      path.quadraticBezierTo(0.58 * size.width, 0.9 * size.height,
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

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
 */

/* class CustomTabBar extends StatelessWidget {
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
      // height: 60,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          tabs.length,
          (index) => _buildTabItem(index, context),
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, BuildContext context) {
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onTabChanged(index),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.021.w,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
          borderRadius: index == 0
              ? const BorderRadius.only(
                  //  topRight: Radius.circular(30),
                  topLeft: Radius.elliptical(30.2, 50.2),
                  topRight: Radius.elliptical(80.2, 50.2))
              : const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  //  bottomLeft: Radius.circular(30)
                ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tabs[index],
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
} */





