import 'package:flutter/material.dart';

class StatemanagementProvider extends ChangeNotifier {
  bool _loading = false;

  bool get loading => _loading;

  bool setLoading(bool value) {
    _loading = value;
    notifyListeners();
    return _loading;
  }
}
