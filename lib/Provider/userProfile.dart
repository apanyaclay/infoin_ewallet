import 'dart:io';
import 'package:flutter/material.dart';

class UserProfile extends ChangeNotifier {
  String _name = 'Johanes Nicky C. S';
  String _email = 'john.doe@example.com';
  int _phoneNumber = 6282170474047;
  String _password = 'apanya';
  File? _avatarImage;

  String? get name => _name;
  String? get email => _email;
  int? get phoneNumber => _phoneNumber;
  String? get password => _password;
  File? get avatarImage => _avatarImage;

  set name(val){
    _name = val;
    notifyListeners();
  }
  set email(val){
    _email = val;
    notifyListeners();
  }
  set phoneNumber(val){
    _phoneNumber = val;
    notifyListeners();
  }
  set password(val){
    _password = val;
    notifyListeners();
  }
  set avatarImage(val){
    _avatarImage = val;
    notifyListeners();
  }
  void saveProfile() {
    // Tambahkan logika penyimpanan sesuai dengan kebutuhan aplikasi Anda
    print('Name: $name');
    print('Email: $email');
    print('Phone Number: $phoneNumber');
    print('Password: $password');
    if (avatarImage != null) {
      print('Avatar Path: ${avatarImage!.path}');
    }
  }
}