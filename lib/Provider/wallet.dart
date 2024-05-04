import 'package:flutter/material.dart';

class WalletProvider extends ChangeNotifier {
  double _balance = 100000.50;

  double? get balance => _balance;

  bool decreaseBalance(double amount) {
    if (balance != null && _balance >= amount) {
      _balance -= amount;
      notifyListeners(); // Memberitahu listeners bahwa ada perubahan
      return true;
    }
    return false;
  }

  bool increaseBalance(double amount) {
  if (amount > 0) {
    _balance += amount;
    notifyListeners(); // Memberitahu listeners bahwa ada perubahan
    return true;
  }
  return false;
}
}

