import 'package:flutter/material.dart';

class CategoriesLogic with ChangeNotifier {
  BuildContext context;
  int tabIndex = 0;

  CategoriesLogic({required this.context});

  void onChangeTab(int index) {
    try {
      if (index == tabIndex) return;
      tabIndex = index;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
