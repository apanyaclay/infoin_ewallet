import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AsuransiProvider extends ChangeNotifier {
   Timer? _expiryCheckTimer;

  AsuransiProvider() {
    _startExpiryCheck();
  }

  // Memulai timer untuk memeriksa asuransi kedaluwarsa setiap 24 jam
  void _startExpiryCheck() {
    _expiryCheckTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkExpiredAsuransi();
    });
  }

  @override
  void dispose() {
    _expiryCheckTimer?.cancel(); // Membatalkan timer saat provider tidak digunakan
    super.dispose();
  }
  // Daftar asuransi yang ada
  final List<Map<String, dynamic>> _allAsuransi = [
    {'title': 'Asuransi Jiwa', 'icon': Icons.favorite, 'premiumAmount': 1500000.0},
    {'title': 'Asuransi Kesehatan', 'icon': Icons.health_and_safety, 'premiumAmount': 2000000.0},
    {'title': 'Asuransi Kendaraan', 'icon': Icons.directions_car, 'premiumAmount': 500000.0},
    {'title': 'Asuransi Rumah', 'icon': Icons.home, 'premiumAmount': 1000000.0},
    {'title': 'Asuransi Perjalanan', 'icon': Icons.flight, 'premiumAmount': 300000.0},
    {'title': 'Asuransi Pendidikan', 'icon': Icons.school, 'premiumAmount': 2500000.0},
    {'title': 'Asuransi Gadget', 'icon': Icons.phone_android, 'premiumAmount': 800000.0},
    {'title': 'Asuransi Hewan Peliharaan', 'icon': Icons.pets, 'premiumAmount': 600000.0},
    {'title': 'Asuransi Kebakaran', 'icon': Icons.fire_extinguisher, 'premiumAmount': 1200000.0},
    {'title': 'Asuransi Pekerjaan', 'icon': Icons.work, 'premiumAmount': 1800000.0},
    {'title': 'Asuransi Sepeda Motor', 'icon': Icons.motorcycle, 'premiumAmount': 400000.0},
  ];

  // Daftar asuransi yang sudah dibeli
  final List<Map<String, dynamic>> _purchasedAsuransi = [];

  // Mendapatkan semua asuransi
  List<Map<String, dynamic>> get allAsuransi => _allAsuransi;

  // Mendapatkan asuransi yang sudah dibeli
  List<Map<String, dynamic>> get purchasedAsuransi => _purchasedAsuransi;

  // Menambah asuransi ke daftar pembelian
  void purchaseAsuransi(String title) {
    final asuransi = _allAsuransi.firstWhere((a) => a['title'] == title);
    if (!_purchasedAsuransi.any((a) => a['title'] == title)) {
      _purchasedAsuransi.add({
        ...asuransi,
        'purchaseDate': DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()),
        'expiryDate': DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now().add(const Duration(days: 365))),
      });
      notifyListeners();
    }
  }

  // Menghapus asuransi dari daftar pembelian
  void cancelAsuransi(String title) {
    _purchasedAsuransi.removeWhere((a) => a['title'] == title);
    notifyListeners();
  }

  // Memeriksa apakah asuransi sudah dibeli
  bool isAsuransiPurchased(String title) {
    return _purchasedAsuransi.any((a) => a['title'] == title);
  }
  Map<String, dynamic>? getAsuransiDetails(String title) {
    return _purchasedAsuransi.firstWhere((a) => a['title'] == title, orElse: () => {});
  }

  // Memeriksa dan menghapus asuransi yang sudah kedaluwarsa
  void _checkExpiredAsuransi() {
    final now = DateTime.now();
    _purchasedAsuransi.removeWhere((asuransi) {
      final expiryDate = DateFormat('dd MMM yyyy, HH:mm').parse(asuransi['expiryDate']);
      return now.isAfter(expiryDate) || now.isAtSameMomentAs(expiryDate);
    });
    notifyListeners();
  }
}
