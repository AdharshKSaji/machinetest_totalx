import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserListViewModel extends ChangeNotifier {
  String _name = '';
  String _age = '';
  String _avatarUrl = '';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void updateName(String name) {
    _name = name;
    notifyListeners();
  }

  void updateAge(String age) {
    _age = age;
    notifyListeners();
  }

  void updateAvatarUrl(String avatarUrl) {
    _avatarUrl = avatarUrl;
    notifyListeners();
  }

  Future<void> addUser() async {
    if (_name.isEmpty || _age.isEmpty) {
      // Handle empty fields
      throw Exception('Name and Age are required');
    }

    try {
      await _firestore.collection('users').add({
        'name': _name,
        'age': _age,
        'avatarUrl': _avatarUrl,
      });
    } catch (e) {
      // Handle errors
      throw Exception('Failed to add user: $e');
    }
  }

  Stream<QuerySnapshot> getUsersStream() {
    return _firestore.collection('users').snapshots();
  }
}
