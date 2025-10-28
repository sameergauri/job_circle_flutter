import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/job_title_model.dart';

class SuggestionProvider extends ChangeNotifier {
  List<JobTitleModel1> _suggestions = [];
  bool _isLoading = false;
  String? _error;

  List<JobTitleModel1> get suggestions => _suggestions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSuggestions(
    String pattern,
    String name,
    SuggestionType type,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final uri = type == SuggestionType.jobTitle
          ? Uri.parse(
              '${GlobalConstants.fetchmasterdatasuggestionurl}$name&pageNumber=1&pageSize=10000',
            )
          : type == SuggestionType.resideat
          ? Uri.parse(
              '${GlobalConstants.fetchmasterdatasuggestionurl}$name&pageNumber=1&pageSize=10000',
            )
          : Uri.parse(GlobalConstants.fetchcompanydataurl);

      final response =
          await (type == SuggestionType.jobTitle ||
                  type == SuggestionType.resideat
              ? http.post(uri)
              : http.get(uri));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<JobTitleModel1> suggestions = [];
        Set<int> uniqueIds = {};

        List<dynamic> content =
            type == SuggestionType.jobTitle || type == SuggestionType.resideat
            ? data['resultData']['masterData']['content']
            : data['resultData']['content'];

        for (var entry in content) {
          String value;
          String? code;

          if (type == SuggestionType.jobTitle) {
            value = entry['value'].toString();
            code = entry['url_slug']?.toString();
          } else if (type == SuggestionType.resideat) {
            // Format "formateData" → remove last, add space after comma
            List<String> parts = entry['formateData'].toString().split(',');
            if (parts.length > 1) {
              parts.removeLast(); // remove last element
            }
            value = parts.map((e) => e.trim()).join(', ');
            code = entry['value']?.toString(); // as per logic
          } else {
            value = entry['name'].toString();
            code = entry['short_code']?.toString();
          }

          if (value.toLowerCase().contains(pattern.toLowerCase()) ||
              (code != null &&
                  code.toLowerCase().contains(pattern.toLowerCase()))) {
            JobTitleModel1 suggestion = type == SuggestionType.jobTitle
                ? JobTitleModel1.fromJson(entry)
                : JobTitleModel1.fromJson({
                    'id': entry['id'],
                    'group_name': 'company',
                    'code': code,
                    'value': value, // << this is the formatted value
                    'active': entry['active'] ?? 1,
                    'deleted': entry['deleted'] ?? 0,
                    'url_slug': code,
                    'parentid': entry['parentid'] ?? 0,
                    'parentname': entry['parentname'] ?? '',
                    'orderno': entry['orderno'] ?? 0,
                    'extra': entry['extra'],
                    'formateData': entry['formateData'] ?? '',
                  });

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
