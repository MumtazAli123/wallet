
import 'package:flutter/cupertino.dart';

class AddressChanger extends ChangeNotifier {
  int _counter = 0;
  int get count => _counter;

  showSelectedFriends(dynamic val) {
    _counter = val;
    notifyListeners();
  }

  void removeAddress() {
    _counter = 0;
    notifyListeners();
  }
}