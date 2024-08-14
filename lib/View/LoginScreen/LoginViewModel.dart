import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  String _phoneNumber = '';

  String get phoneNumber => _phoneNumber;

  void updatePhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  void sendOtp() {
    
    notifyListeners();
  }
}
