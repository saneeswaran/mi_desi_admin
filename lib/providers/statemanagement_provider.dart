import 'package:flutter/material.dart';

class StatemanagementProvider extends ChangeNotifier {
  //checkbox in partner register
  bool _loading = false;

  bool get loading => _loading;

  //password eye in partner login and register and admin login
  bool _isObscure = false;

  bool get isObscure => _isObscure;

  bool toggleObscure() {
    _isObscure = !_isObscure;
    notifyListeners();
    return _isObscure;
  }

  //check box
  bool setLoading(bool value) {
    _loading = value;
    notifyListeners();
    return _loading;
  }
}
