import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserListViewModel extends ChangeNotifier {
  String _name = '';
  int _age = 0;
  File? imageFile;
  String selectedSortOption = 'all';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void updateName(String name) {
    _name = name;
    // notifyListeners();
  }

  void updateAge(String age) {
    _age = int.parse(age);
    // notifyListeners();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<String> updateAvatarUrl(File? imageData, String uid) async {
    if (imageData == null) {
      return '';
    }

    final storageRef = FirebaseStorage.instance.ref();
    final folderRef = storageRef.child('images');
    final imageRef = folderRef.child('$uid.jpg');
    await imageRef.putFile(imageData);
    return await imageRef.getDownloadURL();
  }

  Future<bool> addUser() async {
    try {
      var userData = await _firestore.collection('users').add({
        'name': _name,
        'age': _age,
        'avatarUrl': '',
      });
      var imageUrl = await updateAvatarUrl(imageFile, userData.id);
      await _firestore.collection('users').doc(userData.id).update({
        'name': _name,
        'age': _age,
        'avatarUrl': imageUrl,
      });
      return true;
    } catch (e) {
      // Handle errors
      print('Error adding user: $e');
    }
    return false;
  }

  Stream<QuerySnapshot> getUsersStream() {
    if (selectedSortOption == 'age_younger') {
      return _firestore
          .collection('users')
          .where('age', isLessThan: 60)
          .snapshots();
    } else if (selectedSortOption == 'age_elder') {
      return _firestore
          .collection('users')
          .where('age', isGreaterThanOrEqualTo: 60)
          .snapshots();
    } else {
      return _firestore.collection('users').snapshots();
    }
  }

  void filterChanged(String option) {
    selectedSortOption = option;
    notifyListeners();
  }
}
