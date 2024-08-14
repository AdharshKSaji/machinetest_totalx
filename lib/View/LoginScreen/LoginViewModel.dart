import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  String _phoneNumber = '';
  String _verificationId = '';
  bool _isCodeSent = false;

  String get phoneNumber => _phoneNumber;
  bool get isCodeSent => _isCodeSent;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void updatePhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  Future<void> sendOtp() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
  
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        
        print('Verification failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        _isCodeSent = true;
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> verifyOtp(String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
    } catch (e) {
    
      print('OTP verification failed: $e');
    }
  }
}
