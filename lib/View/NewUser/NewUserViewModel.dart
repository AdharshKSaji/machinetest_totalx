
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserViewModel extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String _name = '';
  String _age = '';

  XFile? get image => _image;
  String get name => _name;
  String get age => _age;

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = pickedFile;
      notifyListeners();
    }
  }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setAge(String age) {
    _age = age;
    notifyListeners();
  }

  bool validate() {
    return _name.isNotEmpty && _age.isNotEmpty && _image != null;
  }

  void save() {
    if (validate()) {
      // Save the user data
      print('Name: $_name, Age: $_age, Image Path: ${_image!.path}');
    } else {
      throw Exception('Validation failed');
    }
  }
}
