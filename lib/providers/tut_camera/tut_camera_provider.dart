import 'package:flutter/material.dart';

enum EPageState { next, previous, none }

class TutCameraProvider with ChangeNotifier {
  late EPageState _ePageState = EPageState.none;
  EPageState get ePageState => _ePageState;

  // Config next page carousel
  void nextPage() {
    _ePageState = EPageState.next;
    notifyListeners();
  }

  // Config previous page carousel
  void prePage() {
    _ePageState = EPageState.previous;
    notifyListeners();
  }
}
