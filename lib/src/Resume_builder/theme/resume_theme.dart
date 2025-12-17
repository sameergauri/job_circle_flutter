import 'package:flutter/material.dart';

enum ResumeTheme {
  classic, // 1. Simple, Black & White
  modernSidebar, // 2. Blue Sidebar on Left
  professional, // 3. Centered, Blue Dividers
  creative, // 4. Orange Header Background
  minimalist, // 5. All Caps Headers, Grey Text, No Lines
  executive, // 6. Dark Blue Sidebar on Right
  tech, // 7. Green Accents, Grid Skills
  corporate, // 8. Grey Background Header, Boxed Layout
  elegant, // 9. Serif font style (simulated), Purple accents
  compact, // 10. Small margins, dense text for 1-pagers
}

class ResumeTemplateHelper {
  final ResumeTheme theme;
  final String name;
  final Color color; // For UI display only

  ResumeTemplateHelper(this.theme, this.name, this.color);

  static List<ResumeTemplateHelper> get templates => [
    ResumeTemplateHelper(ResumeTheme.classic, "Classic", Colors.grey),
    ResumeTemplateHelper(ResumeTheme.modernSidebar, "Modern Blue", Colors.blue),
    ResumeTemplateHelper(
      ResumeTheme.professional,
      "Professional",
      Colors.indigo,
    ),
    ResumeTemplateHelper(ResumeTheme.creative, "Creative", Colors.deepOrange),
    ResumeTemplateHelper(ResumeTheme.minimalist, "Minimalist", Colors.black87),
    ResumeTemplateHelper(ResumeTheme.executive, "Executive", Colors.blueGrey),
    ResumeTemplateHelper(ResumeTheme.tech, "Tech Green", Colors.teal),
    ResumeTemplateHelper(
      ResumeTheme.corporate,
      "Corporate",
      Colors.grey.shade700,
    ),
    ResumeTemplateHelper(ResumeTheme.elegant, "Elegant", Colors.purple),
    ResumeTemplateHelper(ResumeTheme.compact, "Compact", Colors.brown),
  ];
}
