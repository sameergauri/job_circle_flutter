// ignore_for_file: must_call_super

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/faq/faq_model.dart';
import 'package:job_circle/src/services/faq/faq_service.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';

class FaqProvider extends ChangeNotifier {
  final FaqService _faqService = FaqService();

  List<FaqItem> _allFaqs = [];
  List<String> _categories = ['All'];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;
  TextEditingController searchtext = TextEditingController();

  // Currently reacting FAQ id (for loading indicator on button)
  int? _reactingFaqId;

  List<FaqItem> get allFaqs => _allFaqs;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int? get reactingFaqId => _reactingFaqId;

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

  Future<void> loadFaqs({String appType = 'JOBSEEKER', int? userId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allFaqs = await _faqService.fetchFaqs(appType: appType,userid: SharedPrefsHelper.getInt(ESharedPreferences.user_id));

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

  /// Like / Dislike / Reset
  Future<void> reactToFaq({
    required int faqId,
    required bool? like,
    required bool? dislike,
  }) async {
    // Optimistic update
    final index = _allFaqs.indexWhere((f) => f.id == faqId);
    if (index == -1) return;

    final oldFaq = _allFaqs[index];

    // Calculate new state
    bool newUserLiked = like == true;
    bool newUserDisliked = dislike == true;

    int newLikeCount = oldFaq.likeCount;
    int newDislikeCount = oldFaq.dislikeCount;

    // Remove old reaction effect
    if (oldFaq.userLiked) newLikeCount--;
    if (oldFaq.userDisliked) newDislikeCount--;

    // Add new reaction effect
    if (newUserLiked) newLikeCount++;
    if (newUserDisliked) newDislikeCount++;

    // Update local list
    _allFaqs[index] = oldFaq.copyWith(
      userLiked: newUserLiked,
      userDisliked: newUserDisliked,
      likeCount: newLikeCount < 0 ? 0 : newLikeCount,
      dislikeCount: newDislikeCount < 0 ? 0 : newDislikeCount,
    );

    _reactingFaqId = faqId;
    notifyListeners();

    try {
      await _faqService.reactToFaq(
        userId: SharedPrefsHelper.getInt(ESharedPreferences.user_id),
        faqId: faqId,
        like: like,
        dislike: dislike,
      );
    } catch (e) {
      // Revert on error
      _allFaqs[index] = oldFaq;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      rethrow;
    } finally {
      _reactingFaqId = null;
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
