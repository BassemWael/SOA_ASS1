import 'package:flutter/material.dart';

class CounterProvider extends ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  void setCounter(int value) {
    _counter = value;
    notifyListeners();
  }

  void decrementCounter() {
    if (_counter > 0) {
      _counter--;
      notifyListeners();
    }
  }

  void resetCounter() {
    _counter = 0;
    notifyListeners();
  }
}
