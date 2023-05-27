import 'package:flutter/material.dart';

class AddButtonVisibilityWidget extends StatefulWidget {
  final List<dynamic>? suggestions;
  final String? customValue;
  final List<dynamic>? selectedValuesList;
  final VoidCallback? onAddButtonPressed;
  final bool isLoading;

  const AddButtonVisibilityWidget(
      {Key? key,
      this.suggestions,
      this.customValue,
      this.selectedValuesList,
      this.onAddButtonPressed,
      required this.isLoading})
      : super(key: key);

  @override
  _AddButtonVisibilityWidgetState createState() =>
      _AddButtonVisibilityWidgetState();
}

class _AddButtonVisibilityWidgetState extends State<AddButtonVisibilityWidget> {
  bool showAddButton = false;
 // bool isLoading = false;

  @override
  void initState() {
    super.initState();
    updateAddButtonVisibility();
  }

  @override
  void didUpdateWidget(AddButtonVisibilityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateAddButtonVisibility();
  }

  void updateAddButtonVisibility() {
    
    setState(() {
      showAddButton = !widget.suggestions!.contains(widget.customValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if ((showAddButton || widget.isLoading) &&
            widget.customValue != null &&
            widget.customValue!.isNotEmpty)
          InkWell(
            onTap: widget.onAddButtonPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              width: double.infinity,
              child: widget.isLoading
                  ? const Text('Searching...')
                  : const Text("Add New Skill"),
            ),
          ),
      ],
    );
  }
}
