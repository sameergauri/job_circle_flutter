// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:job_circle/models/autocompleteModel.dart';

class DialogList extends StatefulWidget {
  final List<AutoCompleteModel> itemsData;
  final Function(AutoCompleteModel)? onSelected;
  final String dialogTitle;
  final ListTile Function(AutoCompleteModel data)? tile;
  final bool? isCustomTile;
  const DialogList(
      {Key? key,
      required this.itemsData,
      this.onSelected,
      required this.dialogTitle,
      this.isCustomTile = false,
      this.tile})
      : super(key: key);

  @override
  State<DialogList> createState() => _DialogListState();
}

class _DialogListState extends State<DialogList> {
  late List<AutoCompleteModel> _filteredData = [];

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
                      if (widget.isCustomTile == false) {
                        return ListTile(
                          title: Text(_filteredData[index].label),
                          onTap: () {
                            setState(() {
                              widget.onSelected!(_filteredData[index]);
                            });
                          },
                        );
                      } else {
                        return widget.tile!(_filteredData[index]);
                      }
                    },
                  )
                : const Text(
                    'No results found',
                    style: TextStyle(fontSize: 24),
                  ),
          )
        ],
      ),
    );
  }

  _runFilter(String enteredKeyword) {
    List<AutoCompleteModel> results = [];
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
