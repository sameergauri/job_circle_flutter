// ignore_for_file: must_call_super

import 'package:flutter/material.dart';
import 'package:job_circle/src/model/faq/faq_model.dart';
import 'package:job_circle/src/services/faq/faq_service.dart';

class FaqProvider extends ChangeNotifier {
  final FaqService _faqService = FaqService();

  List<FaqItem> _allFaqs = [];
  List<String> _categories = ['All'];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;
  TextEditingController searchtext = TextEditingController();

  List<FaqItem> get allFaqs => _allFaqs;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Filtered list based on selected category tab and search query
  List<FaqItem> get filteredFaqs {
    return _allFaqs.where((faq) {
      final matchesCategory =
          _selectedCategory == 'All' ||
          faq.category.name.toLowerCase() == _selectedCategory.toLowerCase();

      final matchesSearch =
          faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          faq.answer.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<void> loadFaqs({String appType = 'JOBSEEKER'}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allFaqs = await _faqService.fetchFaqs(appType: appType);

      // Extract unique categories dynamically
      final uniqueCategoryNames = _allFaqs
          .map((e) => e.category.name)
          .toSet()
          .toList();

      _categories = ['All', ...uniqueCategoryNames];
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<FaqItem> filteredFaqsForCategory(String category) {
    return _allFaqs.where((faq) {
      final matchesCategory =
          category == 'All' ||
          faq.category.name.toLowerCase() == category.toLowerCase();
      final matchesSearch =
          _searchQuery.isEmpty ||
          faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          faq.answer.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  int filteredCountForCategory(String category) {
    return _allFaqs.where((faq) {
      final matchesCategory =
          category == 'All' ||
          faq.category.name.toLowerCase() == category.toLowerCase();
      final matchesSearch =
          _searchQuery.isEmpty ||
          faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          faq.answer.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).length;
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    if (query.isNotEmpty) {
      // Switch to first specific category that has matching results
      final match = _categories.firstWhere(
        (cat) {
          if (cat == 'All') return false;
          return _allFaqs.any(
            (faq) =>
                faq.category.name.toLowerCase() == cat.toLowerCase() &&
                (faq.question.toLowerCase().contains(query.toLowerCase()) ||
                    faq.answer.toLowerCase().contains(query.toLowerCase())),
          );
        },
        orElse: () => 'All',
      );
      _selectedCategory = match;
    } else {
      _selectedCategory = 'All';
    }
    notifyListeners();
  }

  @override
  void dispose() {
    searchtext.clear();
    _selectedCategory = "All";
    _searchQuery = '';
  }
}
