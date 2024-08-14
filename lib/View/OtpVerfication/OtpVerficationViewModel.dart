import 'package:flutter/material.dart';

class OtpVerificationViewModel extends ChangeNotifier {
  String _otp = '';
  String _errorMessage = '';

  String get otp => _otp;
  String get errorMessage => _errorMessage;

  void updateOtp(String value) {
    _otp = value;
    notifyListeners();
  }

  Future<void> verifyOtp() async {
    try {
      
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Verification failed. Please try again.';
    } finally {
      notifyListeners();
    }
  }

  Future<void> resendOtp() async {
    try {
      

      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to resend OTP. Please try again.';
    } finally {
      notifyListeners();
    }
  }
}
