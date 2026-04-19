import 'package:flutter/material.dart';
import '../../models/content/content_model.dart';
import '../../services/content/content_service.dart';

class ContentProvider extends ChangeNotifier {
  final ContentService _service = ContentService();

  List<ContentModel> _allContent = [];
  List<ContentModel> _filtered = [];
  String _selectedCategory = 'ALL';
  bool _isLoading = false;
  String? _error;

  List<ContentModel> get content => _filtered;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final List<String> categories = [
    'ALL',
    'PCOS_BASICS',
    'NUTRITION',
    'EXERCISE',
    'MENTAL_HEALTH',
    'TREATMENT',
    'LIFESTYLE',
  ];

  Future<void> fetchContent() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _allContent = await _service.getAllContent();
      _applyFilter();
    } catch (e) {
      _error = 'Failed to load articles.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_selectedCategory == 'ALL') {
      _filtered = List.from(_allContent);
    } else {
      _filtered = _allContent
          .where((c) => c.category == _selectedCategory)
          .toList();
    }
  }
}
