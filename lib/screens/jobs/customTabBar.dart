// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';

class MultiSelectTabBar extends StatefulWidget {
  final List<Tab> tabs;

  const MultiSelectTabBar({super.key, required this.tabs});

  @override
  _MultiSelectTabBarState createState() => _MultiSelectTabBarState();
}

class _MultiSelectTabBarState extends State<MultiSelectTabBar> {
  List<bool> _isSelected = [];

  @override
  void initState() {
    super.initState();
    _isSelected = List.generate(widget.tabs.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            for (int i = 0; i < widget.tabs.length; i++)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isSelected[i] = !_isSelected[i];
                    });
                  },
                  child: Column(
                    children: [
                      Checkbox(
                        value: _isSelected[i],
                        onChanged: (value) {
                          setState(() {
                            _isSelected[i] = value ?? false;
                          });
                        },
                      ),
                      Tab(
                        child: Text(
                          widget.tabs[i].text!,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: widget.tabs.map((tab) => Container()).toList(),
          ),
        ),
      ],
    );
  }
}
