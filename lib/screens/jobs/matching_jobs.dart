import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchingJobs extends StatefulWidget {
  const MatchingJobs({super.key});

  @override
  State<MatchingJobs> createState() => _MatchingJobsState();
}

class _MatchingJobsState extends State<MatchingJobs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text("Coming Soon",
            style: GoogleFonts.varela(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
    );
  }
}
