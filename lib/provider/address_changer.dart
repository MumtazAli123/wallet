
import 'package:flutter/cupertino.dart';

class AddressChanger extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  showSelectedFriends(dynamic val) {
    _counter = val;
    notifyListeners();
  }
}