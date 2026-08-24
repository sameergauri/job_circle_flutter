import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/model/business_page/company_suggestion_model.dart';

class BusinessCompanySuggestionProvider extends ChangeNotifier {
  List<ApprovedCompany> _suggestions = [];
  bool _isLoading = false;
  String? _error;

  List<ApprovedCompany> get suggestions => _suggestions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSuggestions(String pattern) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final uri = Uri.parse(GlobalConstants.fetchApproveCompany);

      final response = await (http.get(uri));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<ApprovedCompany> suggestions = [];
        Set<int> uniqueIds = {};

        List<dynamic> content = data['resultData'];

        for (var entry in content) {
          String value;

          value = entry['companyName'].toString();

          if (value.toLowerCase().contains(pattern.toLowerCase())) {
            ApprovedCompany suggestion = ApprovedCompany.fromJson(entry);

            if (!uniqueIds.contains(suggestion.id)) {
              uniqueIds.add(suggestion.id);
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
