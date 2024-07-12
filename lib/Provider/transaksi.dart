import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransaksiProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _transactions = [];

  TransaksiProvider() {
    filterTransactions(selectedFilterOption);
  }

  void addTransaction(Map<String, dynamic> value) {
    _transactions.add(value);
    notifyListeners();
  }

  List<Map<String, dynamic>> get transactions => _transactions;

  set transactions(List<Map<String, dynamic>> value) {
    _transactions = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> _filteredTransaction = [];
  List<Map<String, dynamic>> get filteredTransaction => _filteredTransaction;

  final List<String> _filterOptions = ['Semua', 'Pemasukan', 'Pengeluaran'];
  List<String> get filterOptions => _filterOptions;

  String selectedFilterOption = 'Semua';

  void filterTransactions(String filter) {
    selectedFilterOption = filter;
    if (filter == 'Semua') {
      _filteredTransaction = transactions;
    } else {
      _filteredTransaction = transactions
          .where((transaction) => transaction['type'] == filter)
          .toList();
    }
    notifyListeners();
  }

  void filterTransactionsByDateAndType(DateTimeRange? dateRange, String transactionType) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    _filteredTransaction = _transactions.where((transaction) {
      final transactionDate = dateFormat.parse(transaction['date']);
      final isTypeMatch = transactionType == 'Semua' || transaction['type'] == transactionType;
      final isDateInRange = dateRange == null || 
        (transactionDate.isAfter(dateRange.start.subtract(const Duration(days: 1))) && 
        transactionDate.isBefore(dateRange.end.add(const Duration(days: 1))));
      return isTypeMatch && isDateInRange;
    }).toList();
    notifyListeners();
  }
}
