import 'dart:io';
import 'package:flutter/material.dart';

class UserProfile extends ChangeNotifier {
  String _name = 'John Doe';
  String _email = 'john.doe@example.com';
  int _phoneNumber = 6282170474047;
  String _password = 'password';
  int _pin = 123456;
  File? _avatarImage;
  double _portofolio = 0;
  double _nilaiPortofolio = 0;
  bool _verifikasi = false;

  String? get name => _name;
  String? get email => _email;
  int? get phoneNumber => _phoneNumber;
  String? get password => _password;
  int? get pin => _pin;
  File? get avatarImage => _avatarImage;
  double? get portofolio => _portofolio;
  double? get nilaiPortofolio => _nilaiPortofolio;
  bool? get verifikasi => _verifikasi;

  set name(val) {
    _name = val;
    notifyListeners();
  }

  set email(val) {
    _email = val;
    notifyListeners();
  }

  set phoneNumber(val) {
    _phoneNumber = val;
    notifyListeners();
  }

  set password(val) {
    _password = val;
    notifyListeners();
  }

  set pin(val) {
    _pin = val;
    notifyListeners();
  }

  set avatarImage(val) {
    _avatarImage = val;
    notifyListeners();
  }

  set verifikasi(val) {
    _verifikasi = val;
    notifyListeners();
  }

  void saveProfile() {
    print('Name: $name');
    print('Email: $email');
    print('Phone Number: $phoneNumber');
    if (avatarImage != null) {
      print('Avatar Path: ${avatarImage!.path}');
    }
  }

  bool increasePortofolio(double amount) {
    if (amount > 0) {
      _portofolio += amount;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool resetPortofolio() {
    _portofolio = 0;
    notifyListeners();
    return true;
  }

  bool increaseNilaiPortofolio(double amount) {
    if (amount > 0) {
      _nilaiPortofolio = amount;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool resetNilaiPortofolio() {
    _nilaiPortofolio = 0;
    notifyListeners();
    return true;
  }
}
