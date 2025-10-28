class SalaryRoundOff {
  static String customRoundOff(String value) {
    if (value == "null" || value.trim().isEmpty || value == "0.0") {
      return "N/A";
    }
    double number = double.tryParse(value) ?? 0.0;
    int integerPart = number.floor();
    int firstDecimalDigit = ((number * 10).toInt()) % 10;

    if (firstDecimalDigit >= 5) {
      return (integerPart + 1).toString();
    } else {
      return integerPart.toString();
    }
  }
}
