import 'package:flutter/cupertino.dart';

class HomeScreenProvider extends ChangeNotifier {
  int _currentTab = 0;

  int get currentTab => _currentTab;

  void changeTab(int index) {
    _currentTab = index;
    Future.microtask(() => notifyListeners());
  }
}
