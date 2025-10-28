import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/model/bank/bank_list_model.dart';

class BankSuggestionProvider extends ChangeNotifier {
  List<BankModel> _suggestions = [];
  bool _isLoading = false;
  String? _error;

  List<BankModel> get suggestions => _suggestions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSuggestions(String pattern) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final uri = Uri.parse(GlobalConstants.fetchBankList);

      final response = await (http.get(uri));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<BankModel> suggestions = [];
        Set<int> uniqueIds = {};

        List<dynamic> content = data['resultData']['content'];

        for (var entry in content) {
          String value;

          value = entry['name'].toString();

          if (value.toLowerCase().contains(pattern.toLowerCase())) {
            BankModel suggestion = BankModel.fromJson(entry);

            if (!uniqueIds.contains(suggestion.id)) {
              uniqueIds.add(suggestion.id!);
              suggestions.add(suggestion);
            }
          }
        }

        _suggestions = suggestions;
      } else {
        _error = 'Failed to retrieve suggestions';
      }
    } catch (e) {
      _error = 'Error fetching suggestions: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSuggestions() {
    _suggestions = [];
    _error = null;
    notifyListeners();
  }
}
