class SelectedOption {
  final String selectedValue;
  final String subValue;

  SelectedOption(this.selectedValue, this.subValue);
}

class JobItem {
  int id;
  bool switchValue;

  JobItem({
    required this.id,
    required this.switchValue,
  });
}
