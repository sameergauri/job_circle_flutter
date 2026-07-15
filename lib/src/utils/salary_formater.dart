class SalaryFormatter {
  // Static method allows usage like: SalaryFormatter.format(...)
  static String format({
    required dynamic min,
    required dynamic max,
    required String perMonth, // "1" for Monthly, "0" for Yearly
  }) {
    double minVal = double.tryParse(min.toString()) ?? 0;
    double maxVal = double.tryParse(max.toString()) ?? 0;
    bool isMonthly = perMonth == "1";

    String formatNumber(double value) {
      if (value == 0) return "0";

      double result;
      bool addK = false;

      if (isMonthly) {
        if (value >= 1000) {
          result = value / 1000;
          addK = true;
        } else {
          return value.toInt().toString();
        }
      } else {
        result = value / 100000;
      }

      String finalString;

      // Removes extra trailing decimal digits if they evaluate to zero
      if (result % 1 == 0) {
        finalString = result.toInt().toString();
      } else {
        finalString = result
            .toStringAsFixed(2)
            .replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
      }

      return addK ? "${finalString}k" : finalString;
    }

    String minStr = formatNumber(minVal);
    String suffix = isMonthly ? "Per Month" : "LPA";

    if (maxVal == 0 || maxVal == minVal) {
      return "$minStr $suffix";
    }

    String maxStr = formatNumber(maxVal);
    return "$minStr - $maxStr $suffix";
  }
}
