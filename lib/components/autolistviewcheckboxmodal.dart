import 'package:flutter/material.dart';
import 'package:job_circle/models/autocompleteCheckBoxModel.dart';

class DialogCheckBoxList extends StatefulWidget {
  final List<AutoCompleteCheckBoxModel> itemsData;
  final Function(List<AutoCompleteCheckBoxModel>)? onSelected;
  final String dialogTitle;
  final ListTile Function(AutoCompleteCheckBoxModel data)? tile;
  final bool? isCustomTile;
  const DialogCheckBoxList(
      {Key? key,
      required this.itemsData,
      this.onSelected,
      required this.dialogTitle,
      this.isCustomTile = false,
      this.tile})
      : super(key: key);

  @override
  State<DialogCheckBoxList> createState() => _DialogCheckBoxListState();
}

class _DialogCheckBoxListState extends State<DialogCheckBoxList> {
  late List<AutoCompleteCheckBoxModel> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _runFilter('');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.dialogTitle),
      content: setupAlertDialoadContainer(),
    );
  }

  Widget setupAlertDialoadContainer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height -
          50, // Change as per your requirement
      width: MediaQuery.of(context).size.width -
          10, // Change as per your requirement
      child: Column(
        children: [
          TextField(
            onChanged: (value) => _runFilter(value),
            decoration: const InputDecoration(
                labelText: 'Search', suffixIcon: Icon(Icons.search)),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: _filteredData.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        title: Text(_filteredData[index].label),
                        onChanged: (newValue) {
                          setState(() {
                            _filteredData[index].checked = newValue!;
                          });
                        },
                        value: _filteredData[index].checked,
                      );
                    },
                  )
                : const Text(
                    'No results found',
                    style: TextStyle(fontSize: 24),
                  ),
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () => {
                        setState(() {
                          widget.onSelected!(_filteredData);
                        })
                      },
                  child: const Text("Ok"))
            ],
          )
        ],
      ),
    );
  }

  _runFilter(String enteredKeyword) {
    List<AutoCompleteCheckBoxModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = widget.itemsData;
    } else {
      results = widget.itemsData
          .where((item) =>
              item.label.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    setState(() {
      _filteredData = results;
    });
  }
}
