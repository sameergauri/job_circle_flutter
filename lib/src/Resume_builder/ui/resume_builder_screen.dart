import 'package:flutter/material.dart';
import 'package:job_circle/src/Resume_builder/provider/pdf_generetor.dart';
import 'package:job_circle/src/Resume_builder/services/resume_builder_ai_services.dart';
import 'package:job_circle/src/Resume_builder/theme/resume_theme.dart';
import 'package:job_circle/src/model/user_profile/user_model.dart';
import 'package:printing/printing.dart';

class ResumeBuilderScreen extends StatefulWidget {
  // Pass current user profile data here
  final ProfileModel userProfile;
  final ResumeTheme selectedTheme; // ✅ Added this

  const ResumeBuilderScreen({super.key, required this.userProfile,required this.selectedTheme});

  @override
  _ResumeBuilderScreenState createState() => _ResumeBuilderScreenState();
}

class _ResumeBuilderScreenState extends State<ResumeBuilderScreen> {
  bool isGenerating = true;
  Map<String, dynamic>? polishedData;

  @override
  void initState() {
    super.initState();
    _generateResume();
  }

  Future<void> _generateResume() async {
    // 1. Call AI to polish data
    polishedData = null;
    final aiService = ResumeAiService();
    polishedData = await aiService.polishResumeData(widget.userProfile);

    if (mounted) {
      setState(() {
        isGenerating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isGenerating) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("AI is rewriting your resume professionally..."),
            ],
          ),
        ),
      );
    }

    // 2. Show PDF Preview
    return Scaffold(
      appBar: AppBar(title: const Text("Your AI Resume")),
      body: PdfPreview(
        build: (  format) => PdfGenerator().generateResume(polishedData!, widget.selectedTheme),
      ),
    );
  }
}
