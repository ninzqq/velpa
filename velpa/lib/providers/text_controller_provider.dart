import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchTextController extends ChangeNotifier {
  TextEditingController _searchController = TextEditingController();

  TextEditingController get searchController {
    return _searchController;
  }

  void setTextEditingController(TextEditingController controller) {
    if (_searchController != controller) {
      _searchController = controller;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

final searchTextControllerProvider =
    ChangeNotifierProvider<SearchTextController>((ref) {
  return SearchTextController();
});
