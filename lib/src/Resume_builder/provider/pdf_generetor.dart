// ignore_for_file: unreachable_switch_default

import 'dart:typed_data';

import 'package:job_circle/src/Resume_builder/theme/resume_theme.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGenerator {
  // Font storage
  late pw.Font ttfRegular;
  late pw.Font ttfBold;

  Future<Uint8List> generateResume(
    Map<String, dynamic> data,
    ResumeTheme theme,
  ) async {
    final pdf = pw.Document();

    // 3. Add Page with specific layout
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: theme == ResumeTheme.compact
            ? const pw.EdgeInsets.all(15) // Smaller margin for compact
            : const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          switch (theme) {
            case ResumeTheme.modernSidebar:
              return _buildLayoutModernSidebar(data);
            case ResumeTheme.professional:
              return _buildLayoutProfessional(data);
            case ResumeTheme.creative:
              return _buildLayoutCreative(data);
            case ResumeTheme.minimalist:
              return _buildLayoutMinimalist(data);
            case ResumeTheme.executive:
              return _buildLayoutExecutive(data);
            case ResumeTheme.tech:
              return _buildLayoutTech(data);
            case ResumeTheme.corporate:
              return _buildLayoutCorporate(data);
            case ResumeTheme.elegant:
              return _buildLayoutElegant(data);
            case ResumeTheme.compact:
              return _buildLayoutCompact(data);
            case ResumeTheme.classic:
            default:
              return _buildLayoutClassic(data);
          }
        },
      ),
    );

    return pdf.save();
  }

  // =========================================================
  // 🎨 THEME 1: CLASSIC (Simple, Black & White)
  // =========================================================
  List<pw.Widget> _buildLayoutClassic(Map<String, dynamic> data) {
    return [
      _header(data, fontSize: 26),
      pw.SizedBox(height: 10),
      _contactInfo(data),
      pw.Divider(),
      _sectionTitle("Profile Summary"),
      _bio(data),
      _sectionTitle("Skills"),
      _skills(data),
      _sectionTitle("Experience"),
      _experience(data),
      _sectionTitle("Education"),
      _education(data),
      _projects(data),
    ];
  }

  // =========================================================
  // 🎨 THEME 2: MODERN SIDEBAR (Left Blue Column)
  // =========================================================
  List<pw.Widget> _buildLayoutModernSidebar(Map<String, dynamic> data) {
    return [
      pw.Partitions(
        children: [
          pw.Partition(
            flex: 3,
            child: pw.Container(
              padding: const pw.EdgeInsets.only(right: 15),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  right: pw.BorderSide(color: PdfColors.grey300),
                ),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _header(data, fontSize: 22, color: PdfColors.blue800),
                  pw.SizedBox(height: 20),
                  _contactInfo(data, isVertical: true),
                  pw.SizedBox(height: 20),
                  _sectionTitle("Skills", color: PdfColors.blue800),
                  _skills(data),
                  pw.SizedBox(height: 20),
                  _sectionTitle("Languages", color: PdfColors.blue800),
                  _languages(data),
                ],
              ),
            ),
          ),
          pw.Partition(
            flex: 7,
            child: pw.Padding(
              padding: const pw.EdgeInsets.only(left: 15),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Summary", color: PdfColors.blue800),
                  _bio(data),
                  _sectionTitle("Experience", color: PdfColors.blue800),
                  _experience(data),
                  _sectionTitle("Education", color: PdfColors.blue800),
                  _education(data),
                  _projects(data),
                ],
              ),
            ),
          ),
        ],
      ),
    ];
  }

  // =========================================================
  // 🎨 THEME 3: PROFESSIONAL (Centered, Blue Lines)
  // =========================================================
  List<pw.Widget> _buildLayoutProfessional(Map<String, dynamic> data) {
    return [
      pw.Center(child: _header(data, fontSize: 28, color: PdfColors.indigo900)),
      pw.SizedBox(height: 5),
      pw.Center(child: _contactInfo(data)),
      pw.Divider(color: PdfColors.indigo900, thickness: 1.5),
      pw.SizedBox(height: 10),
      _sectionTitle(
        "Professional Summary",
        color: PdfColors.indigo900,
        isCentered: true,
      ),
      pw.Center(child: _bio(data, isCentered: true)),
      pw.SizedBox(height: 10),
      _sectionTitle(
        "Work Experience",
        color: PdfColors.indigo900,
        isCentered: true,
      ),
      _experience(data),
      _sectionTitle("Education", color: PdfColors.indigo900, isCentered: true),
      _education(data),
      _sectionTitle("Skills", color: PdfColors.indigo900, isCentered: true),
      pw.Center(child: _skills(data)),
      _projects(data),
    ];
  }

  // =========================================================
  // 🎨 THEME 4: CREATIVE (Header Background Color)
  // =========================================================
  List<pw.Widget> _buildLayoutCreative(Map<String, dynamic> data) {
    return [
      pw.Container(
        padding: const pw.EdgeInsets.all(20),
        color: PdfColors.deepOrange50,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _header(data, fontSize: 26, color: PdfColors.deepOrange900),
                pw.SizedBox(height: 5),
                pw.Text(
                  data['summary'] ?? '',
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.deepOrange800,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ],
        ),
      ),
      pw.SizedBox(height: 20),
      _contactInfo(data),
      pw.Divider(color: PdfColors.deepOrange),
      _sectionTitle("Experience", color: PdfColors.deepOrange),
      _experience(data),
      _sectionTitle("Skills", color: PdfColors.deepOrange),
      _skills(data),
      _sectionTitle("Education", color: PdfColors.deepOrange),
      _education(data),
      _projects(data),
    ];
  }

  // =========================================================
  // 🎨 THEME 5: MINIMALIST (Clean, No Lines, Uppercase)
  // =========================================================
  List<pw.Widget> _buildLayoutMinimalist(Map<String, dynamic> data) {
    return [
      _header(data, fontSize: 24, color: PdfColors.grey900),
      pw.SizedBox(height: 20),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 1,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _sectionTitle("CONTACT", isUppercase: true, fontSize: 10),
                _contactInfo(data, isVertical: true),
                pw.SizedBox(height: 20),
                _sectionTitle("SKILLS", isUppercase: true, fontSize: 10),
                _skills(data),
              ],
            ),
          ),
          pw.SizedBox(width: 20),
          pw.Expanded(
            flex: 3,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _sectionTitle("PROFILE", isUppercase: true, fontSize: 10),
                _bio(data),
                pw.SizedBox(height: 15),
                _sectionTitle("EXPERIENCE", isUppercase: true, fontSize: 10),
                _experience(data),
                pw.SizedBox(height: 15),
                _sectionTitle("EDUCATION", isUppercase: true, fontSize: 10),
                _education(data),
                _projects(data),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  // =========================================================
  // 🎨 THEME 6: EXECUTIVE (Right Sidebar, Dark)
  // =========================================================
  List<pw.Widget> _buildLayoutExecutive(Map<String, dynamic> data) {
    return [
      pw.Partitions(
        children: [
          pw.Partition(
            flex: 7,
            child: pw.Padding(
              padding: const pw.EdgeInsets.only(right: 20),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _header(data, fontSize: 30, color: PdfColors.blueGrey900),
                  _bio(data),
                  pw.Divider(color: PdfColors.blueGrey900),
                  _sectionTitle("Experience", color: PdfColors.blueGrey900),
                  _experience(data),
                  _sectionTitle("Education", color: PdfColors.blueGrey900),
                  _education(data),
                  _projects(data),
                ],
              ),
            ),
          ),
          pw.Partition(
            flex: 3,
            child: pw.Container(
              color: PdfColors.blueGrey50,
              padding: const pw.EdgeInsets.all(10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Contact", color: PdfColors.blueGrey900),
                  _contactInfo(data, isVertical: true),
                  pw.SizedBox(height: 20),
                  _sectionTitle("Skills", color: PdfColors.blueGrey900),
                  _skills(data),
                  pw.SizedBox(height: 20),
                  _sectionTitle("Certifications", color: PdfColors.blueGrey900),
                  _certifications(data),
                ],
              ),
            ),
          ),
        ],
      ),
    ];
  }

  // =========================================================
  // 🎨 THEME 7: TECH (Green Accents, Grid Skills)
  // =========================================================
  List<pw.Widget> _buildLayoutTech(Map<String, dynamic> data) {
    return [
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [_header(data, fontSize: 24, color: PdfColors.teal900)],
      ),
      pw.Container(height: 5, color: PdfColors.teal),
      pw.SizedBox(height: 10),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [_contactInfo(data)],
      ),
      pw.SizedBox(height: 20),
      _sectionTitle("Technical Skills", color: PdfColors.teal),
      _skills(data), // Reuse skills but maybe customize widget inside if needed
      pw.SizedBox(height: 10),
      _sectionTitle("Work History", color: PdfColors.teal),
      _experience(data),
      _sectionTitle("Academic Background", color: PdfColors.teal),
      _education(data),
      _projects(data),
    ];
  }

  // =========================================================
  // 🎨 THEME 8: CORPORATE (Boxed Headers)
  // =========================================================
  List<pw.Widget> _buildLayoutCorporate(Map<String, dynamic> data) {
    return [
      _header(data, fontSize: 26),
      pw.SizedBox(height: 10),
      _contactInfo(data),
      pw.SizedBox(height: 20),

      // Boxed Title Style
      pw.Container(
        width: double.infinity,
        color: PdfColors.grey300,
        padding: const pw.EdgeInsets.all(5),
        child: pw.Text(
          "SUMMARY",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
      ),
      pw.SizedBox(height: 5),
      _bio(data),
      pw.SizedBox(height: 10),

      pw.Container(
        width: double.infinity,
        color: PdfColors.grey300,
        padding: const pw.EdgeInsets.all(5),
        child: pw.Text(
          "EXPERIENCE",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
      ),
      pw.SizedBox(height: 5),
      _experience(data),

      pw.Container(
        width: double.infinity,
        color: PdfColors.grey300,
        padding: const pw.EdgeInsets.all(5),
        child: pw.Text(
          "EDUCATION",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
      ),
      pw.SizedBox(height: 5),
      _education(data),

      pw.Container(
        width: double.infinity,
        color: PdfColors.grey300,
        padding: const pw.EdgeInsets.all(5),
        child: pw.Text(
          "SKILLS",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
      ),
      pw.SizedBox(height: 5),
      _skills(data),
      _projects(data),
    ];
  }

  // =========================================================
  // 🎨 THEME 9: ELEGANT (Purple, Serif-style vibes)
  // =========================================================
  List<pw.Widget> _buildLayoutElegant(Map<String, dynamic> data) {
    return [
      pw.Center(child: _header(data, fontSize: 30, color: PdfColors.purple900)),
      pw.Center(
        child: pw.Text(
          "CURRICULUM VITAE",
          style: const pw.TextStyle(letterSpacing: 3, fontSize: 10),
        ),
      ),
      pw.SizedBox(height: 10),
      pw.Divider(color: PdfColors.purple200),
      pw.Center(child: _contactInfo(data)),
      pw.SizedBox(height: 20),

      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _sectionTitle("Experience", color: PdfColors.purple900),
                _experience(data),
                _sectionTitle("Projects", color: PdfColors.purple900),
                _projects(data),
              ],
            ),
          ),
          pw.SizedBox(width: 20),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _sectionTitle("Education", color: PdfColors.purple900),
                _education(data),
                _sectionTitle("Skills", color: PdfColors.purple900),
                _skills(data),
                _sectionTitle("Languages", color: PdfColors.purple900),
                _languages(data),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  // =========================================================
  // 🎨 THEME 10: COMPACT (Dense, for 1-pagers)
  // =========================================================
  List<pw.Widget> _buildLayoutCompact(Map<String, dynamic> data) {
    return [
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          _header(data, fontSize: 20),
          _contactInfo(data, isVertical: true),
        ],
      ),
      pw.Divider(),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 3,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _sectionTitle("Experience", fontSize: 12),
                _experience(data),
              ],
            ),
          ),
          pw.SizedBox(width: 10),
          pw.Expanded(
            flex: 2,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _sectionTitle("Skills", fontSize: 12),
                _skills(data),
                _sectionTitle("Education", fontSize: 12),
                _education(data),
                _projects(data),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  // =========================================================
  // 🛠️ REUSABLE WIDGETS (The Engine)
  // =========================================================

  pw.Widget _header(
    Map<String, dynamic> data, {
    double fontSize = 24,
    PdfColor color = PdfColors.black,
  }) {
    if (data['fullName'] == null) return pw.Container();
    return pw.Text(
      "${data['fullName']}".trim(),
      style: pw.TextStyle(
        fontSize: fontSize,
        fontWeight: pw.FontWeight.bold,
        color: color,
      ),
    );
  }

  pw.Widget _sectionTitle(
    String title, {
    PdfColor color = PdfColors.black,
    bool isUppercase = false,
    bool isCentered = false,
    double fontSize = 16,
  }) {
    final textWidget = pw.Text(
      isUppercase ? title.toUpperCase() : title,
      style: pw.TextStyle(
        fontSize: fontSize,
        fontWeight: pw.FontWeight.bold,
        color: color,
      ),
    );

    if (isCentered)
      return pw.Center(
        child: pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 5),
          child: textWidget,
        ),
      );
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 10, bottom: 5),
      child: textWidget,
    );
  }

  pw.Widget _contactInfo(Map<String, dynamic> data, {bool isVertical = false}) {
    List<String> details = [];

    // 🛠️ Helper function to safely clean data
    String? safeText(dynamic value) {
      if (value == null) return null;

      // 1. Convert everything (int, double, etc) to String
      String str = value.toString().trim();

      // 2. Check for empty or "null" string literal
      if (str.isEmpty || str.toLowerCase() == 'null') return null;

      return str;
    }

    // Apply the helper
    String? email = safeText(data['email']);
    String? phone = safeText(
      data['phone'],
    ); // This handles int/double safely now
    String? location = safeText(data['location']);

    if (email != null) details.add(email);
    if (phone != null) details.add(phone);
    if (location != null) details.add(location);

    if (details.isEmpty) return pw.Container();

    // ... Rest of your UI logic (Horizontal or Vertical)
    if (isVertical) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: details
            .map(
              (e) => pw.Text(
                e,
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey700,
                ),
              ),
            )
            .toList(),
      );
    }

    return pw.Wrap(
      spacing: 10,
      children: details
          .map(
            (e) => pw.Text(
              "$e  • ",
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
          )
          .toList(),
    );
  }

  pw.Widget _bio(Map<String, dynamic> data, {bool isCentered = false}) {
    if (data['summary'] == null) return pw.Container();
    return pw.Text(
      data['summary'],
      textAlign: isCentered ? pw.TextAlign.center : pw.TextAlign.left,
      style: const pw.TextStyle(fontSize: 10, lineSpacing: 1.5),
    );
  }

  pw.Widget _skills(Map<String, dynamic> data) {
    if (data['skills'] == null) return pw.Container();
    final skills = data['skills'] as List;
    if (skills.isEmpty) return pw.Container();

    return pw.Wrap(
      spacing: 5,
      runSpacing: 5,
      children: skills
          .map(
            (s) => pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 2,
              ),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                borderRadius: pw.BorderRadius.circular(2),
              ),
              child: pw.Text("$s", style: const pw.TextStyle(fontSize: 9)),
            ),
          )
          .toList(),
    );
  }

  pw.Widget _experience(Map<String, dynamic> data) {
    if (data['experience'] == null) return pw.Container();
    return pw.Column(
      children: (data['experience'] as List).map((exp) {
        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 8),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    exp['role'] ?? '',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  pw.Text(
                    exp['duration'] ?? '',
                    style: const pw.TextStyle(
                      fontSize: 9,
                      color: PdfColors.grey600,
                    ),
                  ),
                ],
              ),
              pw.Text(
                exp['company'] ?? '',
                style: pw.TextStyle(
                  fontStyle: pw.FontStyle.italic,
                  fontSize: 10,
                ),
              ),
              if (exp['description'] != null)
                pw.Text(
                  exp['description'],
                  style: const pw.TextStyle(fontSize: 9),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  pw.Widget _education(Map<String, dynamic> data) {
    if (data['education'] == null) return pw.Container();
    return pw.Column(
      children: (data['education'] as List).map((edu) {
        String date = "${edu['startDate'] ?? ''} - ${edu['endDate'] ?? ''}";
        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 5),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    edu['institution'] ?? '',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  pw.Text(
                    "${edu['degree']} ${edu['fieldOfStudy']}",
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
              pw.Text(
                date,
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  pw.Widget _projects(Map<String, dynamic> data) {
    if (data['projects'] == null || (data['projects'] as List).isEmpty)
      return pw.Container();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 10),
        pw.Text(
          "Projects",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
        ),
        pw.SizedBox(height: 5),
        ...(data['projects'] as List).map((proj) {
          return pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 5),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  proj['title'] ?? '',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
                pw.Text(
                  proj['description'] ?? '',
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  pw.Widget _languages(Map<String, dynamic> data) {
    if (data['languages'] == null) return pw.Container();
    return pw.Wrap(
      spacing: 5,
      children: (data['languages'] as List)
          .map(
            (l) =>
                pw.Text(l.toString(), style: const pw.TextStyle(fontSize: 9)),
          )
          .toList(),
    );
  }

  pw.Widget _certifications(Map<String, dynamic> data) {
    if (data['certifications'] == null) return pw.Container();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: (data['certifications'] as List)
          .map(
            (c) => pw.Text(
              c['name'] ?? '',
              style: const pw.TextStyle(fontSize: 9),
            ),
          )
          .toList(),
    );
  }
}
