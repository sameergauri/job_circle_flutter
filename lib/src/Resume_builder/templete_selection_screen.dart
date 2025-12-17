import 'package:flutter/material.dart';
import 'package:job_circle/src/Resume_builder/theme/resume_theme.dart';
import 'package:job_circle/src/Resume_builder/ui/resume_builder_screen.dart';
import 'package:job_circle/src/model/user_profile/user_model.dart';

class TemplateSelectionScreen extends StatelessWidget {
  final ProfileModel userProfile;

  const TemplateSelectionScreen({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Resume Template")),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 Templates per row
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7, // Taller for resume shape
        ),
        itemCount: ResumeTemplateHelper.templates.length,
        itemBuilder: (context, index) {
          final template = ResumeTemplateHelper.templates[index];
          return GestureDetector(
            onTap: () {
              // Navigate to Resume Builder with Selected Template
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResumeBuilderScreen(
                    userProfile: userProfile,
                    selectedTheme: template.theme, // Pass the theme!
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.grey[200], // Placeholder for Image
                      child: Center(
                        child: Text(template.name, textAlign: TextAlign.center),
                        // Usage: Image.asset(template.previewImage, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          template.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          template.theme.toString().split('.').last,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
