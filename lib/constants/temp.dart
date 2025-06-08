import 'package:flutter/material.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';

class TempPage extends StatelessWidget {
  const TempPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: customTextForWeather(
          title: 'No data found',
          fontSize: 16,
        ),
      ),
    );
  }
}
