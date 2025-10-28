// ignore_for_file: camel_case_types

class BulletFormatter {
  static String formatWithBullets(String input) {
    if (input.isEmpty) return input;

    // Split by '•' and clean up extra spaces
    final parts = input
        .split('•')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.isEmpty) return input;

    // Join each line with bullet prefix
    final formatted = parts.map((e) => '• $e').join('\n');

    return formatted;
  }
}

class DataAssignToNextLine {
  static String formatWithBullets(String input) {
    if (input.isEmpty) return input;

    // Split by '•' and clean up extra spaces
    final parts = input
        .split('•')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.isEmpty) return input;

    // Join each line with bullet prefix
    final formatted = parts.map((e) => e).join('\n');

    return formatted;
  }
}

class addBulletPointBeforSaving {
  /// Adds "• " to the beginning of each non-empty line.
  static String addBulletsToEachLine(String input) {
    if (input.isEmpty) return input;

    final lines = input.split('\n');

    final formattedLines = lines.map((line) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) return ''; // skip blank lines
      // Avoid adding bullet if it already starts with one
      return trimmed.startsWith('•') ? trimmed : '• $trimmed';
    }).toList();

    return formattedLines.join('\n');
  }
}


class BulletFormatterFromFullStop {  // for project to add bullte on '.' full stop....
  static String formatWithBullets(String input) {
    if (input.isEmpty) return input;

    // Split by '.' and clean up empty parts
    final parts = input
        .split('.')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.isEmpty) return input;

    // Add bullet before each sentence
    final formatted = parts.map((e) => '• $e.').join('\n');

    return formatted;
  }
}
