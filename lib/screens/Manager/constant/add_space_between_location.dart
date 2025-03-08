class AddSpaceBetween {
  /// Capitalizes the first letter of each word in a comma-separated string.
  static String capitalizeWords(String text) {
    return text
        .split(',')
        .map((word) => word.trim().isNotEmpty
            ? word.trim()[0].toUpperCase() +
                word.trim().substring(1).toLowerCase()
            : '')
        .join(', ');
  }
}
