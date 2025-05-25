import 'package:flutter/material.dart';

class WithdrawalProvider with ChangeNotifier {
  List<Map<String, dynamic>> _withdrawals = [
    {'amount': 100.00, 'accepted': true},
    {'amount': 50.00, 'accepted': false},
  ];
  bool _isLoading = false;
  String? _error;
  String? _message;
  double _balance = 1000.00; // Mock balance

  List<Map<String, dynamic>> get withdrawals => _withdrawals;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get message => _message;

  void requestWithdrawal(double amount) {
    if (amount <= 0) {
      _error = 'Amount must be positive';
      _message = 'Amount must be positive';
      notifyListeners();
      return;
    }
    if (amount > _balance) {
      _error = 'Insufficient balance';
      _message = 'Insufficient balance';
      notifyListeners();
      return;
    }
    _isLoading = true;
    _error = null;
    _message = null;
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      _balance -= amount;
      _withdrawals = [
        ..._withdrawals,
        {'amount': amount, 'accepted': false}
      ];
      _message = 'Withdrawal requested successfully';
      _isLoading = false;
      notifyListeners();
    });
  }

  void setError(String error) {
    _error = error;
    _message = error;
    notifyListeners();
  }

  void clearMessage() {
    _message = null;
    _error = null;
    notifyListeners();
  }
}
