import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserListViewModel extends ChangeNotifier {
  String _name = '';
  String _age = '';
  File? imageFile;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void updateName(String name) {
    _name = name;
    notifyListeners();
  }

  void updateAge(String age) {
    _age = age;
    notifyListeners();
  }

  // void updateAvatarUrl(String avatarUrl) {
  //   _avatarUrl = avatarUrl;
  //   notifyListeners();
  // }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      
        imageFile = File(pickedFile.path);
        notifyListeners();
      
    }
  }
  
  Future< String> updateAvatarUrl(File? imageData,String uid) async {
    if (imageData == null) {
      return '';
    }
  
    final storageRef = FirebaseStorage.instance.ref();
    final folderRef = storageRef.child('images');
    // final userRef = folderRef.child(currentUser?.uid ?? 'unknown');
    final imageRef = folderRef.child('$uid.jpg');
    await imageRef.putFile(imageData);
    return  await imageRef.getDownloadURL();
  }

  Future<bool> addUser() async {
    if (_name.isEmpty || _age.isEmpty) {
      // Handle empty fields
      throw Exception('Name and Age are required');
    }

    try {
    var userData=  await _firestore.collection('users').add({
        'name': _name,
        'age': _age,
        'avatarUrl': '',
      });
     var imageurl=await updateAvatarUrl(imageFile, userData.id);
    await _firestore.collection('users').doc(userData.id).update({
        'name': _name,
        'age': _age,
        'avatarUrl': imageurl,
      });
      return true;
    } catch (e) {
      // Handle errors
    }
    return false;
  }

  Stream<QuerySnapshot> getUsersStream() {
    return _firestore.collection('users').snapshots();
  }
}
