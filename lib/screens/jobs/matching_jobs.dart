import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/themes/colors.dart';

class MatchingJobs extends StatefulWidget {
  const MatchingJobs({super.key});

  @override
  State<MatchingJobs> createState() => _MatchingJobsState();
}

class _MatchingJobsState extends State<MatchingJobs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Coming Soon",
            style: GoogleFonts.varela(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Constants.themeBgColor)),
      ),
    );
  }
}
